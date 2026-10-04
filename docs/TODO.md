# MediaFlow — Development Roadmap & TODO

## Phase Breakdown

- [x] **PHASE 1: Project Foundation**
  - [x] Create directory structure (`src/`, `qml/`, `assets/`, `docs/`, `tests/`, `downloads/`, `temp/`)
  - [x] Set up package metadata (`pyproject.toml`, `requirements.txt`, `.gitignore`)
  - [x] Configure unified logging (`src/backend/logging/`)
  - [x] Build minimal PySide6 + QML application launcher (`app.py`, `qml/Main.qml`)
  - [x] Create foundational automated tests (`tests/test_foundation.py`)
  - [x] Establish documentation suite in `docs/`

- [x] **PHASE 2: PySide6 + QML Application Shell**
  - [x] Application window header & breadcrumb status
  - [x] Navigation sidebar (Downloader, Converter, History, Settings)
  - [x] View switching architecture (StackLayout)
  - [x] Modular page views in qml/pages/ (Downloader, Converter, History, Settings)
  - [x] Automated QML compilation & navigation tests (tests/test_app_shell.py)

- [x] **PHASE 3: Theme and Reusable Components**
  - [x] Centralized QML Theme singleton (`Theme.qml`) with palette, typography, spacing, radius, and animation tokens
  - [x] Reusable shell/page components (AppSidebar, TopBar, buttons, Card, TextInputField, SectionHeader, StatusBadge, EmptyState, FileDropZone, PageContainer)
  - [x] Focus, enabled, pressed, hover, and loading states where applicable; accessible names and keyboard navigation
  - [x] Responsive shell and page layouts with compact navigation and width-aware grids
  - [x] QML compile, component instantiation, resize, navigation, and placeholder-action tests

- [x] **PHASE 4: URL Validation and Metadata Extraction**
  - [x] HTTP(S) URL validation with structured user-facing errors
  - [x] YouTube, Instagram, Pinterest, and Unknown platform labels
  - [x] yt-dlp embedded API metadata extraction with downloading disabled
  - [x] Normalized MediaMetadata/MediaFormat DTOs and video/audio/combined format labels
  - [x] Asynchronous QObject bridge and Downloader loading/success/error states
  - [x] Mocked URL, normalization, error mapping, worker, and QML integration tests

- [ ] **PHASE 5: Downloader Service**
  - [ ] Audio/video download options configuration
  - [ ] yt-dlp execution pipeline
  - [ ] Post-processing hook wiring

- [ ] **PHASE 6: QML/Backend Integration**
  - [ ] QObject Bridge controller implementation
  - [ ] Expose metadata models to QML
  - [ ] Two-way data binding and slot invocations

- [ ] **PHASE 7: Progress Handling**
  - [ ] yt-dlp progress hook parser (percentage, speed, ETA, downloaded bytes)
  - [ ] Signal emission on progress updates
  - [ ] Smooth animated progress bar in QML

- [ ] **PHASE 8: Threading & Cancellation**
  - [ ] Worker thread architecture (`QRunnable` + `QThreadPool`)
  - [ ] Safe cooperative cancellation tokens
  - [ ] Thread-safe signal marshaling to GUI thread

- [ ] **PHASE 9: Filename and Filesystem Management**
  - [ ] Filename sanitization (illegal characters, Windows path rules)
  - [ ] Duplicate resolution (numbered increments)
  - [ ] Path traversal prevention
  - [ ] Default output folder resolution

- [ ] **PHASE 10: FFmpeg Detection**
  - [ ] System PATH discovery and custom binary path resolution
  - [ ] Version and codec support validation
  - [ ] User-facing alert/diagnostic if FFmpeg is missing

- [ ] **PHASE 11: MP4 → MP3 Converter**
  - [ ] Audio extraction pipeline using FFmpeg
  - [ ] Bitrate selection (128k, 192k, 320k)
  - [ ] FFmpeg stdout/stderr progress parsing

- [ ] **PHASE 12: MP4 ↔ MOV Converter**
  - [ ] Remuxing vs Transcoding detection
  - [ ] Stream copy optimization (`-c copy`) when codecs match
  - [ ] Full transcode when re-encoding is required

- [ ] **PHASE 13: Instagram & Pinterest Support**
  - [ ] Platform-specific URL patterns and edge-case handling
  - [ ] yt-dlp cookie/header configuration where needed

- [ ] **PHASE 14: History Service**
  - [ ] SQLite database schema creation
  - [ ] Asynchronous insert/read of download and conversion records
  - [ ] History list view and search filter in QML

- [ ] **PHASE 15: Settings Service**
  - [ ] User preferences persistence (JSON)
  - [ ] Default directories, quality preferences, theme overrides
  - [ ] Bridge integration for settings page

- [ ] **PHASE 16: Comprehensive Testing**
  - [ ] Pytest coverage across backend services (URL, filesystem, converter, config)
  - [ ] Mocked yt-dlp and FFmpeg tests (no network/binary dependency)

- [ ] **PHASE 17: Error Handling Refinement**
  - [ ] User-friendly error messaging
  - [ ] Detailed debug logs
  - [ ] Network timeout, disk space, and format error recoveries

- [ ] **PHASE 18: Packaging**
  - [ ] PyInstaller spec configuration
  - [ ] Asset and QML bundling
  - [ ] Standalone Windows executable testing

- [ ] **PHASE 19: Documentation**
  - [ ] User guide, architecture diagrams, API docs, build guides

- [ ] **PHASE 20: Portfolio Polish**
  - [ ] Demo video/GIF recording
  - [ ] Polished README badges, architecture writeup, interview presentation deck
