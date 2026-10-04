"""Logging configuration and setup for MediaForge."""

import logging
import sys
from pathlib import Path


def setup_logging(level: int = logging.INFO, log_file: Path | None = None) -> logging.Logger:
    """Configure unified logging for the application.

    Args:
        level: Minimum log level to capture (default: logging.INFO)
        log_file: Optional file path to write log output

    Returns:
        The configured root or application logger
    """
    formatter = logging.Formatter(
        fmt="%(asctime)s [%(levelname)s] %(name)s (%(threadName)s): %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    logger = logging.getLogger("mediaforge")
    logger.setLevel(level)

    # Clear existing handlers to prevent duplicate messages
    if logger.hasHandlers():
        logger.handlers.clear()

    # Console stream handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)

    # Optional file handler
    if log_file:
        log_file.parent.mkdir(parents=True, exist_ok=True)
        file_handler = logging.FileHandler(str(log_file), encoding="utf-8")
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    return logger
