import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

Item {
    id: settingsPage

    ScrollView {
        id: settingsScroll
        anchors.fill: parent
        anchors.margins: Theme.spacingXl
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            id: settingsCol
            width: settingsScroll.availableWidth
            spacing: Theme.spacingLg

            SectionHeader {
                eyebrow: "CONFIGURATION"
                title: "Workspace settings"
                description: "Settings shown here are examples and are not persisted in this phase."
                accentColor: Theme.success
            }

            Card {
                Layout.fillWidth: true
                implicitHeight: storageLayout.implicitHeight + Theme.spacingXl
                title: "Storage & paths"
                subtitle: "Example locations for a future settings service."

                GridLayout {
                    id: storageLayout
                    anchors.fill: parent
                    columns: settingsPage.width < 960 ? 1 : 2
                    columnSpacing: Theme.spacingLg
                    rowSpacing: Theme.spacingMd

                    ColumnLayout {
                        Layout.fillWidth: true
                        Text { text: "Default download directory"; color: Theme.textPrimary; font.family: Theme.fontFamily; font.pixelSize: Theme.fontBody; font.weight: Theme.weightSectionHeading; wrapMode: Text.WordWrap }
                        Text { text: "./downloads"; color: Theme.accent; font.family: Theme.fontFamily; font.pixelSize: Theme.fontMetadata }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Text { text: "Temporary workspace"; color: Theme.textPrimary; font.family: Theme.fontFamily; font.pixelSize: Theme.fontBody; font.weight: Theme.weightSectionHeading; wrapMode: Text.WordWrap }
                        Text { text: "./temp"; color: Theme.textMuted; font.family: Theme.fontFamily; font.pixelSize: Theme.fontMetadata }
                    }
                }
            }

            Card {
                Layout.fillWidth: true
                implicitHeight: engineLayout.implicitHeight + Theme.spacingXl
                title: "Media engine"
                subtitle: "No external processing engine is configured by this UI."

                RowLayout {
                    id: engineLayout
                    anchors.fill: parent
                    spacing: Theme.spacingMd
                    Text {
                        Layout.fillWidth: true
                        text: "FFmpeg discovery and custom binary settings belong to a later phase."
                        color: Theme.textMuted
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        wrapMode: Text.WordWrap
                    }
                    StatusBadge { text: "Placeholder"; status: "warning" }
                }
            }

            Card {
                Layout.fillWidth: true
                implicitHeight: aboutLayout.implicitHeight + Theme.spacingXl
                title: "About MediaFlow"

                GridLayout {
                    id: aboutLayout
                    anchors.fill: parent
                    columns: settingsPage.width < 960 ? 2 : 4
                    columnSpacing: Theme.spacingLg
                    rowSpacing: Theme.spacingMd

                    Repeater {
                        model: [
                            { label: "Application", value: "MediaFlow Desktop" },
                            { label: "Version", value: "0.1.0-alpha" },
                            { label: "UI engine", value: "Qt Quick / QML" },
                            { label: "Runtime", value: "Python & PySide6" }
                        ]
                        delegate: ColumnLayout {
                            Layout.fillWidth: true
                            Text {
                                text: modelData.label
                                color: Theme.textMuted
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontMetadata
                            }
                            Text {
                                Layout.fillWidth: true
                                text: modelData.value
                                color: Theme.textPrimary
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontBody
                                font.weight: Theme.weightSectionHeading
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
