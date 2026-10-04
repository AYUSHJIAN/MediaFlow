"""MediaFlow — Desktop Application Entrypoint.

Initializes the PySide6 Qt Quick runtime, sets up application logging,
resolves filesystem resources safely via pathlib, and instantiates
the main QML interface engine.
"""

import sys
from pathlib import Path
from PySide6.QtCore import QUrl, Qt
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from src.backend.logging import setup_logging


def main() -> int:
    """Launch the MediaFlow desktop application."""
    # 1. Initialize application logging
    logger = setup_logging()
    logger.info("Starting MediaFlow Desktop Workstation (Phase 2 Application Shell)")

    # 2. Configure Qt application properties
    app = QGuiApplication(sys.argv)
    app.setApplicationName("MediaFlow")
    app.setOrganizationName("MediaFlow")
    app.setOrganizationDomain("mediaflow.local")

    # 3. Resolve paths via pathlib
    base_dir = Path(__file__).resolve().parent
    qml_file = base_dir / "qml" / "Main.qml"

    if not qml_file.exists():
        logger.critical("Root QML file not found at: %s", qml_file)
        return 1

    # 4. Initialize QML Application Engine
    engine = QQmlApplicationEngine()

    # Safety hook: terminate immediately if QML compilation or object instantiation fails
    def on_object_created(obj, obj_url):
        if obj is None:
            logger.critical("QML Engine failed to create root object from: %s", obj_url)
            sys.exit(-1)

    engine.objectCreated.connect(on_object_created, Qt.ConnectionType.QueuedConnection)

    # 5. Load root QML document
    logger.info("Loading QML root from: %s", qml_file)
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        logger.critical("No root objects created by QML engine. Exiting.")
        return 1

    # Smoke testing convenience: auto-exit if requested
    if "--test-run" in sys.argv:
        from PySide6.QtCore import QTimer
        logger.info("Test-run flag detected: scheduling auto-close in 1000ms.")
        QTimer.singleShot(1000, app.quit)

    logger.info("MediaForge initialized successfully. Entering Qt event loop.")
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
