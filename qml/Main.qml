import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1080
    height: 720
    minimumWidth: 800
    minimumHeight: 600
    title: "MediaForge — Professional Creator Workstation"
    color: "#08090C"

    // Top Navigation / Header
    header: ToolBar {
        background: Rectangle {
            color: "#111318"
            border.color: "#292E36"
            border.width: 1

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#292E36"
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 16

            // App Brand
            RowLayout {
                spacing: 10
                Rectangle {
                    width: 28
                    height: 28
                    radius: 6
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#7C5CFF" }
                        GradientStop { position: 1.0; color: "#00D4FF" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "M"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                Text {
                    text: "MediaForge"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#F5F7FA"
                }

                Text {
                    text: "STUDIO"
                    font.pixelSize: 10
                    font.bold: true
                    color: "#7C5CFF"
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            Item { Layout.fillWidth: true }

            // Phase Status Badge
            Rectangle {
                implicitWidth: badgeRow.implicitWidth + 20
                implicitHeight: 28
                radius: 14
                color: "#181B22"
                border.color: "#7C5CFF"
                border.width: 1

                RowLayout {
                    id: badgeRow
                    anchors.centerIn: parent
                    spacing: 6

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#35D39A"
                    }

                    Text {
                        text: "Phase 1: Foundation Ready"
                        color: "#F5F7FA"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                }
            }
        }
    }

    // Main Workstation Canvas
    ScrollView {
        anchors.fill: parent
        anchors.margins: 32
        contentWidth: mainCol.width
        clip: true

        ColumnLayout {
            id: mainCol
            width: rootWindow.width - 64
            spacing: 24

            // Welcome / Hero Banner
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 130
                radius: 12
                color: "#111318"
                border.color: "#292E36"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 8

                    RowLayout {
                        spacing: 8
                        Text {
                            text: "CREATOR MEDIA WORKSTATION"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: "#00D4FF"
                        }
                    }

                    Text {
                        text: "Professional Media Ingestion, Transcoding & Asset Pipeline"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#F5F7FA"
                    }

                    Text {
                        text: "Architecture initialized with PySide6, Qt Quick, modular Python service layer, and strict separation of concerns."
                        font.pixelSize: 13
                        color: "#8B93A1"
                    }
                }
            }

            // Section Label
            Text {
                text: "SYSTEM MODULES"
                font.pixelSize: 12
                font.weight: Font.Bold
                color: "#8B93A1"
            }

            // Workstation Capability Grid
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 16
                rowSpacing: 16

                // Module 1: Downloader
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 110
                    radius: 10
                    color: "#111318"
                    border.color: "#292E36"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 6

                        RowLayout {
                            spacing: 8
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: "#7C5CFF"
                            }
                            Text {
                                text: "Downloader Engine"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#F5F7FA"
                            }
                        }

                        Text {
                            text: "yt-dlp Python integration with in-memory metadata extraction, format resolution, and progress tracking."
                            font.pixelSize: 12
                            color: "#8B93A1"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                // Module 2: Converter
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 110
                    radius: 10
                    color: "#111318"
                    border.color: "#292E36"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 6

                        RowLayout {
                            spacing: 8
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: "#00D4FF"
                            }
                            Text {
                                text: "Converter & Transcoder"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#F5F7FA"
                            }
                        }

                        Text {
                            text: "FFmpeg media processing engine for audio extraction (MP4 → MP3) and container remuxing/transcoding (MP4 ↔ MOV)."
                            font.pixelSize: 12
                            color: "#8B93A1"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                // Module 3: Filesystem & Safety
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 110
                    radius: 10
                    color: "#111318"
                    border.color: "#292E36"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 6

                        RowLayout {
                            spacing: 8
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: "#35D39A"
                            }
                            Text {
                                text: "Filesystem & Security"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#F5F7FA"
                            }
                        }

                        Text {
                            text: "Object-oriented pathlib architecture, filename sanitization, collision resolution, and path traversal prevention."
                            font.pixelSize: 12
                            color: "#8B93A1"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                // Module 4: History & Config
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 110
                    radius: 10
                    color: "#111318"
                    border.color: "#292E36"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 6

                        RowLayout {
                            spacing: 8
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: "#FFB547"
                            }
                            Text {
                                text: "History & Storage"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#F5F7FA"
                            }
                        }

                        Text {
                            text: "SQLite persistent operational log and JSON user configuration management."
                            font.pixelSize: 12
                            color: "#8B93A1"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }

    // Status Footer
    footer: ToolBar {
        background: Rectangle {
            color: "#08090C"
            border.color: "#292E36"
            border.width: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24

            Text {
                text: "PySide6 (Qt 6) • QML Hardware-Accelerated Viewport • Python 3"
                font.pixelSize: 11
                color: "#8B93A1"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "MediaForge v0.1.0"
                font.pixelSize: 11
                color: "#8B93A1"
            }
        }
    }
}
