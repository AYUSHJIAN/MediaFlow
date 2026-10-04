import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: converterPage

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // Page Header
        ColumnLayout {
            spacing: 4
            Text {
                text: "MEDIA CONVERTER"
                font.pixelSize: 11
                font.bold: true
                color: "#00D4FF"
            }
            Text {
                text: "Transcode, Remux & Extract Audio"
                font.pixelSize: 22
                font.bold: true
                color: "#F5F7FA"
            }
            Text {
                text: "Hardware-accelerated FFmpeg processing for MP4, MP3, and MOV formats."
                font.pixelSize: 13
                color: "#8B93A1"
            }
        }

        // File Dropzone Card
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 160
            radius: 12
            color: "#111318"
            border.color: "#292E36"
            border.width: 1

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 52
                    height: 52
                    radius: 26
                    color: "#181B22"
                    border.color: "#00D4FF"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "📁"
                        font.pixelSize: 22
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Drag and drop local video or audio files here"
                    font.pixelSize: 15
                    font.bold: true
                    color: "#F5F7FA"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Supported input containers: MP4, MOV, MKV, WebM"
                    font.pixelSize: 12
                    color: "#8B93A1"
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 120
                    implicitHeight: 32
                    radius: 6
                    color: "#181B22"
                    border.color: "#292E36"

                    Text {
                        anchors.centerIn: parent
                        text: "Browse Files..."
                        font.pixelSize: 12
                        color: "#00D4FF"
                        font.bold: true
                    }
                }
            }
        }

        // Conversion Profiles Grid
        Text {
            text: "SUPPORTED CONVERSION PRESETS"
            font.pixelSize: 11
            font.bold: true
            color: "#8B93A1"
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Repeater {
                model: [
                    { title: "MP4 → MP3", type: "Audio Extraction", badge: "Transcode", color: "#7C5CFF", desc: "Extract pristine audio track (up to 320 kbps MP3)" },
                    { title: "MP4 → MOV", type: "Apple Ecosystem", badge: "Remux / Transcode", color: "#00D4FF", desc: "Stream copy or transcode for Final Cut Pro / Premiere" },
                    { title: "MOV → MP4", type: "Universal Web", badge: "Fast Remux", color: "#35D39A", desc: "Convert QuickTime masters into universal H.264 MP4" }
                ]

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 120
                    radius: 10
                    color: "#111318"
                    border.color: "#292E36"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: modelData.title
                                font.pixelSize: 15
                                font.bold: true
                                color: "#F5F7FA"
                            }
                            Item { Layout.fillWidth: true }
                            Rectangle {
                                implicitWidth: badgeTxt.implicitWidth + 12
                                implicitHeight: 20
                                radius: 4
                                color: "#181B22"
                                border.color: modelData.color
                                Text {
                                    id: badgeTxt
                                    anchors.centerIn: parent
                                    text: modelData.badge
                                    font.pixelSize: 10
                                    color: modelData.color
                                    font.bold: true
                                }
                            }
                        }

                        Text {
                            text: modelData.desc
                            font.pixelSize: 12
                            color: "#8B93A1"
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
