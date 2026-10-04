"""Tests for Phase 2: Application Shell and Multi-View Navigation."""

import os
import sys
from pathlib import Path
import pytest

os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")


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
        assert page_path.stat().st_size > 100, (
            f"Page file is unexpectedly empty: {page_name}"
        )


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

    for page_name in [
        "DownloaderPage.qml",
        "ConverterPage.qml",
        "HistoryPage.qml",
        "SettingsPage.qml",
    ]:
        page_url = QUrl.fromLocalFile(str(pages_dir / page_name))
        component = QQmlComponent(engine, page_url)
        assert component.isReady(), (
            f"Component failed to compile: {page_name}, errors: {component.errors()}"
        )
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


def test_shared_components_compile():
    """Verify reusable component files compile and instantiate independently."""
    from PySide6.QtCore import QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlComponent, QQmlEngine

    os.environ["QT_QPA_PLATFORM"] = "offscreen"
    app = QGuiApplication.instance()
    if app is None:
        app = QGuiApplication(sys.argv[:1])

    engine = QQmlEngine()
    base_dir = Path(__file__).resolve().parent.parent
    components_dir = base_dir / "qml" / "components"

    for component_path in components_dir.glob("*.qml"):
        component = QQmlComponent(engine, QUrl.fromLocalFile(str(component_path)))
        assert component.isReady(), (
            f"Component failed to compile: {component_path.name}, errors: {component.errors()}"
        )
        instance = component.create()
        assert instance is not None, (
            f"Component failed to instantiate: {component_path.name}, errors: {component.errors()}"
        )


def test_responsive_navigation_and_downloader_ui_action():
    """Verify responsive shell navigation and that Fetch Media remains a UI-only signal."""
    from PySide6.QtCore import QObject, Qt, QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine
    from PySide6.QtQuick import QQuickItem
    from PySide6.QtTest import QSignalSpy, QTest

    os.environ["QT_QPA_PLATFORM"] = "offscreen"
    app = QGuiApplication.instance()
    if app is None:
        app = QGuiApplication(sys.argv[:1])

    engine = QQmlApplicationEngine()
    base_dir = Path(__file__).resolve().parent.parent
    engine.load(QUrl.fromLocalFile(str(base_dir / "qml" / "Main.qml")))
    root_window = engine.rootObjects()[0]

    root_window.resize(760, 560)
    app.processEvents()
    assert root_window.property("compactLayout") is True

    root_window.resize(1160, 760)
    app.processEvents()
    assert root_window.property("compactLayout") is False

    sidebar = root_window.findChild(QQuickItem, "appSidebar")
    assert sidebar is not None

    def find_visual_item(parent, object_name):
        if parent.objectName() == object_name:
            return parent
        for child in parent.childItems():
            result = find_visual_item(child, object_name)
            if result is not None:
                return result
        return None

    converter_button = find_visual_item(sidebar, "navButton_1")
    assert converter_button is not None
    converter_point = converter_button.mapToScene(
        converter_button.boundingRect().center()
    ).toPoint()
    QTest.mousePress(
        root_window,
        Qt.MouseButton.LeftButton,
        Qt.KeyboardModifier.NoModifier,
        converter_point,
    )
    app.processEvents()
    assert converter_button.property("down") is True
    QTest.mouseRelease(
        root_window,
        Qt.MouseButton.LeftButton,
        Qt.KeyboardModifier.NoModifier,
        converter_point,
    )
    app.processEvents()
    assert root_window.property("currentNavIndex") == 1

    root_window.setProperty("currentNavIndex", 0)
    app.processEvents()
    downloader_page = root_window.findChild(QObject, "downloaderPage")
    fetch_button = root_window.findChild(QQuickItem, "fetchMediaButton")
    assert downloader_page is not None and fetch_button is not None
    fetch_spy = QSignalSpy(downloader_page.fetchMediaRequested)
    fetch_point = fetch_button.mapToScene(
        fetch_button.boundingRect().center()
    ).toPoint()
    QTest.mouseClick(
        root_window,
        Qt.MouseButton.LeftButton,
        Qt.KeyboardModifier.NoModifier,
        fetch_point,
    )
    app.processEvents()
    assert fetch_spy.count() == 1
    assert fetch_spy.at(0)[0] == ""
