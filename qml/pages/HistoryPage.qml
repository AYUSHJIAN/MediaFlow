import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: historyPage

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 28
        spacing: 20

        // Page Header
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text {
                    text: "OPERATION LOG"
                    font.pixelSize: 11
                    font.bold: true
                    color: "#FFB547"
                }
                Text {
                    text: "Media Ingestion & Conversion History"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#F5F7FA"
                }
                Text {
                    text: "Persistent SQLite operational records tracking source URLs, outputs, and timestamps."
                    font.pixelSize: 13
                    color: "#8B93A1"
                }
            }
            Item { Layout.fillWidth: true }

            Rectangle {
                implicitWidth: 100
                implicitHeight: 34
                radius: 6
                color: "#181B22"
                border.color: "#292E36"

                Text {
                    anchors.centerIn: parent
                    text: "Clear History"
                    font.pixelSize: 12
                    color: "#8B93A1"
                }
            }
        }

        // Table Header
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 40
            radius: 6
            color: "#111318"
            border.color: "#292E36"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                Text { text: "FILE NAME / TITLE"; Layout.preferredWidth: 3; Layout.fillWidth: true; font.pixelSize: 11; font.bold: true; color: "#8B93A1" }
                Text { text: "OPERATION"; Layout.preferredWidth: 1.5; Layout.fillWidth: true; font.pixelSize: 11; font.bold: true; color: "#8B93A1" }
                Text { text: "FORMAT"; Layout.preferredWidth: 1; Layout.fillWidth: true; font.pixelSize: 11; font.bold: true; color: "#8B93A1" }
                Text { text: "TIMESTAMP"; Layout.preferredWidth: 1.5; Layout.fillWidth: true; font.pixelSize: 11; font.bold: true; color: "#8B93A1" }
                Text { text: "STATUS"; Layout.preferredWidth: 1; Layout.fillWidth: true; font.pixelSize: 11; font.bold: true; color: "#8B93A1" }
            }
        }

        // History Content / Empty State Card
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                        text: "📜"
                        font.pixelSize: 24
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "No Media History Recorded"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#F5F7FA"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Completed downloads and conversions will be automatically logged to the SQLite database."
                    font.pixelSize: 12
                    color: "#8B93A1"
                }
            }
        }
    }
}
