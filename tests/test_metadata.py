"""Unit tests for Phase 4 URL and metadata behavior."""

import pytest

from src.backend.downloader.url_validation import (
    Platform,
    UrlValidationCode,
    identify_platform,
    validate_media_url,
)
from src.backend.downloader.metadata_models import (
    MediaFormatKind,
    format_duration,
)
from src.backend.downloader.metadata_service import (
    MetadataErrorCode,
    MetadataService,
    MetadataServiceError,
    map_extraction_error,
    normalize_metadata,
)
from yt_dlp.utils import DownloadError


@pytest.mark.parametrize("value", [None, "", "   "])
def test_url_validation_rejects_empty_values(value):
    result = validate_media_url(value)

    assert not result.valid
    assert result.error_code is UrlValidationCode.EMPTY
    assert result.error_message


@pytest.mark.parametrize(
    ("value", "error_code"),
    [
        ("youtube.com/watch?v=abc", UrlValidationCode.UNSUPPORTED_SCHEME),
        ("file:///video.mp4", UrlValidationCode.UNSUPPORTED_SCHEME),
        ("https:///watch?v=abc", UrlValidationCode.MALFORMED),
        ("https://[invalid", UrlValidationCode.MALFORMED),
        ("https://user:pass@example.com/video", UrlValidationCode.MALFORMED),
        ("https://bad host.example/video", UrlValidationCode.MALFORMED),
    ],
)
def test_url_validation_returns_structured_errors(value, error_code):
    result = validate_media_url(value)

    assert not result.valid
    assert result.error_code is error_code
    assert result.normalized_url is None
    assert result.error_message


def test_url_validation_trims_and_accepts_unknown_http_url():
    result = validate_media_url("  https://media.example/watch?id=1  ")

    assert result.valid
    assert result.normalized_url == "https://media.example/watch?id=1"
    assert result.platform is Platform.UNKNOWN
    assert result.error_code is None


@pytest.mark.parametrize(
    ("hostname", "platform"),
    [
        ("www.youtube.com", Platform.YOUTUBE),
        ("youtu.be", Platform.YOUTUBE),
        ("music.youtube.com", Platform.YOUTUBE),
        ("www.instagram.com", Platform.INSTAGRAM),
        ("instagr.am", Platform.INSTAGRAM),
        ("www.pinterest.com", Platform.PINTEREST),
        ("pin.it", Platform.PINTEREST),
        ("youtube.com.example.org", Platform.UNKNOWN),
    ],
)
def test_platform_identification(hostname, platform):
    assert identify_platform(hostname) is platform


def test_platform_detection_does_not_reject_unknown_site():
    result = validate_media_url("https://unknown.example/video")

    assert result.valid
    assert result.platform is Platform.UNKNOWN


def test_metadata_normalization_groups_formats_and_deduplicates_qualities():
    metadata = normalize_metadata(
        {
            "title": "  Sample clip  ",
            "channel": "Sample creator",
            "duration": 83,
            "thumbnail": "https://img.example/thumb.jpg",
            "webpage_url": "https://youtu.be/example",
            "width": 1920,
            "height": 1080,
            "fps": 30,
            "formats": [
                {
                    "format_id": "combined",
                    "ext": "mp4",
                    "height": 720,
                    "vcodec": "avc1",
                    "acodec": "mp4a",
                    "filesize": 1200,
                },
                {
                    "format_id": "video-1080",
                    "ext": "mp4",
                    "height": 1080,
                    "vcodec": "avc1",
                    "acodec": "none",
                    "vbr": 2200,
                },
                {
                    "format_id": "video-1080-alt",
                    "ext": "webm",
                    "height": 1080,
                    "vcodec": "vp9",
                    "acodec": "none",
                    "vbr": 1800,
                },
                {
                    "format_id": "audio-128",
                    "ext": "m4a",
                    "vcodec": "none",
                    "acodec": "aac",
                    "abr": 128,
                },
                {
                    "format_id": "audio-320",
                    "ext": "mp3",
                    "vcodec": "none",
                    "acodec": "mp3",
                    "abr": 320,
                },
            ],
        },
        platform=Platform.YOUTUBE,
    )

    assert metadata.title == "Sample clip"
    assert metadata.uploader == "Sample creator"
    assert metadata.duration_text == "1:23"
    assert metadata.platform == "YouTube"
    assert metadata.video_available and metadata.audio_available
    assert metadata.video_qualities == ("1080p", "720p")
    assert metadata.audio_qualities == ("320 kbps audio", "128 kbps audio")
    assert metadata.qualities == metadata.video_qualities + metadata.audio_qualities
    assert {item.kind for item in metadata.formats} == {
        MediaFormatKind.VIDEO,
        MediaFormatKind.AUDIO,
        MediaFormatKind.COMBINED,
    }
    assert len([item for item in metadata.qualities if item == "1080p"]) == 1
    assert metadata.formats[0].kind is MediaFormatKind.COMBINED


