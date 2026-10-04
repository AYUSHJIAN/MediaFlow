"""URL validation and platform labeling for media metadata requests."""

from dataclasses import dataclass
from enum import Enum
from urllib.parse import urlsplit


class Platform(str, Enum):
    """Recognized platform labels; labels do not imply extractor support."""

    YOUTUBE = "YouTube"
    INSTAGRAM = "Instagram"
    PINTEREST = "Pinterest"
    UNKNOWN = "Unknown"


class UrlValidationCode(str, Enum):
    EMPTY = "empty_url"
    MALFORMED = "malformed_url"
    UNSUPPORTED_SCHEME = "unsupported_scheme"


@dataclass(frozen=True, slots=True)
class UrlValidationResult:
    valid: bool
    normalized_url: str | None
    platform: Platform
    error_code: UrlValidationCode | None = None
    error_message: str = ""


def identify_platform(hostname: str | None) -> Platform:
    """Return a display label for a hostname without asserting extractor support."""
    if not hostname:
        return Platform.UNKNOWN

    host = hostname.lower().rstrip(".")
    if host == "youtu.be" or host == "youtube.com" or host.endswith(".youtube.com"):
        return Platform.YOUTUBE
    if host in {"instagram.com", "instagr.am"} or host.endswith(".instagram.com"):
        return Platform.INSTAGRAM
    if host in {"pinterest.com", "pin.it"} or host.endswith(".pinterest.com"):
        return Platform.PINTEREST
    return Platform.UNKNOWN


def validate_media_url(value: str | None) -> UrlValidationResult:
    """Trim and validate an absolute HTTP(S) URL for metadata extraction."""
    candidate = value.strip() if isinstance(value, str) else ""
    if not candidate:
        return UrlValidationResult(
            valid=False,
            normalized_url=None,
            platform=Platform.UNKNOWN,
            error_code=UrlValidationCode.EMPTY,
            error_message="Enter a media URL to continue.",
        )

    if any(ord(character) <= 32 or ord(character) == 127 for character in candidate):
        return _malformed_url()

    try:
        parsed = urlsplit(candidate)
        hostname = parsed.hostname
        parsed.port
    except ValueError:
        return _malformed_url()

    if parsed.scheme.lower() not in {"http", "https"}:
        return UrlValidationResult(
            valid=False,
            normalized_url=None,
            platform=Platform.UNKNOWN,
            error_code=UrlValidationCode.UNSUPPORTED_SCHEME,
            error_message="Use a link that starts with http:// or https://.",
        )

    if not hostname or parsed.username is not None or parsed.password is not None:
        return _malformed_url()

    try:
        ascii_hostname = hostname.encode("idna").decode("ascii")
    except UnicodeError:
        return _malformed_url()

    if len(ascii_hostname) > 253 or any(
        not label or len(label) > 63 or label.startswith("-") or label.endswith("-")
        for label in ascii_hostname.rstrip(".").split(".")
    ):
        return _malformed_url()

    return UrlValidationResult(
        valid=True,
        normalized_url=parsed.geturl(),
        platform=identify_platform(ascii_hostname),
    )


def _malformed_url() -> UrlValidationResult:
    return UrlValidationResult(
        valid=False,
        normalized_url=None,
        platform=Platform.UNKNOWN,
        error_code=UrlValidationCode.MALFORMED,
        error_message="That link doesn't look like a valid web address.",
    )
