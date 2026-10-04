import QtQuick
import QtQuick.Layouts
import "../theme"

ColumnLayout {
    id: root

    property string label: ""
    property bool invalid: false
    property string placeholderText: ""
    property alias text: field.text
    property alias inputMethodHints: field.inputMethodHints
    signal accepted(string value)

    spacing: Theme.spacingXs
    Layout.fillWidth: true

    Text {
        visible: root.label.length > 0
        text: root.label
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontLabel
        font.weight: Theme.weightLabel
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 40
        radius: Theme.radiusSm
        color: Theme.surfaceSecondary
        border.color: root.invalid ? Theme.error : (field.activeFocus ? Theme.accent : Theme.border)
        border.width: field.activeFocus || root.invalid ? 2 : 1
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

        TextInput {
            id: field
            anchors.fill: parent
            anchors.leftMargin: Theme.spacingMd
            anchors.rightMargin: Theme.spacingMd
            verticalAlignment: TextInput.AlignVCenter
            color: Theme.textPrimary
            selectionColor: Theme.primary
            selectedTextColor: Theme.textOnPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            activeFocusOnTab: true
            Accessible.name: root.label.length > 0 ? root.label : root.placeholderText
            inputMethodHints: Qt.ImhNone
            onAccepted: root.accepted(text)
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingMd
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingMd
            anchors.verticalCenter: parent.verticalCenter
            visible: field.text.length === 0 && !field.activeFocus
            text: root.placeholderText
            color: Theme.textMuted
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            elide: Text.ElideRight
        }
    }
}
