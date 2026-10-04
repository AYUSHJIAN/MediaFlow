"""yt-dlp metadata extraction and normalization, without media downloads."""

from collections.abc import Callable, Mapping
from enum import Enum
import math
import re
from typing import Any
from yt_dlp.utils import DownloadError

from .metadata_models import MediaFormat, MediaFormatKind, MediaMetadata
from .url_validation import Platform, validate_media_url


class MetadataErrorCode(str, Enum):
    INVALID_URL = "invalid_url"
    UNSUPPORTED_URL = "unsupported_url"
    UNAVAILABLE = "unavailable"
    PRIVATE_OR_RESTRICTED = "private_or_restricted"
    NETWORK = "network"
    EXTRACTION_FAILED = "extraction_failed"
    UNEXPECTED = "unexpected"


class MetadataServiceError(Exception):
    def __init__(self, code: MetadataErrorCode, message: str, detail: str = "") -> None:
        super().__init__(message)
        self.code = code
        self.message = message
        self.detail = detail


YdlFactory = Callable[[dict[str, object]], Any]


class MetadataService:
    """Extract one media item's metadata using yt-dlp's embedded Python API."""

    def __init__(self, ydl_factory: YdlFactory | None = None) -> None:
        self._ydl_factory = ydl_factory

    def extract_metadata(self, url: str) -> MediaMetadata:
        validation = validate_media_url(url)
        if not validation.valid or validation.normalized_url is None:
            raise MetadataServiceError(
                MetadataErrorCode.INVALID_URL,
                validation.error_message,
                validation.error_code.value if validation.error_code else "invalid_url",
            )

        options: dict[str, object] = {
            "quiet": True,
            "no_warnings": True,
            "noplaylist": True,
            "skip_download": True,
            "extract_flat": False,
            "socket_timeout": 20,
        }

        try:
            ydl_factory = self._ydl_factory or _default_ydl_factory
            with ydl_factory(options) as ydl:
                raw_info = ydl.extract_info(validation.normalized_url, download=False)
        except MetadataServiceError:
            raise
        except Exception as error:
            raise map_extraction_error(error) from error

        if not isinstance(raw_info, Mapping):
            raise MetadataServiceError(
                MetadataErrorCode.EXTRACTION_FAILED,
                "Media information could not be read from that link.",
                "yt-dlp returned no metadata mapping",
            )
        if raw_info.get("_type") in {"playlist", "multi_video"}:
            raise MetadataServiceError(
                MetadataErrorCode.UNSUPPORTED_URL,
                "This link points to a collection. Enter a link to one media item.",
                f"yt-dlp returned {_safe_text(raw_info.get('_type'))}",
            )

        return normalize_metadata(
            raw_info,
            platform=validation.platform,
            fallback_url=validation.normalized_url,
        )


def _default_ydl_factory(options: dict[str, object]) -> Any:
    from yt_dlp import YoutubeDL

    return YoutubeDL(options)


