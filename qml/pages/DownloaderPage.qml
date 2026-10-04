import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: downloaderPage

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // Page Header
        ColumnLayout {
            spacing: 4
            Text {
                text: "MEDIA DOWNLOADER"
                font.pixelSize: 11
                font.bold: true
                color: "#7C5CFF"
            }
            Text {
                text: "Download & Extract Online Media"
                font.pixelSize: 22
                font.bold: true
                color: "#F5F7FA"
            }
            Text {
                text: "Ingest high-fidelity media from YouTube, Instagram, and Pinterest using yt-dlp."
                font.pixelSize: 13
                color: "#8B93A1"
            }
        }

        // URL Input Simulation / Placeholder Card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 90
            radius: 10
            color: "#111318"
            border.color: "#292E36"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 16

                Rectangle {
                    width: 38
                    height: 38
                    radius: 8
                    color: "#181B22"
                    border.color: "#292E36"

                    Text {
                        anchors.centerIn: parent
                        text: "🔗"
                        font.pixelSize: 16
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Text {
                        text: "Media Ingestion Bar (Phase 4 Metadata Service)"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#F5F7FA"
                    }
                    Text {
                        text: "Paste a media URL to fetch resolutions, audio streams, and metadata in-memory."
                        font.pixelSize: 12
                        color: "#8B93A1"
                    }
                }

                Rectangle {
                    implicitWidth: 110
                    implicitHeight: 36
                    radius: 6
                    color: "#7C5CFF"
                    opacity: 0.85

                    Text {
                        anchors.centerIn: parent
                        text: "Fetch Media"
                        color: "#FFFFFF"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }
            }
        }

        // Workstation Content Placeholder Cards
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Left Card: Media Preview & Stream Selector
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 6
                radius: 10
                color: "#111318"
                border.color: "#292E36"
                border.width: 1

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 56
                        height: 56
                        radius: 28
                        color: "#181B22"
                        border.color: "#292E36"

                        Text {
                            anchors.centerIn: parent
                            text: "🎬"
                            font.pixelSize: 24
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "No Media Loaded"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#F5F7FA"
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Enter a supported media URL above to inspect formats and stream details."
                        font.pixelSize: 12
                        color: "#8B93A1"
                    }
                }
            }

            // Right Card: Download Configuration & Options
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 4
                radius: 10
                color: "#111318"
                border.color: "#292E36"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 14

                    Text {
                        text: "DOWNLOAD OPTIONS"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#00D4FF"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#292E36"
                    }

                    Repeater {
                        model: [
                            { title: "Format Selection", desc: "MP4 Video / MP3 Audio" },
                            { title: "Quality Preference", desc: "Best Available (Up to 4K)" },
                            { title: "Save Destination", desc: "./downloads/" },
                            { title: "Filename Pattern", desc: "Auto-sanitized title" }
                        ]

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                width: 6
                                height: 6
                                radius: 3
                                color: "#7C5CFF"
                            }

                            ColumnLayout {
                                spacing: 2
                                Text {
                                    text: modelData.title
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                    color: "#F5F7FA"
                                }
                                Text {
                                    text: modelData.desc
                                    font.pixelSize: 11
                                    color: "#8B93A1"
                                }
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 40
                        radius: 6
                        color: "#181B22"
                        border.color: "#292E36"

                        Text {
                            anchors.centerIn: parent
                            text: "Awaiting Media URL..."
                            font.pixelSize: 12
                            color: "#8B93A1"
                        }
                    }
                }
            }
        }
    }
}
