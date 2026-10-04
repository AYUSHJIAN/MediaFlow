import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Card {
    id: root

    property string zoneTitle: "Drop media files here"
    property string zoneDescription: "File selection is a UI placeholder in this phase."
    signal browseRequested()

    implicitHeight: contentLayout.implicitHeight + Theme.spacingXl * 2
    border.color: browseButton.hovered ? Theme.accent : Theme.border
    Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

    ColumnLayout {
        id: contentLayout
        anchors.centerIn: parent
        width: Math.min(parent.width - Theme.spacingXl * 2, 560)
        spacing: Theme.spacingSm

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "▧"
            color: Theme.accent
            font.pixelSize: Theme.iconDisplay
        }
        Text {
            Layout.fillWidth: true
            text: root.zoneTitle
            color: Theme.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSectionHeading
            font.weight: Theme.weightSectionHeading
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        Text {
            Layout.fillWidth: true
            text: root.zoneDescription
            color: Theme.textMuted
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSecondaryText
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        SecondaryButton {
            id: browseButton
            Layout.alignment: Qt.AlignHCenter
            text: "Browse Files"
            iconGlyph: "＋"
            onClicked: root.browseRequested()
        }
    }
}
