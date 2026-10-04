import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

PageContainer {
    id: downloaderPage
    objectName: "downloaderPage"

    signal fetchMediaRequested(string url)

    SectionHeader {
        eyebrow: "MEDIA DOWNLOADER"
        title: "Download & Extract Online Media"
        description: "Paste a media link to begin. Media lookup is not connected in this UI phase."
    }

    Card {
        Layout.fillWidth: true
        implicitHeight: inputLayout.implicitHeight + Theme.spacingLg * 2

        RowLayout {
            id: inputLayout
            anchors.fill: parent
            anchors.margins: Theme.spacingMd
            spacing: Theme.spacingMd

            TextInputField {
                id: mediaUrlField
                objectName: "mediaUrlField"
                Layout.fillWidth: true
                label: "Media URL"
                placeholderText: "Paste a media link"
                inputMethodHints: Qt.ImhUrlCharactersOnly
                onAccepted: fetchMediaButton.clicked()
            }

            PrimaryButton {
                id: fetchMediaButton
                objectName: "fetchMediaButton"
                Layout.alignment: Qt.AlignBottom
                text: "Fetch Media"
                icon: "↗"
                onClicked: downloaderPage.fetchMediaRequested(mediaUrlField.text)
            }
        }
    }

    GridLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: downloaderPage.width < 1040 ? 1 : 2
        columnSpacing: Theme.spacingMd
        rowSpacing: Theme.spacingMd

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 6
            Layout.minimumHeight: 190

            EmptyState {
                anchors.centerIn: parent
                icon: "▶"
                title: "No Media Loaded"
                description: "Media details and stream choices will appear here after a future metadata phase."
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 4
            Layout.minimumHeight: 190
            title: "Download options"
            subtitle: "Preview only; download services are not connected."

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacingSm

                Repeater {
                    model: [
                        { title: "Format", detail: "MP4 video / MP3 audio" },
                        { title: "Quality", detail: "Preference selection planned" },
                        { title: "Destination", detail: "./downloads/" },
                        { title: "Filename", detail: "Automatic naming planned" }
                    ]
                    delegate: RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacingSm
                        Text {
                            text: "•"
                            color: Theme.primary
                            font.pixelSize: Theme.fontBody
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacingXs
                            Text {
                                text: modelData.title
                                color: Theme.textPrimary
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontBody
                                font.weight: Theme.weightSectionHeading
                            }
                            Text {
                                text: modelData.detail
                                color: Theme.textMuted
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontMetadata
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
                StatusBadge {
                    text: "Awaiting media link"
                    status: "neutral"
                }
            }
        }
    }
}
