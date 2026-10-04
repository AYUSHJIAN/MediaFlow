# MediaForge — Architectural Decision Records (ADR)

## ADR-001: Selection of PySide6 + Qt Quick / QML over Tkinter / CustomTkinter

### Context
Desktop media utilities often rely on basic GUI frameworks like Tkinter or CustomTkinter. However, MediaForge aims to be a professional creator tool with modern hardware-accelerated fluid graphics, smooth animations, customizable dark themes, and high-DPI scaling.

### Decision
Use **PySide6 (Qt 6) with Qt Quick and QML**.

### Rationale
1. **Hardware Acceleration**: Qt Quick uses the Qt Scene Graph (Direct3D on Windows, Metal on macOS, OpenGL/Vulkan on Linux), rendering fluid animations at 60+ FPS without CPU-bound widget redraws.
2. **Separation of Presentation and Logic**: QML provides a declarative, JSON-like syntax for visual components, keeping UI markup completely detached from Python business logic.
3. **Professional Look and Feel**: Tkinter relies on antiquated OS native widgets that look out of place in creative software suites. CustomTkinter improves appearance but suffers from limited layout flexibility, absence of hardware acceleration, and sluggish redraws during high-frequency updates (e.g. download progress).
4. **Rich Type Marshaling**: PySide6 features first-class Python ↔ C++ / QML bridge capabilities (`@Property`, `@Signal`, `@Slot`), facilitating clean async communication.

---

## ADR-002: Layered Service & Bridge Architecture

### Context
A common anti-pattern in desktop applications is coupling GUI event handlers directly with network calls, disk operations, or subprocess execution. This makes code untestable, difficult to maintain, and prone to freezing the UI.

### Decision
Enforce a four-tier architecture:
`QML Presentation` → `PySide6 Bridge (QObject)` → `Python Service Layer` → `System/External Engines`.

### Rationale
1. **Testability**: The backend service layer has zero dependencies on Qt or GUI classes. Services can be verified with standard headless `pytest` tests without instantiating `QGuiApplication`.
2. **Flexibility**: If the UI technology is ever swapped or adapted, the core media processing services remain completely untouched.
3. **Clarity**: Each component has one distinct responsibility.

---

## ADR-003: Subprocess Argument Lists for FFmpeg vs Shell Strings

### Context
Executing external tools like FFmpeg can be done via `shell=True` or by passing a list of distinct arguments (`argv`). Shell string concatenation often leads to severe security risks (shell injection) and escaping bugs on filenames containing spaces, quotes, or special unicode characters.

### Decision
Always use discrete argument lists (`list[str]`) with `subprocess.Popen` or `subprocess.run`, and keep `shell=False`.

### Rationale
1. **Security**: Eliminates command injection vectors completely.
2. **Robustness**: Arguments are passed directly to the operating system's `CreateProcessW` API on Windows, ensuring that filenames with spaces, ampersands, or apostrophes are safely handled without fragile manual string quoting.

---

## ADR-004: Native Pathlib Usage over os.path

### Context
Windows and Unix systems differ in path separators (`\` vs `/`), drive letters, and forbidden characters. String concatenation of paths is fragile.

### Decision
Standardize exclusively on Python's `pathlib.Path` across the entire codebase.

### Rationale
1. Object-oriented path manipulation provides cleaner, safer path resolutions (`path / "subfolder"`).
2. Built-in methods for extension inspection (`.suffix`), stem extraction (`.stem`), parent resolution (`.parent`), and directory creation (`.mkdir(parents=True, exist_ok=True)`).
3. Automatic conversion to proper OS path formats.

---

## ADR-005: yt-dlp Python API with Non-Downloading Metadata Inspection

### Context
Media download utilities frequently either parse CLI stdout/stderr using regex or download the entire media file before checking properties.

### Decision
Use `yt_dlp.YoutubeDL` directly via its Python API, leveraging `extract_info(url, download=False)` for metadata retrieval before user confirmation.

### Rationale
1. **Performance**: Inspecting stream formats, thumbnails, and durations in-memory takes hundreds of milliseconds, enabling instant UI previews before committing to multi-gigabyte downloads.
2. **Reliability**: Structured dictionary responses from the API are vastly more reliable than scraping command-line text output, which frequently changes across minor versions.
