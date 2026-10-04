# MediaFlow — Architectural Decision Records (ADR)

## ADR-001: Selection of PySide6 + Qt Quick / QML over Tkinter / CustomTkinter

### Context
Desktop media utilities often rely on basic GUI frameworks like Tkinter or CustomTkinter. MediaFlow aims for a professional creator tool with hardware-accelerated graphics, smooth animations, and customizable styling.

### Decision
Use **PySide6 (Qt 6) with Qt Quick and QML**.

### Rationale
1. Qt Quick uses the Qt Scene Graph for accelerated rendering without CPU-bound widget redraws.
2. QML provides a declarative presentation layer separate from Python business logic.
3. Qt Quick supports flexible layouts, animations, and consistent custom styling.
4. PySide6 provides Python/QML bridge capabilities through `@Property`, `@Signal`, and `@Slot`.

---

## ADR-002: Layered Service and Bridge Architecture

### Context
Coupling GUI event handlers directly to network calls, disk operations, or subprocess execution makes code difficult to test and can freeze the interface.

### Decision
Enforce the four-tier architecture: `QML Presentation` → `PySide6 Bridge (QObject)` → `Python Service Layer` → `System/External Engines`.

### Rationale
1. Backend services can be tested without launching a Qt GUI.
2. The media services remain independent if the UI technology changes.
3. Each layer has a distinct responsibility and boundary.

---

## ADR-003: Subprocess Argument Lists for FFmpeg vs Shell Strings

### Context
Shell string concatenation creates injection risks and escaping bugs for filenames with spaces, quotes, or special characters.

### Decision
Use discrete argument lists (`list[str]`) with `subprocess.Popen` or `subprocess.run`, and keep `shell=False`.

### Rationale
1. Argument lists avoid shell command injection.
2. The operating system receives each argument directly, avoiding fragile platform-specific quoting.

---

## ADR-004: Native Pathlib Usage over os.path

### Context
Windows and Unix differ in path separators, drive letters, and forbidden characters. String concatenation of paths is fragile.

### Decision
Standardize on Python's `pathlib.Path` across the codebase.

### Rationale
1. Object-oriented path manipulation provides safe resolution and filesystem operations.
2. The `/` operator handles path separators across operating systems.
3. Extension, stem, parent, and directory-creation methods are available directly on path objects.

---

## ADR-005: yt-dlp Python API with Non-Downloading Metadata Inspection

### Context
Parsing CLI output is fragile, and downloading an entire file just to inspect it is wasteful.

### Decision
Use `yt_dlp.YoutubeDL` and `extract_info(url, download=False)` for future metadata retrieval before user confirmation.

### Rationale
1. Metadata can be inspected in memory before committing to a potentially large download.
2. Structured dictionary responses are more reliable than scraping command-line text.

---

## ADR-006: Centralized QML Theme and Reusable UI Components

### Context
Repeated literal colors, font sizes, spacing, and control markup make visual changes inconsistent and responsive/accessibility improvements expensive to maintain.

### Decision
Use the `Theme.qml` singleton, registered through `qml/theme/qmldir`, as the source of palette, semantic typography, spacing, radii, and animation tokens. Put repeated shell and page patterns in reusable QML components under `qml/components/`; pages compose them but own no media-processing behavior.

### Rationale
1. A single token source keeps contrast, typography, and spacing decisions consistent across all views.
2. QML components expose focused properties and signals while preserving declarative layout and keyboard/accessibility behavior.
3. Width-aware `Layout` values and grid breakpoints keep content usable without fixed absolute positioning.
4. Qt Quick Controls Basic is selected at application startup because it supports the custom backgrounds and content items required by the MediaFlow visual system.

### Consequences
- QML owns presentation state and emits UI signals; no downloader, converter, persistence, or settings service is invoked by these components.
- Theme changes belong in `Theme.qml`, not as local color literals in pages.
- The application bootstrap selects the Basic Controls style before `QGuiApplication` is created.
