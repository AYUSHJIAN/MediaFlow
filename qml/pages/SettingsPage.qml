import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: settingsPage

    ScrollView {
        anchors.fill: parent
        anchors.margins: 28
        contentWidth: settingsCol.width
        clip: true

        ColumnLayout {
            id: settingsCol
            width: settingsPage.width - 56
            spacing: 24

            // Page Header
            ColumnLayout {
                spacing: 4
                Text {
                    text: "CONFIGURATION"
                    font.pixelSize: 11
                    font.bold: true
                    color: "#35D39A"
                }
                Text {
                    text: "Workstation Settings & Environment"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#F5F7FA"
                }
                Text {
                    text: "Configure default output destinations, FFmpeg engine paths, and application preferences."
                    font.pixelSize: 13
                    color: "#8B93A1"
                }
            }

            // Section 1: Storage & Directories
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: storageCol.implicitHeight + 36
                radius: 10
                color: "#111318"
                border.color: "#292E36"
                border.width: 1

                ColumnLayout {
                    id: storageCol
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    Text {
                        text: "STORAGE & PATHS"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#8B93A1"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Text { text: "Default Download Directory"; font.pixelSize: 14; font.bold: true; color: "#F5F7FA" }
                            Text { text: "Where completed media downloads and extracted audio are saved."; font.pixelSize: 12; color: "#8B93A1" }
                        }

                        Rectangle {
                            implicitWidth: 220
                            implicitHeight: 34
                            radius: 6
                            color: "#181B22"
                            border.color: "#292E36"

                            Text {
                                anchors.centerIn: parent
                                text: "./downloads"
                                font.pixelSize: 12
                                color: "#00D4FF"
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "#181B22" }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Text { text: "Temporary Processing Scratchpad"; font.pixelSize: 14; font.bold: true; color: "#F5F7FA" }
                            Text { text: "Directory used by FFmpeg for intermediate demuxing and chunk processing."; font.pixelSize: 12; color: "#8B93A1" }
                        }

                        Rectangle {
                            implicitWidth: 220
                            implicitHeight: 34
                            radius: 6
                            color: "#181B22"
                            border.color: "#292E36"

                            Text {
                                anchors.centerIn: parent
                                text: "./temp"
                                font.pixelSize: 12
                                color: "#8B93A1"
                            }
                        }
                    }
                }
            }

            // Section 2: External Media Processing Engines
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: engineCol.implicitHeight + 36
                radius: 10
                color: "#111318"
                border.color: "#292E36"
                border.width: 1

                ColumnLayout {
                    id: engineCol
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 16

                    Text {
                        text: "MEDIA PROCESSING ENGINE (FFMPEG)"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#8B93A1"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            Text { text: "FFmpeg Discovery"; font.pixelSize: 14; font.bold: true; color: "#F5F7FA" }
                            Text { text: "Automatic system PATH detection or custom binary override path."; font.pixelSize: 12; color: "#8B93A1" }
                        }

                        Rectangle {
                            implicitWidth: 150
                            implicitHeight: 28
                            radius: 14
                            color: "#181B22"
                            border.color: "#35D39A"
                            border.width: 1

                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 6
                                Rectangle { width: 6; height: 6; radius: 3; color: "#35D39A" }
                                Text { text: "Phase 10 Service"; font.pixelSize: 11; color: "#35D39A"; font.bold: true }
                            }
                        }
                    }
                }
            }

            // Section 3: Application Info
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: infoCol.implicitHeight + 36
                radius: 10
                color: "#111318"
                border.color: "#292E36"
                border.width: 1

                ColumnLayout {
                    id: infoCol
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "ABOUT MEDIAFLOW WORKSTATION"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#8B93A1"
                    }

                    RowLayout {
                        spacing: 32
                        ColumnLayout {
                            spacing: 2
                            Text { text: "Application"; font.pixelSize: 11; color: "#8B93A1" }
                            Text { text: "MediaFlow Desktop"; font.pixelSize: 13; font.bold: true; color: "#F5F7FA" }
                        }
                        ColumnLayout {
                            spacing: 2
                            Text { text: "Version"; font.pixelSize: 11; color: "#8B93A1" }
                            Text { text: "0.1.0-alpha"; font.pixelSize: 13; font.bold: true; color: "#00D4FF" }
                        }
                        ColumnLayout {
                            spacing: 2
                            Text { text: "UI Engine"; font.pixelSize: 11; color: "#8B93A1" }
                            Text { text: "Qt 6 (Qt Quick / QML)"; font.pixelSize: 13; font.bold: true; color: "#7C5CFF" }
                        }
                        ColumnLayout {
                            spacing: 2
                            Text { text: "Backend Runtime"; font.pixelSize: 11; color: "#8B93A1" }
                            Text { text: "Python 3 & PySide6"; font.pixelSize: 13; font.bold: true; color: "#35D39A" }
                        }
                    }
                }
            }
        }
    }
}
