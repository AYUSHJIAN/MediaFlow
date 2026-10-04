"""Application-level metadata DTOs shared by services and the Qt bridge."""

from dataclasses import dataclass
from enum import Enum


class MediaFormatKind(str, Enum):
    VIDEO = "video"
    AUDIO = "audio"
    COMBINED = "combined"
    UNKNOWN = "unknown"


@dataclass(frozen=True, slots=True)
class MediaFormat:
    format_id: str | None
    extension: str | None
    resolution: str | None
    filesize: int | None
    video_codec: str | None
    audio_codec: str | None
    video_bitrate: float | None
    audio_bitrate: float | None
    width: int | None
    height: int | None
    fps: float | None
    kind: MediaFormatKind
    quality_label: str

    def to_qml_dict(self) -> dict[str, str | int | float | None]:
        """Return only normalized, presentation-safe fields for QML."""
        return {
            "format_id": self.format_id,
            "extension": self.extension,
            "resolution": self.resolution,
            "filesize": self.filesize,
            "video_codec": self.video_codec,
            "audio_codec": self.audio_codec,
            "video_bitrate": self.video_bitrate,
            "audio_bitrate": self.audio_bitrate,
            "width": self.width,
            "height": self.height,
            "fps": self.fps,
            "kind": self.kind.value,
            "quality_label": self.quality_label,
        }


@dataclass(frozen=True, slots=True)
class MediaMetadata:
    title: str
    uploader: str
    platform: str
    duration: int | None
    thumbnail_url: str | None
    webpage_url: str | None
    width: int | None
    height: int | None
    fps: float | None
    video_available: bool
    audio_available: bool
    formats: tuple[MediaFormat, ...]
    qualities: tuple[str, ...]
    video_qualities: tuple[str, ...]
    audio_qualities: tuple[str, ...]

    @property
    def duration_text(self) -> str:
        return format_duration(self.duration) or "Unknown duration"

    def to_qml_dict(self) -> dict[str, object]:
        """Serialize the normalized DTO, never a raw yt-dlp response, for QML."""
        return {
            "title": self.title,
            "uploader": self.uploader,
            "platform": self.platform,
            "duration": self.duration,
            "duration_text": self.duration_text,
            "thumbnail_url": self.thumbnail_url or "",
            "webpage_url": self.webpage_url or "",
            "width": self.width or 0,
            "height": self.height or 0,
            "fps": self.fps or 0,
            "video_available": self.video_available,
            "audio_available": self.audio_available,
            "formats": [item.to_qml_dict() for item in self.formats],
            "qualities": list(self.qualities),
            "video_qualities": list(self.video_qualities),
            "audio_qualities": list(self.audio_qualities),
        }


def format_duration(duration: int | float | None) -> str | None:
    """Format seconds as M:SS or H:MM:SS; return None for invalid values."""
    if duration is None or isinstance(duration, bool):
        return None
    try:
        total_seconds = int(round(float(duration)))
    except (TypeError, ValueError, OverflowError):
        return None
    if total_seconds < 0:
        return None

    seconds = total_seconds % 60
    minutes = (total_seconds // 60) % 60
    hours = total_seconds // 3600
    if hours:
        return f"{hours}:{minutes:02d}:{seconds:02d}"
    return f"{total_seconds // 60}:{seconds:02d}"
