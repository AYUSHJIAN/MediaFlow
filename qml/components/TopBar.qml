import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"
import "."

ToolBar {
    id: root

    property string pageName: "Downloader"
    property string pageSubtitle: "Professional creator media workspace"
    property bool compact: false

    implicitHeight: 62
    background: Rectangle {
        color: Theme.surface
        border.color: Theme.border
        border.width: 1
    }

    contentItem: RowLayout {
        spacing: Theme.spacingMd

        RowLayout {
            spacing: Theme.spacingSm
            Rectangle {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                radius: Theme.radiusSm
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.primary }
                    GradientStop { position: 1.0; color: Theme.accent }
                }
                Text {
                    anchors.centerIn: parent
                    text: "MF"
                    color: Theme.textOnPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontLabel
                    font.weight: Theme.weightBold
                }
            }
            Text {
                text: "MediaFlow"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontApplicationTitle
                font.weight: Theme.weightApplicationTitle
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 24
            color: Theme.border
        }

        ColumnLayout {
            spacing: 0
            Text {
                text: root.pageName.toUpperCase()
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontLabel
                font.weight: Theme.weightLabel
            }
            Text {
                visible: !root.compact
                text: root.pageSubtitle
                color: Theme.textMuted
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSecondaryText
                elide: Text.ElideRight
            }
        }

        Item { Layout.fillWidth: true }

        StatusBadge {
            visible: !root.compact
            text: "Phase 3 UI"
            status: "success"
        }
    }
}