def test_metadata_normalization_handles_missing_fields():
    metadata = normalize_metadata({}, fallback_url="https://media.example/item")
    qml_value = metadata.to_qml_dict()

    assert metadata.title == "Untitled media"
    assert metadata.uploader == "Unknown uploader"
    assert metadata.duration is None
    assert metadata.duration_text == "Unknown duration"
    assert metadata.thumbnail_url is None
    assert metadata.webpage_url == "https://media.example/item"
    assert metadata.width is None and metadata.height is None and metadata.fps is None
    assert metadata.video_available is False
    assert metadata.audio_available is False
    assert metadata.formats == ()
    assert qml_value["formats"] == []
    assert qml_value["thumbnail_url"] == ""


def test_format_without_codec_or_dimensions_is_not_assumed_to_be_audio():
    metadata = normalize_metadata(
        {"formats": [{"format_id": "incomplete", "ext": "mp4"}]}
    )

    assert metadata.formats[0].kind is MediaFormatKind.UNKNOWN
    assert metadata.formats[0].quality_label == "Unknown format"
    assert metadata.video_available is False
    assert metadata.audio_available is False


@pytest.mark.parametrize(
    ("duration", "expected"),
    [
        (0, "0:00"),
        (83, "1:23"),
        (3661, "1:01:01"),
        (None, None),
        (-1, None),
        (True, None),
    ],
)
def test_duration_formatting(duration, expected):
    assert format_duration(duration) == expected


@pytest.mark.parametrize(
    ("error", "code"),
    [
        (DownloadError("Unsupported URL: example"), MetadataErrorCode.UNSUPPORTED_URL),
        (DownloadError("Video unavailable"), MetadataErrorCode.UNAVAILABLE),
        (DownloadError("This video is unavailable"), MetadataErrorCode.UNAVAILABLE),
        (
            DownloadError("Private video; login required"),
            MetadataErrorCode.PRIVATE_OR_RESTRICTED,
        ),
        (
            DownloadError("Unable to download webpage: <urlopen error timed out>"),
            MetadataErrorCode.NETWORK,
        ),
        (
            DownloadError("Unexpected extractor response"),
            MetadataErrorCode.EXTRACTION_FAILED,
        ),
        (RuntimeError("unexpected library failure"), MetadataErrorCode.UNEXPECTED),
    ],
)
def test_extraction_error_mapping(error, code):
    result = map_extraction_error(error)

    assert result.code is code
    assert result.message
    assert result.detail == str(error)


def test_metadata_service_calls_embedded_api_without_downloads():
    calls = {}

    class FakeYoutubeDL:
        def __init__(self, options):
            calls["options"] = options

        def __enter__(self):
            return self

        def __exit__(self, exc_type, exc_value, traceback):
            calls["exit"] = (exc_type, exc_value, traceback)
            return False

        def extract_info(self, url, download):
            calls["url"] = url
            calls["download"] = download
            return {"title": "Mocked", "formats": []}

    metadata = MetadataService(FakeYoutubeDL).extract_metadata(
        " https://youtu.be/mock "
    )

    assert calls["url"] == "https://youtu.be/mock"
    assert calls["download"] is False
    assert calls["options"]["skip_download"] is True
    assert calls["options"]["noplaylist"] is True
    assert calls["exit"] == (None, None, None)
    assert metadata.title == "Mocked"
    assert metadata.platform == "YouTube"


def test_metadata_service_does_not_call_extractor_for_invalid_url():
    def fail_if_called(options):
        pytest.fail(f"yt-dlp must not run for invalid URLs: {options}")

    with pytest.raises(MetadataServiceError) as error:
        MetadataService(fail_if_called).extract_metadata(" ")

    assert error.value.code is MetadataErrorCode.INVALID_URL
