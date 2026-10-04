"""Tests for the asynchronous Python/QML metadata bridge."""

import os
import threading
import time

from PySide6.QtCore import QThreadPool, Qt, QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickItem
from PySide6.QtTest import QTest
import pytest

from src.backend.downloader.metadata_service import (
    MetadataErrorCode,
    MetadataServiceError,
    normalize_metadata,
)
from src.backend.downloader.url_validation import Platform
from src.bridge.metadata_bridge import MetadataBridge


@pytest.fixture(scope="module")
def qt_app():
    os.environ.setdefault("QT_QPA_PLATFORM", "offscreen")
    os.environ.setdefault("QT_QUICK_CONTROLS_STYLE", "Basic")
    app = QGuiApplication.instance() or QGuiApplication([])
    yield app


def wait_until(app, condition, timeout_ms=3000):
    deadline = time.monotonic() + timeout_ms / 1000
    while time.monotonic() < deadline:
        app.processEvents()
        if condition():
            return True
        QTest.qWait(10)
    app.processEvents()
    return condition()


@pytest.mark.parametrize(
    ("url", "error_code"),
    [
        (" ", "empty_url"),
        ("not a url", "malformed_url"),
        ("ftp://example.com/media", "unsupported_scheme"),
        ("https:///missing-host", "malformed_url"),
    ],
)
def test_bridge_rejects_invalid_url_without_starting_worker(qt_app, url, error_code):
    class NeverCalledService:
        def extract_metadata(self, url):
            pytest.fail(f"metadata service must not run for an invalid URL: {url}")

    bridge = MetadataBridge(NeverCalledService())
    bridge.fetch_metadata(url)
    qt_app.processEvents()

    assert bridge.loading is False
    assert bridge.success is False
    assert bridge.error is True
    assert bridge.error_code == error_code
    assert bridge.error_message
    if error_code == "empty_url":
        assert bridge.error_message == "Enter a media URL to continue."


def test_bridge_publishes_success_from_background_thread(qt_app):
    main_thread_id = threading.get_ident()
    worker_thread_ids = []

    class FakeService:
        def extract_metadata(self, url):
            worker_thread_ids.append(threading.get_ident())
            return normalize_metadata(
                {"title": "Bridge result", "uploader": "Creator", "formats": []},
                platform=Platform.YOUTUBE,
                fallback_url=url,
            )

    bridge = MetadataBridge(FakeService(), QThreadPool())
    bridge.fetch_metadata("https://youtu.be/mock")

    assert bridge.loading is True
    assert wait_until(qt_app, lambda: bridge.success or bridge.error)
    assert bridge.loading is False
    assert bridge.success is True
    assert bridge.error is False
    assert bridge.metadata["title"] == "Bridge result"
    assert bridge.metadata["platform"] == "YouTube"
    assert bridge.metadata["webpage_url"] == "https://youtu.be/mock"
    assert worker_thread_ids and worker_thread_ids[0] != main_thread_id


def test_bridge_publishes_safe_error_message(qt_app):
    class FailingService:
        def extract_metadata(self, url):
            raise MetadataServiceError(
                MetadataErrorCode.NETWORK,
                "A network problem prevented MediaFlow from reading this link. Try again shortly.",
                f"socket timeout for {url} with internal details",
            )

    bridge = MetadataBridge(FailingService(), QThreadPool())
    bridge.fetch_metadata("https://example.org/media")

    assert wait_until(qt_app, lambda: bridge.error)
    assert bridge.loading is False
    assert bridge.success is False
    assert bridge.error_code == MetadataErrorCode.NETWORK.value
    assert bridge.error_message.startswith("A network problem")
    assert "internal details" not in bridge.error_message


def test_bridge_ignores_duplicate_request_while_loading(qt_app):
    started = threading.Event()
    release = threading.Event()
    calls = []

    class SlowService:
        def extract_metadata(self, url):
            calls.append(url)
            started.set()
            release.wait(2)
            return normalize_metadata({"title": "Done", "formats": []})

    bridge = MetadataBridge(SlowService(), QThreadPool())
    try:
        bridge.fetch_metadata("https://example.org/first")
        assert started.wait(1)
        bridge.fetch_metadata("https://example.org/second")
        assert calls == ["https://example.org/first"]
    finally:
        release.set()
    assert wait_until(qt_app, lambda: bridge.success or bridge.error)


def test_downloader_qml_renders_loading_success_and_safe_error(qt_app):
    from pathlib import Path

    class FakeService:
        def __init__(self):
            self.release = threading.Event()

        def extract_metadata(self, url):
            if url.endswith("/unavailable"):
                raise MetadataServiceError(
                    MetadataErrorCode.UNAVAILABLE,
                    "This media is unavailable. Check the link or try another item.",
                    "raw extractor diagnostic",
                )
            self.release.wait(2)
            return normalize_metadata(
                {
                    "title": "Rendered metadata",
                    "uploader": "Test creator",
                    "duration": 125,
                    "formats": [
                        {
                            "format_id": "high",
                            "height": 1080,
                            "vcodec": "avc1",
                            "acodec": "none",
                        },
                        {
                            "format_id": "audio",
                            "vcodec": "none",
                            "acodec": "aac",
                            "abr": 192,
                        },
                    ],
                },
                platform=Platform.YOUTUBE,
                fallback_url=url,
            )

    service = FakeService()
    thread_pool = QThreadPool()
    bridge = MetadataBridge(service, thread_pool)
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("metadataController", bridge)
    base_dir = Path(__file__).resolve().parent.parent
    engine.load(QUrl.fromLocalFile(str(base_dir / "qml" / "Main.qml")))
    window = engine.rootObjects()[0]

    url_field = window.findChild(QQuickItem, "mediaUrlField")
    fetch_button = window.findChild(QQuickItem, "fetchMediaButton")
    loading_state = window.findChild(QQuickItem, "metadataLoadingState")
    result_state = window.findChild(QQuickItem, "metadataResultState")
    title = window.findChild(QQuickItem, "metadataTitle")
    error_state = window.findChild(QQuickItem, "metadataErrorState")
    error_message = window.findChild(QQuickItem, "metadataErrorMessage")
    assert all(
        (
            url_field,
            fetch_button,
            loading_state,
            result_state,
            title,
            error_state,
            error_message,
        )
    )

    url_field.setProperty("text", " https://youtu.be/mock ")
    point = fetch_button.mapToScene(fetch_button.boundingRect().center()).toPoint()
    QTest.mouseClick(
        window, Qt.MouseButton.LeftButton, Qt.KeyboardModifier.NoModifier, point
    )
    qt_app.processEvents()
    assert bridge.loading is True
    assert loading_state.isVisible() is True
    assert fetch_button.property("enabled") is False

    service.release.set()
    assert wait_until(qt_app, lambda: bridge.success or bridge.error)
    assert bridge.success is True
    assert result_state.isVisible() is True
    assert title.property("text") == "Rendered metadata"
    assert bridge.metadata["video_qualities"] == ["1080p"]
    assert bridge.metadata["audio_qualities"] == ["192 kbps audio"]

    bridge.fetch_metadata("https://youtu.be/unavailable")
    assert wait_until(qt_app, lambda: bridge.error)
    assert error_state.isVisible() is True
    assert (
        error_message.property("text")
        == "This media is unavailable. Check the link or try another item."
    )
    assert "raw extractor diagnostic" not in error_message.property("text")
    thread_pool.waitForDone(1000)