def normalize_metadata(
    raw_info: Mapping[str, object],
    platform: Platform = Platform.UNKNOWN,
    fallback_url: str | None = None,
) -> MediaMetadata:
    """Convert yt-dlp's variable response shape into stable application DTOs."""
    formats_by_key: dict[tuple[object, ...], MediaFormat] = {}
    raw_formats = raw_info.get("formats")
    if isinstance(raw_formats, (list, tuple)):
        for raw_format in raw_formats:
            if not isinstance(raw_format, Mapping):
                continue
            normalized = _normalize_format(raw_format)
            key = (
                ("id", normalized.format_id)
                if normalized.format_id
                else (
                    normalized.kind,
                    normalized.extension,
                    normalized.resolution,
                    normalized.video_codec,
                    normalized.audio_codec,
                    normalized.video_bitrate,
                    normalized.audio_bitrate,
                    normalized.filesize,
                )
            )
            formats_by_key.setdefault(key, normalized)

    formats = tuple(sorted(formats_by_key.values(), key=_format_sort_key))
    video_formats = [
        item
        for item in formats
        if item.kind in {MediaFormatKind.VIDEO, MediaFormatKind.COMBINED}
    ]
    audio_formats = [item for item in formats if item.kind is MediaFormatKind.AUDIO]
    formats_with_audio = [
        item
        for item in formats
        if item.kind in {MediaFormatKind.AUDIO, MediaFormatKind.COMBINED}
    ]

    video_qualities = _unique_sorted(
        item.quality_label for item in video_formats if item.quality_label
    )
    audio_qualities = _unique_sorted(
        item.quality_label for item in audio_formats if item.quality_label
    )

    width = _optional_int(raw_info.get("width"))
    height = _optional_int(raw_info.get("height"))
    fps = _optional_float(raw_info.get("fps"))
    top_video = (
        _codec(raw_info.get("vcodec")) is not None
        or width is not None
        or height is not None
    )
    top_audio = _codec(raw_info.get("acodec")) is not None

    return MediaMetadata(
        title=_optional_text(raw_info.get("title")) or "Untitled media",
        uploader=(
            _optional_text(raw_info.get("uploader"))
            or _optional_text(raw_info.get("channel"))
            or _optional_text(raw_info.get("creator"))
            or "Unknown uploader"
        ),
        platform=platform.value,
        duration=_optional_int(raw_info.get("duration")),
        thumbnail_url=_optional_text(raw_info.get("thumbnail")),
        webpage_url=_optional_text(raw_info.get("webpage_url")) or fallback_url,
        width=width,
        height=height,
        fps=fps,
        video_available=top_video or bool(video_formats),
        audio_available=top_audio or bool(formats_with_audio),
        formats=formats,
        qualities=video_qualities + audio_qualities,
        video_qualities=video_qualities,
        audio_qualities=audio_qualities,
    )


def map_extraction_error(error: Exception) -> MetadataServiceError:
    """Map yt-dlp/network exceptions to safe user-facing categories and messages."""
    detail = _safe_text(error)
    normalized = detail.lower()

    if any(
        term in normalized
        for term in (
            "private video",
            "private content",
            "members-only",
            "login required",
            "sign in",
            "age-restricted",
            "http error 403",
        )
    ):
        return MetadataServiceError(
            MetadataErrorCode.PRIVATE_OR_RESTRICTED,
            "This media is private or restricted and cannot be inspected.",
            detail,
        )
    if any(
        term in normalized
        for term in (
            "video unavailable",
            "video is unavailable",
            "media unavailable",
            "not available",
            "does not exist",
            "http error 404",
        )
    ):
        return MetadataServiceError(
            MetadataErrorCode.UNAVAILABLE,
            "This media is unavailable. Check the link or try another item.",
            detail,
        )
    if any(
        term in normalized
        for term in (
            "unsupported url",
            "no suitable extractor",
            "unsupported site",
            "not a valid url",
        )
    ):
        return MetadataServiceError(
            MetadataErrorCode.UNSUPPORTED_URL,
            "This link is not supported by the available media extractor.",
            detail,
        )
    if isinstance(error, (TimeoutError, ConnectionError)) or any(
        term in normalized
        for term in (
            "urlopen error",
            "timed out",
            "connection reset",
            "connection refused",
            "temporary failure",
            "network is unreachable",
            "failed to resolve",
            "name or service not known",
            "http error 429",
            "http error 5",
        )
    ):
        return MetadataServiceError(
            MetadataErrorCode.NETWORK,
            "A network problem prevented MediaFlow from reading this link. Try again shortly.",
            detail,
        )
    code = (
        MetadataErrorCode.EXTRACTION_FAILED
        if isinstance(error, DownloadError)
        else MetadataErrorCode.UNEXPECTED
    )
    message = (
        "MediaFlow could not read metadata from this link."
        if code is MetadataErrorCode.EXTRACTION_FAILED
        else "An unexpected problem prevented MediaFlow from reading this link."
    )
    return MetadataServiceError(code, message, detail)


