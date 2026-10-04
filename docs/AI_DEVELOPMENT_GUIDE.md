# MediaForge — AI Agent Development Guide

This guide defines the engineering protocols, rules of engagement, and coding standards for AI coding agents operating on the MediaForge codebase.

---

## 1. Operating Principles & Handoff Protocol

When taking over work on this repository:
1. **Source of Truth**: Always inspect `docs/PROJECT_CONTEXT.md`, `docs/ARCHITECTURE.md`, `docs/DEVELOPMENT_LOG.md`, and `docs/TODO.md` before writing or modifying code.
2. **Current State Discovery**:
   - Run `git status` and `git branch` to ascertain the active working branch.
   - Run `pytest` to verify the state of test suites before introducing modifications.
3. **Strict Phase Boundaries**:
   - **Do not implement forward phases preemptively**. If the active instruction is Phase 1, do not write Phase 4 or Phase 11 logic.
   - Deliver focused, high-quality, fully-tested milestones.
4. **No Destructive Operations**:
   - Prohibited commands: `git reset --hard`, `git push --force`, `git clean -fd`.
   - Never overwrite user configurations without explicit approval.

---

## 2. Architecture & Code Boundaries

1. **Separation of Presentation & Backend**:
   - UI elements live strictly in `qml/`.
   - Python business logic lives strictly in `src/backend/`.
   - Bridge controllers live in `src/bridge/`.
   - **Never import Qt or QML modules into `src/backend/`**. The backend must remain 100% headless and testable without a GUI display.
2. **Path Management**:
   - Use `pathlib.Path` exclusively.
   - Never hardcode user-specific absolute paths (e.g. `C:/Users/...`). Use relative paths or configuration-driven paths.
3. **Concurrency & Threading**:
   - Never run long-running, blocking operations on the Qt main GUI thread.
   - Use `QRunnable` / `QThreadPool` for background execution.
   - Use thread-safe Qt Signals to communicate between background workers and the QML bridge.
4. **Subprocess Execution**:
   - External processes (FFmpeg, ffprobe) must be invoked with argument lists (`argv: list[str]`).
   - Never use `shell=True`.

---

## 3. Git Workflow & Discipline

1. **Feature Branches**:
   - Never commit directly to `main` for feature development.
   - Use feature branches named after the active phase:
     - `feature/project-foundation`
     - `feature/qml-ui`
     - `feature/downloader`
     - `feature/converter`
     - etc.
2. **Pre-flight & Post-flight Checks**:
   - Before modifying: `git status`.
   - Before committing: `git diff`, `git status`.
   - Run automated tests (`pytest`) and ensure all pass.
3. **Commit Messages**:
   - Use clear, descriptive imperative messages:
     - `Initialize MediaForge foundation`
     - `Implement centralized QML theme system`
     - `Add yt-dlp metadata extraction service`

---

## 4. Documentation Maintenance

Whenever completing a phase or milestone:
1. Update `docs/DEVELOPMENT_LOG.md` with date, actions taken, and verified outputs.
2. Update `docs/TODO.md` by marking completed tasks.
3. Update `docs/DECISIONS.md` if any architectural decision or library was introduced.
4. Update `docs/INTERVIEW_NOTES.md` with relevant technical concepts and interview questions.
