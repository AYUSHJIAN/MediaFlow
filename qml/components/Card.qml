import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: cardRoot

    property string title: ""
    property string subtitle: ""
    property int cardPadding: Theme.spacingMd
    property bool hoverable: false
    property bool active: false
    property color accentBorder: Theme.border
    property alias isHovered: cardMouseArea.containsMouse

    default property alias content: contentContainer.data

    color: active ? Theme.surfaceActive : (hoverable && cardMouseArea.containsMouse ? Theme.surfaceHover : Theme.surface)
    border.color: active ? Theme.borderFocus : (hoverable && cardMouseArea.containsMouse ? Theme.borderHover : accentBorder)
    border.width: 1
    radius: Theme.radiusLg
    clip: true

    Behavior on color { ColorAnimation { duration: Theme.animFast } }
    Behavior on border.color { ColorAnimation { duration: Theme.animFast } }

    ColumnLayout {
        id: internalLayout
        anchors.fill: parent
        anchors.margins: cardRoot.cardPadding
        spacing: Theme.spacingSm

        // Optional Card Header
        RowLayout {
            Layout.fillWidth: true
            visible: cardRoot.title.length > 0
            spacing: Theme.spacingSm

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingXs

                Text {
                    text: cardRoot.title
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSectionHeading
                    font.weight: Theme.weightSectionHeading
                    color: Theme.textPrimary
                    visible: cardRoot.title.length > 0
                }

                Text {
                    text: cardRoot.subtitle
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSecondaryText
                    color: Theme.textMuted
                    visible: cardRoot.subtitle.length > 0
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }
        }

        // Divider when header is present
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.borderSubtle
            visible: cardRoot.title.length > 0
        }

        // Inner Item hosting child content
        Item {
            id: contentContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    MouseArea {
        id: cardMouseArea
        anchors.fill: parent
        enabled: cardRoot.hoverable
        hoverEnabled: cardRoot.hoverable
        cursorShape: cardRoot.hoverable ? Qt.PointingHandCursor : Qt.ArrowCursor
        z: -1 // allow internal controls to receive pointer events
    }
}