def _normalize_format(raw_format: Mapping[str, object]) -> MediaFormat:
    width = _optional_int(raw_format.get("width"))
    height = _optional_int(raw_format.get("height"))
    fps = _optional_float(raw_format.get("fps"))
    video_codec = _codec(raw_format.get("vcodec"))
    audio_codec = _codec(raw_format.get("acodec"))
    has_video = video_codec is not None or width is not None or height is not None
    has_audio = audio_codec is not None
    if has_video and has_audio:
        kind = MediaFormatKind.COMBINED
    elif has_video:
        kind = MediaFormatKind.VIDEO
    elif has_audio:
        kind = MediaFormatKind.AUDIO
    else:
        kind = MediaFormatKind.UNKNOWN

    resolution = _optional_text(raw_format.get("resolution"))
    if not resolution and height is not None:
        resolution = f"{height}p"
    video_bitrate = _optional_float(raw_format.get("vbr"))
    audio_bitrate = _optional_float(raw_format.get("abr"))
    if has_video:
        quality_label = f"{height}p" if height is not None else (resolution or "Video")
    elif has_audio and audio_bitrate is not None:
        quality_label = f"{round(audio_bitrate)} kbps audio"
    elif has_audio:
        quality_label = "Audio-only"
    else:
        quality_label = "Unknown format"

    return MediaFormat(
        format_id=_optional_text(raw_format.get("format_id")),
        extension=_optional_text(raw_format.get("ext")),
        resolution=resolution,
        filesize=_optional_int(raw_format.get("filesize"))
        or _optional_int(raw_format.get("filesize_approx")),
        video_codec=video_codec,
        audio_codec=audio_codec,
        video_bitrate=video_bitrate,
        audio_bitrate=audio_bitrate,
        width=width,
        height=height,
        fps=fps,
        kind=kind,
        quality_label=quality_label,
    )


def _format_sort_key(item: MediaFormat) -> tuple[int, int, float, str]:
    kind_order = {
        MediaFormatKind.COMBINED: 0,
        MediaFormatKind.VIDEO: 1,
        MediaFormatKind.AUDIO: 2,
        MediaFormatKind.UNKNOWN: 3,
    }
    return (
        kind_order[item.kind],
        -(item.height or 0),
        -(item.video_bitrate or item.audio_bitrate or 0.0),
        item.format_id or "",
    )


def _unique_sorted(values: Any) -> tuple[str, ...]:
    unique = set(values)

    def quality_key(value: str) -> tuple[int, float, str]:
        height = re.fullmatch(r"(\d+)p", value)
        audio = re.fullmatch(r"(\d+(?:\.\d+)?) kbps audio", value)
        if height:
            return (0, -float(height.group(1)), value)
        if audio:
            return (1, -float(audio.group(1)), value)
        return (2, 0.0, value.lower())

    return tuple(sorted(unique, key=quality_key))


def _optional_text(value: object) -> str | None:
    if not isinstance(value, str):
        return None
    text = value.strip()
    return text if text and text.lower() != "none" else None


def _optional_int(value: object) -> int | None:
    if value is None or isinstance(value, bool):
        return None
    try:
        number = int(value)
    except (TypeError, ValueError, OverflowError):
        return None
    return number if number >= 0 else None


def _optional_float(value: object) -> float | None:
    if value is None or isinstance(value, bool):
        return None
    try:
        number = float(value)
    except (TypeError, ValueError, OverflowError):
        return None
    return number if math.isfinite(number) and number >= 0 else None


def _codec(value: object) -> str | None:
    text = _optional_text(value)
    return None if text is None or text.lower() in {"none", "unknown"} else text


def _safe_text(value: object) -> str:
    try:
        return str(value)
    except Exception:
        return type(value).__name__
