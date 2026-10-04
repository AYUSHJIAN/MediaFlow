import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

PageContainer {
    id: historyPage

    SectionHeader {
        eyebrow: "OPERATION LOG"
        title: "Media activity"
        description: "History storage is not connected in this phase."
        accentColor: Theme.warning
    }

    Card {
        Layout.fillWidth: true
        implicitHeight: 42

        RowLayout {
            anchors.fill: parent
            spacing: Theme.spacingMd
            Text {
                Layout.fillWidth: true
                text: "FILE / TITLE"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontLabel
                font.weight: Theme.weightLabel
                elide: Text.ElideRight
            }
            Text {
                Layout.preferredWidth: historyPage.width < 900 ? 90 : 140
                text: "OPERATION"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontLabel
                font.weight: Theme.weightLabel
            }
            Text {
                visible: historyPage.width >= 900
                Layout.preferredWidth: 90
                text: "FORMAT"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontLabel
                font.weight: Theme.weightLabel
            }
            Text {
                visible: historyPage.width >= 900
                Layout.preferredWidth: 140
                text: "TIMESTAMP"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontLabel
                font.weight: Theme.weightLabel
            }
            Text {
                Layout.preferredWidth: 70
                text: "STATUS"
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontLabel
                font.weight: Theme.weightLabel
            }
        }
    }

    Card {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumHeight: 180

        EmptyState {
            anchors.centerIn: parent
            icon: "▤"
            title: "No activity yet"
            description: "Completed media tasks will be listed here when history storage is implemented."
        }
    }
}
