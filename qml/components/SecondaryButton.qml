import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Button {
    id: root

    property string iconGlyph: ""

    implicitWidth: Math.max(contentItem.implicitWidth + Theme.spacingLg, 96)
    implicitHeight: 36
    Accessible.name: text

    contentItem: RowLayout {
        spacing: Theme.spacingSm
        Text {
            visible: root.iconGlyph.length > 0
            text: root.iconGlyph
            color: root.enabled ? Theme.textPrimary : Theme.textMuted
            font.pixelSize: Theme.fontButton
        }
        Text {
            text: root.text
            color: root.enabled ? Theme.textPrimary : Theme.textMuted
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontButton
            font.weight: Theme.weightButton
        }
    }

    background: Rectangle {
        radius: Theme.radiusSm
        color: !root.enabled ? Theme.surface : (root.down ? Theme.surfaceActive : (root.hovered ? Theme.surfaceHover : Theme.surfaceSecondary))
        border.color: root.activeFocus ? Theme.accent : (root.hovered ? Theme.borderHover : Theme.border)
        border.width: root.activeFocus ? 2 : 1
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }
    }
}
