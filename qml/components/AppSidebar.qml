import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root

    property var items: []
    property int currentIndex: 0
    property bool compact: false
    property int hoveredIndex: -1
    signal navigate(int index)

    implicitWidth: compact ? 72 : 216
    Layout.preferredWidth: implicitWidth
    Layout.minimumWidth: implicitWidth
    Layout.fillHeight: true
    color: Theme.surface
    border.color: Theme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: Theme.spacingMd
        anchors.bottomMargin: Theme.spacingMd
        spacing: Theme.spacingSm

        Text {
            visible: !root.compact
            text: "WORKSPACE"
            color: Theme.textMuted
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontCaption
            font.weight: Theme.weightLabel
            Layout.leftMargin: Theme.spacingMd
            Layout.bottomMargin: Theme.spacingXs
        }

        Repeater {
            model: root.items
            delegate: Button {
                id: navButton
                required property int index
                required property var modelData
                property bool selected: root.currentIndex === index

                objectName: "navButton_" + index
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSm
                Layout.rightMargin: Theme.spacingSm
                implicitHeight: 44
                text: modelData.name
                Accessible.name: modelData.name
                Accessible.description: modelData.subtitle
                onClicked: root.navigate(index)
                onHoveredChanged: root.hoveredIndex = hovered ? index : -1

                contentItem: RowLayout {
                    spacing: Theme.spacingSm
                    Text {
                        text: navButton.modelData.icon
                        font.pixelSize: Theme.fontBody
                        Layout.preferredWidth: 22
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        visible: !root.compact
                        text: navButton.modelData.name
                        color: navButton.selected ? Theme.textPrimary : Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        font.weight: navButton.selected ? Theme.weightSectionHeading : Theme.weightBody
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                background: Rectangle {
                    radius: Theme.radiusMd
                    color: navButton.selected ? Theme.surfaceSecondary : (navButton.hovered ? Theme.surfaceHover : "transparent")
                    border.color: navButton.activeFocus ? Theme.accent : (navButton.selected ? Theme.primary : (navButton.hovered ? Theme.border : "transparent"))
                    border.width: navButton.activeFocus || navButton.selected ? 1 : 0
                    Behavior on color { ColorAnimation { duration: Theme.animFast } }
                    Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.spacingXs
                        anchors.verticalCenter: parent.verticalCenter
                        width: 3
                        height: 18
                        radius: 2
                        color: navButton.selected ? Theme.primary : "transparent"
                    }
                }

                ToolTip.visible: root.compact && hovered
                ToolTip.text: modelData.name
                ToolTip.delay: 400
            }
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.spacingSm
            Layout.rightMargin: Theme.spacingSm
            implicitHeight: root.compact ? 44 : 56
            radius: Theme.radiusMd
            color: Theme.surfaceSecondary
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacingSm
                spacing: Theme.spacingSm
                Text {
                    text: "⚡"
                    font.pixelSize: Theme.fontBody
                }
                ColumnLayout {
                    visible: !root.compact
                    spacing: 0
                    Text {
                        text: "Creator Mode"
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontLabel
                        font.weight: Theme.weightLabel
                    }
                    Text {
                        text: "Local workspace"
                        color: Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontCaption
                    }
                }
            }
        }
    }
}
