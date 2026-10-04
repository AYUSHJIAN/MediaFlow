"""Tests for Phase 2: Application Shell and Multi-View Navigation."""

import os
import sys
from pathlib import Path
import pytest


def test_qml_pages_exist():
    """Verify all 4 core view page files exist in qml/pages/."""
    base_dir = Path(__file__).resolve().parent.parent
    pages_dir = base_dir / "qml" / "pages"

    expected_pages = [
        "DownloaderPage.qml",
        "ConverterPage.qml",
        "HistoryPage.qml",
        "SettingsPage.qml",
    ]

    for page_name in expected_pages:
        page_path = pages_dir / page_name
        assert page_path.exists(), f"Expected page missing: {page_name}"
        assert page_path.stat().st_size > 100, f"Page file is unexpectedly empty: {page_name}"


def test_individual_pages_compile():
    """Verify that each page in qml/pages/ compiles and instantiates in QQmlApplicationEngine."""
    from PySide6.QtCore import QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent

    os.environ["QT_QPA_PLATFORM"] = "offscreen"

    app = QGuiApplication.instance()
    if app is None:
        app = QGuiApplication(sys.argv[:1])

    engine = QQmlApplicationEngine()
    base_dir = Path(__file__).resolve().parent.parent
    pages_dir = base_dir / "qml" / "pages"

    for page_name in ["DownloaderPage.qml", "ConverterPage.qml", "HistoryPage.qml", "SettingsPage.qml"]:
        page_url = QUrl.fromLocalFile(str(pages_dir / page_name))
        component = QQmlComponent(engine, page_url)
        assert component.isReady(), f"Component failed to compile: {page_name}, errors: {component.errors()}"
        obj = component.create()
        assert obj is not None, f"Failed to instantiate object for {page_name}"


def test_main_shell_loads_with_pages():
    """Verify Main.qml loads with StackLayout and navigation items."""
    from PySide6.QtCore import QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine

    os.environ["QT_QPA_PLATFORM"] = "offscreen"

    app = QGuiApplication.instance()
    if app is None:
        app = QGuiApplication(sys.argv[:1])

    engine = QQmlApplicationEngine()
    base_dir = Path(__file__).resolve().parent.parent
    qml_file = base_dir / "qml" / "Main.qml"

    engine.load(QUrl.fromLocalFile(str(qml_file)))
    root_objects = engine.rootObjects()
    assert len(root_objects) > 0, "Failed to load Main.qml root window"

    root_window = root_objects[0]
    nav_val = root_window.property("navItems")
    nav_items = nav_val.toVariant() if hasattr(nav_val, "toVariant") else nav_val
    assert len(nav_items) == 4, f"Expected 4 navigation items, got {len(nav_items)}"

    nav_names = [item["name"] for item in nav_items]
    assert nav_names == ["Downloader", "Converter", "History", "Settings"]


def test_navigation_index_switching():
    """Verify that currentNavIndex can be set to each view index safely."""
    from PySide6.QtCore import QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine

    os.environ["QT_QPA_PLATFORM"] = "offscreen"

    app = QGuiApplication.instance()
    if app is None:
        app = QGuiApplication(sys.argv[:1])

    engine = QQmlApplicationEngine()
    base_dir = Path(__file__).resolve().parent.parent
    qml_file = base_dir / "qml" / "Main.qml"

    engine.load(QUrl.fromLocalFile(str(qml_file)))
    root_window = engine.rootObjects()[0]

    for index in range(4):
        root_window.setProperty("currentNavIndex", index)
        assert root_window.property("currentNavIndex") == index
