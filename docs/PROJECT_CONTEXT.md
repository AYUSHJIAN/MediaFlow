# MediaFlow — Project Context

## Project Overview
**MediaFlow** is a desktop media utility designed for content creators, video editors, and audio engineers. It streamlines downloading, metadata extraction, format conversion, and media asset management into a unified workspace.

## Vision & Goals
- **Product Experience**: Move away from primitive utility scripts or outdated desktop interfaces. Deliver an intuitive, responsive dark cinematic workstation reminiscent of Linear, DaVinci Resolve, and Adobe Premiere Pro.
- **Engineering Excellence**: Build with clean architecture, strict separation of concerns, robust concurrency patterns, type safety, comprehensive logging, and thorough unit testing.
- **Educational Foundation**: Serve as an exemplary portfolio project demonstrating mastery over Python 3, PySide6, Qt Quick / QML, multithreading, external process orchestration (FFmpeg), and Git workflow.

## Target User Personas
- **Digital Content Creators**: Need quick, high-fidelity YouTube, Instagram, or Pinterest downloads for reference, editing, or archival without ads or sketchy web downloaders.
- **Video & Audio Editors**: Require rapid format conversion (e.g., MP4 to MP3, MOV to MP4) with audio extraction and format remuxing directly on their workstation.
- **Archivists & Researchers**: Need persistent history, metadata retention, and predictable file organization.

## Technical Foundation
| Layer | Technology | Rationale |
|---|---|---|
| Language | Python 3 (>=3.10) | Strong ecosystem for media processing and desktop bindings |
| GUI Toolkit | PySide6 (Qt 6) | Official Qt for Python bindings; enterprise-grade rendering engine |
| UI Declarative Engine | Qt Quick + QML | Modern hardware-accelerated declarative UI; clean separation of presentation and logic |
| Media Ingestion | yt-dlp Python API | Robust, actively maintained media extraction with in-memory metadata inspection |
| Media Transcoding | FFmpeg (CLI / subprocess) | Industry standard media tool for fast remuxing, decoding, and encoding |
| Concurrency | QThreadPool / QRunnable / Signals | Prevents GUI thread blocking during intensive I/O and transcoding operations |
| Configuration | JSON | Transparent, human-editable, schema-validatable settings |
| Persistence | SQLite | ACID-compliant, lightweight embedded database for media history |
| Quality Assurance | pytest | Deterministic, fast unit and integration testing suite |

## Visual Design Specification
- **Aesthetic**: Dark cinematic workstation.
- **Palette**:
  - Background: `#08090C`
  - Surface: `#111318`
  - Secondary Surface: `#181B22`
  - Primary Accent: `#7C5CFF` (Electric Purple)
  - Secondary Accent: `#00D4FF` (Cyan)
  - Text Primary: `#F5F7FA`
  - Text Muted: `#8B93A1`
  - Border Subtle: `#292E36`
  - Status Success: `#35D39A`
  - Status Warning: `#FFB547`
  - Status Error: `#FF5C68`

## Current Status
- **Current Phase**: Phase 2 — PySide6 + QML Application Shell (Complete)
- **Milestone Achieved**: Application shell operational with interactive sidebar navigation rail, dynamic StackLayout view router, 4 dedicated workstation pages (Downloader, Converter, History, Settings), and comprehensive test suite.
- **Next Milestone**: Phase 3 — Theme and Reusable UI Components.
