# MediaForge — Technical Interview Notes & Engineering Deep Dive

This document captures software engineering fundamentals, architectural trade-offs, and targeted technical interview questions corresponding to MediaForge development.

---

## 1. Core Engineering Concepts (Phase 1)

### Q1: What is the Qt Event Loop, and why does long-running work freeze desktop GUIs?
**Concept**:
In any modern GUI application (Qt, macOS Cocoa, Windows Win32), the user interface is driven by a single-threaded **Event Loop** (invoked via `app.exec()`). The event loop continuously polls the operating system message queue for user input (mouse moves, clicks, keyboard events) and window paint/render requests.

**The Problem**:
If an event handler initiates a synchronous operation—such as downloading a 500MB video or transcoding an audio file with FFmpeg—the main thread stops polling the event loop until that operation completes. Because no window redraw or input events can be processed, the operating system marks the window as "Not Responding" (the spinning beachball on macOS or frozen window on Windows).

**The Solution**:
All blocking I/O, network requests, and intensive CPU workloads must be dispatched to background worker threads (e.g. `QThreadPool`, `QRunnable`, or Python's `concurrent.futures`). Workers must communicate progress and completion back to the main thread via thread-safe signals.

---

### Q2: Why choose Qt Quick / QML over traditional QWidgets or Tkinter?
**Analysis & Comparison**:
1. **Tkinter**:
   - Built on Tcl/Tk from the early 1990s.
   - CPU-rendered, lacks native support for hardware-accelerated fluid transitions, declarative animations, vector graphics, and high-DPI custom styling.
   - Code mixes UI declaration and event logic, making clean architectural separation difficult.
2. **QWidgets**:
   - Mature, imperative C++/Python widget library.
   - Best for traditional enterprise desktop software (standard forms, spreadsheet tables, OS-native dialogs).
   - Difficult to style with fluid dark-mode transitions, responsive card layouts, and custom micro-animations without cumbersome QSS (Qt Style Sheets) hacking.
3. **Qt Quick & QML**:
   - Modern declarative framework designed for fluid, touch/mouse dynamic user interfaces.
   - Renders directly on GPU hardware via the Qt Scene Graph (Direct3D 11/12 on Windows, Metal on macOS, Vulkan/OpenGL on Linux).
   - Completely separates visual presentation (`.qml` files) from business logic (`.py` files), enabling scalable UI development.

---

### Q3: How does Python load and communicate with QML?
**The Mechanism**:
1. **Engine Instantiation**:
   `QQmlApplicationEngine` is created in Python.
2. **QML Loading**:
   The engine loads a root QML file (`engine.load(url)`).
3. **Safety Verification**:
   Connecting to `engine.objectCreated` verifies whether the QML file compiled and instantiated its root window successfully. If `rootObjects()` is empty, the application terminates gracefully with an error code instead of hanging silently.
4. **Bridge Integration (Phase 2+)**:
   Python objects inheriting from `QObject` are exposed to QML via `engine.rootContext().setContextProperty("bridge", bridge_instance)` or via QML type registration (`qmlRegisterType`).
5. **Bidirectional Communication**:
   - **QML → Python**: QML invokes `@Slot` decorated methods on the bridge object.
   - **Python → QML**: Python emits Qt `@Signal` decorators, which QML listens to via signal handlers (e.g. `onProgressChanged: ...`).

---

### Q4: What is the difference between a Container and a Codec?
**The Difference**:
- **Container**: A file format (like a box) that packages multiple streams together along with synchronization metadata. Examples: `.mp4`, `.mov`, `.mkv`, `.webm`.
- **Codec**: The compression/decompression algorithm used to encode raw pixel or audio data into compact binary streams. Examples: Video (H.264, HEVC/H.265, AV1, VP9), Audio (AAC, MP3, Opus, FLAC).

**Analogy**:
A shipping container (MP4) can transport different goods (H.264 video and AAC audio). Another container (MKV) can carry the exact same goods without altering what is inside.

---

### Q5: What is the difference between Remuxing and Transcoding?
- **Remuxing (Multiplexing / Demultiplexing)**:
  - Takes existing compressed streams out of one container format and packages them into another container format (e.g. MKV containing H.264/AAC into an MP4 container).
  - Executed in FFmpeg with `-c copy`.
  - Takes seconds; zero generational quality loss; consumes negligible CPU.
- **Transcoding**:
  - Decodes the compressed stream to raw uncompressed data and re-encodes it using a different codec or bitrate parameters (e.g., MP4 H.264/AAC to MP3 audio).
  - High CPU/GPU utilization; takes proportional time to media duration; lossy if using lossy target codecs.

---

### Q6: Why is `pathlib.Path` preferred over `os.path`?
1. **Object-Oriented**: `pathlib.Path` encapsulates path representation and filesystem operations on the object itself (`path.exists()`, `path.mkdir()`, `path.unlink()`), whereas `os.path` requires passing strings into disparate functional modules (`os.path.exists(p)`, `os.makedirs(p)`, `os.remove(p)`).
2. **Safe Concatenation**: The `/` operator handles path separators safely regardless of operating system (`base_dir / "downloads" / "video.mp4"`), avoiding slash bugs between POSIX (`/`) and Windows (`\`).
3. **Immutability & Safety**: Paths are immutable objects, preventing accidental in-place mutation.

---

### Q7: Why should external tools (like FFmpeg) never be executed using shell strings (`shell=True`)?
1. **Command Injection**: If a user supplies a filename containing shell metacharacters (e.g., `; rm -rf /` or `& del /f /q *`), a shell interpreter will execute the injected command.
2. **Escaping Nightmares**: Filenames with spaces, quotes, parentheses, or unicode require fragile platform-specific escaping when passed as a single string.
3. **Safe API**: Passing an argument list (`["ffmpeg", "-i", input_file, "-vn", output_file]`) with `shell=False` uses the operating system's native process spawning APIs (`CreateProcessW` on Windows or `execve` on POSIX), passing arguments directly without invoking a command shell.
