"""Foundational tests for Phase 1 project structure and initial runtime."""

import os
import sys
from pathlib import Path
import pytest


def test_directory_structure():
    """Verify all required Phase 1 directories and packages exist."""
    base_dir = Path(__file__).resolve().parent.parent

    expected_directories = [
        base_dir / "src",
        base_dir / "src" / "backend",
        base_dir / "src" / "backend" / "downloader",
        base_dir / "src" / "backend" / "converter",
        base_dir / "src" / "backend" / "filesystem",
        base_dir / "src" / "backend" / "history",
        base_dir / "src" / "backend" / "config",
        base_dir / "src" / "backend" / "logging",
        base_dir / "src" / "bridge",
        base_dir / "qml",
        base_dir / "qml" / "components",
        base_dir / "qml" / "pages",
        base_dir / "qml" / "theme",
        base_dir / "assets",
        base_dir / "assets" / "icons",
        base_dir / "assets" / "images",
        base_dir / "assets" / "fonts",
        base_dir / "docs",
        base_dir / "tests",
        base_dir / "downloads",
        base_dir / "temp",
    ]

    for directory in expected_directories:
        assert directory.exists(), f"Expected directory does not exist: {directory}"
        assert directory.is_dir(), f"Expected path is not a directory: {directory}"


def test_init_files_exist():
    """Verify all Python package directories contain __init__.py."""
    base_dir = Path(__file__).resolve().parent.parent

    package_directories = [
        base_dir / "src",
        base_dir / "src" / "backend",
        base_dir / "src" / "backend" / "downloader",
        base_dir / "src" / "backend" / "converter",
        base_dir / "src" / "backend" / "filesystem",
        base_dir / "src" / "backend" / "history",
        base_dir / "src" / "backend" / "config",
        base_dir / "src" / "backend" / "logging",
        base_dir / "src" / "bridge",
        base_dir / "tests",
    ]

    for pkg_dir in package_directories:
        init_file = pkg_dir / "__init__.py"
        assert init_file.exists(), f"Missing __init__.py in: {pkg_dir}"


def test_documentation_files_exist():
    """Verify all required documentation files are present."""
    base_dir = Path(__file__).resolve().parent.parent
    docs_dir = base_dir / "docs"

    expected_docs = [
        "PROJECT_CONTEXT.md",
        "ARCHITECTURE.md",
        "DEVELOPMENT_LOG.md",
        "TODO.md",
        "DECISIONS.md",
        "INTERVIEW_NOTES.md",
        "AI_DEVELOPMENT_GUIDE.md",
    ]

    for doc_name in expected_docs:
        doc_path = docs_dir / doc_name
        assert doc_path.exists(), f"Expected documentation file missing: {doc_name}"
        assert doc_path.stat().st_size > 50, f"Documentation file is empty or trivial: {doc_name}"


def test_logging_setup(tmp_path):
    """Verify logger setup produces valid output handlers and captures messages."""
    from src.backend.logging import setup_logging

    log_file = tmp_path / "test.log"
    logger = setup_logging(log_file=log_file)

    test_message = "Test message for Phase 1 foundation verification"
    logger.info(test_message)

    assert log_file.exists()
    content = log_file.read_text(encoding="utf-8")
    assert test_message in content


def test_qml_syntax_and_engine_loading():
    """Verify that Main.qml parses and loads cleanly in QQmlApplicationEngine."""
    from PySide6.QtCore import QUrl, QCoreApplication
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine

    base_dir = Path(__file__).resolve().parent.parent
    qml_file = base_dir / "qml" / "Main.qml"
    assert qml_file.exists(), "Main.qml file must exist"

    # Set offscreen platform to allow headless CI/testing
    os.environ["QT_QPA_PLATFORM"] = "offscreen"

    app = QGuiApplication.instance()
    if app is None:
        app = QGuiApplication(sys.argv[:1])

    engine = QQmlApplicationEngine()
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    root_objects = engine.rootObjects()
    assert len(root_objects) > 0, "QQmlApplicationEngine failed to instantiate root QML object"
