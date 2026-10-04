# MediaForge

A professional desktop media utility designed for creators to download, extract, convert, and manage digital media assets.

Built with **Python 3**, **PySide6 (Qt 6)**, **Qt Quick / QML**, **yt-dlp**, and **FFmpeg**.

---

## Key Highlights

- **Modern Creator Workstation UI**: Hardware-accelerated dark cinematic aesthetic inspired by DaVinci Resolve, Adobe Premiere, and Linear.
- **Strict Separation of Concerns**: Declarative QML presentation layer completely decoupled from the Python business service layer via a type-safe `QObject` bridge.
- **Safe External Process Orchestration**: Subprocess invocations (FFmpeg) parameterized with discrete argument lists (`argv`) to eliminate shell injection vulnerabilities.
- **Robust Path & Filesystem Management**: Object-oriented `pathlib` architecture preventing directory traversal and accidental file overwrites.
- **Multithreaded Architecture**: Dedicated worker threads preventing GUI lockups or frame drops during media downloads and transcoding.

---

## Project Structure

```text
MediaForge/
├── app.py                     # Application entry point & Qt engine bootstrap
├── pyproject.toml             # Project metadata, build settings & pytest configuration
├── requirements.txt           # Core Python dependencies
├── README.md                  # Project documentation & quickstart
├── .gitignore                 # Git ignore rules
│
├── src/                       # Application Python source code
│   ├── backend/               # Pure Python business logic (headless & testable)
│   │   ├── downloader/        # yt-dlp media & metadata extraction engine
│   │   ├── converter/         # FFmpeg transcoding and remuxing services
│   │   ├── filesystem/        # Path sanitization, deduplication & safety
│   │   ├── history/           # SQLite persistence for media operations
│   │   ├── config/            # JSON configuration management
│   │   └── logging/           # Unified structured logging
│   └── bridge/                # PySide6 QObject controllers connecting QML to backend
│
├── qml/                       # Declarative Qt Quick / QML user interface
│   ├── Main.qml               # Main window and workstation layout
│   ├── components/            # Reusable UI controls (buttons, inputs, progress bars)
│   ├── pages/                 # Modular views (Downloader, Converter, History, Settings)
│   └── theme/                 # Centralized dark-mode styling tokens
│
├── assets/                    # Static runtime assets
│   ├── icons/                 # SVG and vector iconography
│   ├── images/                # Workstation graphics and logos
│   └── fonts/                 # Embedded creator typography
│
├── docs/                      # Comprehensive project documentation
│   ├── PROJECT_CONTEXT.md     # Vision, user personas & technical stack
│   ├── ARCHITECTURE.md        # Deep dive into system layers & threading model
│   ├── DEVELOPMENT_LOG.md     # Chronological log of engineering milestones
│   ├── TODO.md                # 20-phase roadmap & task tracker
│   ├── DECISIONS.md           # Architectural Decision Records (ADRs)
│   ├── INTERVIEW_NOTES.md     # Technical interview preparation & concept breakdowns
│   └── AI_DEVELOPMENT_GUIDE.md# Standards and handoff guide for AI coding assistants
│
├── tests/                     # Automated unit and integration test suite
├── downloads/                 # Default directory for ingested media files
└── temp/                      # Working scratchpad for active transcoding tasks
```

---

## Getting Started

### Prerequisites

- **Python 3.10+** (Tested on Python 3.14)
- **Git**
- **FFmpeg** (Recommended on system PATH for future conversion phases)

### Installation

1. Clone the repository and navigate into the project directory:
   ```bash
   git clone https://github.com/AYUSHJIAN/MediaFlow.git
   cd MediaFlow
   ```

2. Create and activate a Python virtual environment:
   ```bash
   # Windows (PowerShell)
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1

   # macOS / Linux
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

---

## Running the Application

Launch the desktop workstation:

```bash
# Windows
.\.venv\Scripts\python.exe app.py

# macOS / Linux
python app.py
```

---

## Running Tests

Execute the automated test suite with pytest:

```bash
# Windows
.\.venv\Scripts\pytest.exe -v

# macOS / Linux
pytest -v
```

---

## Development Roadmap

See [docs/TODO.md](docs/TODO.md) for the complete 20-phase master roadmap.

- [x] **Phase 1: Project Foundation** (Complete)
- [ ] **Phase 2: PySide6 + QML Application Shell**
- [ ] **Phase 3: Theme and Reusable Components**
- [ ] **Phase 4: Downloader Metadata Service**
- [ ] **Phase 5: Downloader Service**
...
- [ ] **Phase 20: Portfolio Polish**

---

## License

MIT License. Designed and engineered for portfolio and educational excellence.
