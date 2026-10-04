import QtQuick
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root

    property string icon: "•"
    property string title: "Nothing here yet"
    property string description: ""

    spacing: Theme.spacingSm
    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
    Layout.maximumWidth: 520

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: root.icon
        color: Theme.accent
        font.pixelSize: Theme.fontSizeDisplay
        Accessible.name: root.title
    }
    Text {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: root.title
        color: Theme.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSectionHeading
        font.weight: Theme.weightSectionHeading
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
    Text {
        visible: root.description.length > 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: root.description
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSecondaryText
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
}
