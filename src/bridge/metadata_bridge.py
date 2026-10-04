"""Asynchronous QObject adapter for QML metadata requests."""

import logging
from typing import Any
from uuid import uuid4

from PySide6.QtCore import QObject, Property, QRunnable, QThreadPool, Qt, Signal, Slot

from src.backend.downloader.metadata_models import MediaMetadata
from src.backend.downloader.metadata_service import (
    MetadataErrorCode,
    MetadataService,
    MetadataServiceError,
)
from src.backend.downloader.url_validation import validate_media_url


_logger = logging.getLogger("mediaforge.metadata")


def _empty_metadata() -> dict[str, Any]:
    return {
        "title": "",
        "uploader": "",
        "platform": "",
        "duration": None,
        "duration_text": "",
        "thumbnail_url": "",
        "webpage_url": "",
        "width": 0,
        "height": 0,
        "fps": 0,
        "video_available": False,
        "audio_available": False,
        "formats": [],
        "qualities": [],
        "video_qualities": [],
        "audio_qualities": [],
    }


class _WorkerSignals(QObject):
    completed = Signal(str, object)
    failed = Signal(str, str, str)


class _MetadataWorker(QRunnable):
    def __init__(self, request_id: str, url: str, service: MetadataService) -> None:
        super().__init__()
        self.request_id = request_id
        self.url = url
        self.service = service
        self.signals = _WorkerSignals()
        self.setAutoDelete(True)

    @Slot()
    def run(self) -> None:
        try:
            metadata = self.service.extract_metadata(self.url)
        except MetadataServiceError as error:
            if error.__cause__ is not None:
                _logger.error(
                    "Metadata request failed (%s): %s",
                    error.code.value,
                    error.detail,
                    exc_info=(
                        type(error.__cause__),
                        error.__cause__,
                        error.__cause__.__traceback__,
                    ),
                )
            else:
                _logger.warning(
                    "Metadata request failed (%s): %s", error.code.value, error.detail
                )
            self.signals.failed.emit(
                self.request_id,
                error.code.value,
                error.message,
            )
        except Exception as error:
            _logger.exception("Unexpected metadata worker failure")
            self.signals.failed.emit(
                self.request_id,
                MetadataErrorCode.UNEXPECTED.value,
                "An unexpected problem prevented MediaFlow from reading this link.",
            )
        else:
            self.signals.completed.emit(self.request_id, metadata)


class MetadataBridge(QObject):
    """Validate QML requests and publish worker results as bindable properties."""

    stateChanged = Signal()

    def __init__(
        self,
        service: MetadataService | None = None,
        thread_pool: QThreadPool | None = None,
        parent: QObject | None = None,
    ) -> None:
        super().__init__(parent)
        self._service = service or MetadataService()
        self._thread_pool = thread_pool or QThreadPool.globalInstance()
        self._loading = False
        self._success = False
        self._error = False
        self._error_code = ""
        self._error_message = ""
        self._metadata = _empty_metadata()
        self._active_request_id = ""
        self._workers: dict[str, _MetadataWorker] = {}

    @Property(bool, notify=stateChanged)
    def loading(self) -> bool:
        return self._loading

    @Property(bool, notify=stateChanged)
    def success(self) -> bool:
        return self._success

    @Property(bool, notify=stateChanged)
    def error(self) -> bool:
        return self._error

    @Property(str, notify=stateChanged)
    def error_code(self) -> str:
        return self._error_code

    @Property(str, notify=stateChanged)
    def error_message(self) -> str:
        return self._error_message

    @Property("QVariantMap", notify=stateChanged)
    def metadata(self) -> dict[str, Any]:
        return dict(self._metadata)

    @Slot(str)
    def fetch_metadata(self, url: str) -> None:
        """Start one metadata request; duplicate requests are ignored while busy."""
        if self._loading:
            return

        validation = validate_media_url(url)
        if not validation.valid or validation.normalized_url is None:
            self._update_state(
                loading=False,
                success=False,
                error=True,
                error_code=validation.error_code.value
                if validation.error_code
                else MetadataErrorCode.INVALID_URL.value,
                error_message=validation.error_message,
                metadata=_empty_metadata(),
            )
            return

        request_id = uuid4().hex
        self._active_request_id = request_id
        self._update_state(
            loading=True,
            success=False,
            error=False,
            error_code="",
            error_message="",
            metadata=_empty_metadata(),
        )

        worker = _MetadataWorker(request_id, validation.normalized_url, self._service)
        worker.signals.completed.connect(
            self._on_completed, Qt.ConnectionType.QueuedConnection
        )
        worker.signals.failed.connect(
            self._on_failed, Qt.ConnectionType.QueuedConnection
        )
        self._workers[request_id] = worker
        try:
            self._thread_pool.start(worker)
        except Exception:
            self._workers.pop(request_id, None)
            _logger.exception("Could not start metadata worker")
            self._update_state(
                loading=False,
                success=False,
                error=True,
                error_code=MetadataErrorCode.UNEXPECTED.value,
                error_message="MediaFlow could not start the metadata request. Try again.",
                metadata=_empty_metadata(),
            )

    @Slot(str, object)
    def _on_completed(self, request_id: str, metadata: MediaMetadata) -> None:
        self._workers.pop(request_id, None)
        if request_id != self._active_request_id:
            return
        if not isinstance(metadata, MediaMetadata):
            self._on_failed(
                request_id,
                MetadataErrorCode.UNEXPECTED.value,
                "MediaFlow received an invalid metadata result.",
            )
            return
        self._update_state(
            loading=False,
            success=True,
            error=False,
            error_code="",
            error_message="",
            metadata=metadata.to_qml_dict(),
        )

    @Slot(str, str, str)
    def _on_failed(self, request_id: str, code: str, message: str) -> None:
        self._workers.pop(request_id, None)
        if request_id != self._active_request_id:
            return
        self._update_state(
            loading=False,
            success=False,
            error=True,
            error_code=code,
            error_message=message,
            metadata=_empty_metadata(),
        )

    def _update_state(
        self,
        *,
        loading: bool,
        success: bool,
        error: bool,
        error_code: str,
        error_message: str,
        metadata: dict[str, Any],
    ) -> None:
        values = {
            "_loading": loading,
            "_success": success,
            "_error": error,
            "_error_code": error_code,
            "_error_message": error_message,
            "_metadata": metadata,
        }
        changed = False
        for name, value in values.items():
            if getattr(self, name) != value:
                setattr(self, name, value)
                changed = True
        if changed:
            self.stateChanged.emit()
