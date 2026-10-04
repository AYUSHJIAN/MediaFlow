import QtQuick
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root

    property string eyebrow: ""
    property string title: ""
    property string description: ""
    property color accentColor: Theme.primary

    spacing: Theme.spacingXs
    Layout.fillWidth: true

    Text {
        visible: root.eyebrow.length > 0
        text: root.eyebrow
        color: root.accentColor
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontLabel
        font.weight: Theme.weightLabel
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    Text {
        visible: root.title.length > 0
        text: root.title
        color: Theme.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontPageTitle
        font.weight: Theme.weightPageTitle
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    Text {
        visible: root.description.length > 0
        text: root.description
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontBody
        font.weight: Theme.weightBody
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}
