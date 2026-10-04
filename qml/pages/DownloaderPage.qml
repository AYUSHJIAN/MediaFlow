import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

PageContainer {
    id: downloaderPage
    objectName: "downloaderPage"

    property var metadataBridge: null
    readonly property var emptyMetadata: ({
        title: "",
        uploader: "",
        platform: "",
        duration_text: "",
        thumbnail_url: "",
        webpage_url: "",
        width: 0,
        height: 0,
        fps: 0,
        video_available: false,
        audio_available: false,
        formats: [],
        qualities: [],
        video_qualities: [],
        audio_qualities: []
    })
    readonly property var mediaMetadata: metadataBridge ? metadataBridge.metadata : emptyMetadata
    signal fetchMediaRequested(string url)
    onFetchMediaRequested: function(url) {
        if (metadataBridge)
            metadataBridge.fetch_metadata(url)
    }

    SectionHeader {
        eyebrow: "MEDIA DOWNLOADER"
        title: "Download & Extract Online Media"
        description: "Inspect online media details and available formats without downloading."
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
                enabled: !downloaderPage.metadataBridge || !downloaderPage.metadataBridge.loading
                inputMethodHints: Qt.ImhUrlCharactersOnly
                onAccepted: fetchMediaButton.clicked()
            }

            PrimaryButton {
                id: fetchMediaButton
                objectName: "fetchMediaButton"
                Layout.alignment: Qt.AlignBottom
                text: "Fetch Media"
                icon: "↗"
                enabled: !downloaderPage.metadataBridge || !downloaderPage.metadataBridge.loading
                loading: downloaderPage.metadataBridge ? downloaderPage.metadataBridge.loading : false
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

            Item {
                anchors.fill: parent

                EmptyState {
                    objectName: "metadataEmptyState"
                    anchors.centerIn: parent
                    visible: !downloaderPage.metadataBridge
                        || (!downloaderPage.metadataBridge.loading
                            && !downloaderPage.metadataBridge.success
                            && !downloaderPage.metadataBridge.error)
                    icon: "▶"
                    title: "No Media Loaded"
                    description: "Paste a supported media link above to inspect its details and formats."
                }

                ColumnLayout {
                    objectName: "metadataLoadingState"
                    anchors.centerIn: parent
                    visible: downloaderPage.metadataBridge && downloaderPage.metadataBridge.loading
                    spacing: Theme.spacingSm

                    BusyIndicator {
                        Layout.alignment: Qt.AlignHCenter
                        running: downloaderPage.metadataBridge && downloaderPage.metadataBridge.loading
                        width: 38
                        height: 38
                    }
                    StatusBadge {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Reading media details"
                        status: "processing"
                    }
                }

                ColumnLayout {
                    objectName: "metadataErrorState"
                    anchors.centerIn: parent
                    width: Math.min(parent.width - Theme.spacingLg, 520)
                    visible: downloaderPage.metadataBridge && downloaderPage.metadataBridge.error
                    spacing: Theme.spacingSm

                    StatusBadge {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Metadata unavailable"
                        status: "error"
                    }
                    Text {
                        objectName: "metadataErrorMessage"
                        Layout.fillWidth: true
                        text: downloaderPage.metadataBridge ? downloaderPage.metadataBridge.error_message : ""
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontBody
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                }

                ScrollView {
                    id: resultScroll
                    objectName: "metadataResultState"
                    anchors.fill: parent
                    visible: downloaderPage.metadataBridge && downloaderPage.metadataBridge.success
                    clip: true
                    contentWidth: availableWidth

                    ColumnLayout {
                        width: resultScroll.availableWidth
                        spacing: Theme.spacingMd

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacingMd

                            Rectangle {
                                Layout.preferredWidth: 150
                                Layout.preferredHeight: 92
                                radius: Theme.radiusSm
                                color: Theme.surfaceSecondary
                                clip: true

                                Image {
                                    id: mediaThumbnail
                                    anchors.fill: parent
                                    source: downloaderPage.mediaMetadata.thumbnail_url
                                    asynchronous: true
                                    cache: true
                                    fillMode: Image.PreserveAspectCrop
                                }
                                Text {
                                    anchors.centerIn: parent
                                    visible: mediaThumbnail.status !== Image.Ready
                                    text: "MEDIA"
                                    color: Theme.textMuted
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontCaption
                                    font.weight: Theme.weightLabel
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Theme.spacingXs
                                Text {
                                    objectName: "metadataTitle"
                                    Layout.fillWidth: true
                                    text: downloaderPage.mediaMetadata.title
                                    color: Theme.textPrimary
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSectionHeading
                                    font.weight: Theme.weightSectionHeading
                                    wrapMode: Text.WordWrap
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: downloaderPage.mediaMetadata.uploader
                                    color: Theme.textMuted
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontBody
                                    wrapMode: Text.WordWrap
                                }
                                StatusBadge {
                                    text: downloaderPage.mediaMetadata.platform
                                    status: "neutral"
                                }
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: (downloaderPage.mediaMetadata.duration_text || "Unknown duration")
                                + "  ·  "
                                + (downloaderPage.mediaMetadata.height > 0
                                    ? downloaderPage.mediaMetadata.height + "p"
                                    : "Resolution not reported")
                                + (downloaderPage.mediaMetadata.fps > 0
                                    ? "  ·  " + downloaderPage.mediaMetadata.fps + " fps"
                                    : "")
                            color: Theme.textMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontMetadata
                            wrapMode: Text.WordWrap
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Theme.spacingSm
                            StatusBadge {
                                text: "Video " + (downloaderPage.mediaMetadata.video_available ? "available" : "unavailable")
                                status: downloaderPage.mediaMetadata.video_available ? "success" : "warning"
                            }
                            StatusBadge {
                                text: "Audio " + (downloaderPage.mediaMetadata.audio_available ? "available" : "unavailable")
                                status: downloaderPage.mediaMetadata.audio_available ? "success" : "warning"
                            }
                            StatusBadge {
                                text: downloaderPage.mediaMetadata.formats.length + " formats"
                                status: "neutral"
                            }
                        }

                        ColumnLayout {
                            visible: downloaderPage.mediaMetadata.video_qualities.length > 0
                            Layout.fillWidth: true
                            spacing: Theme.spacingXs
                            Text {
                                text: "VIDEO QUALITIES"
                                color: Theme.textMuted
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontLabel
                                font.weight: Theme.weightLabel
                            }
                            Flow {
                                Layout.fillWidth: true
                                spacing: Theme.spacingXs
                                Repeater {
                                    model: downloaderPage.mediaMetadata.video_qualities
                                    delegate: StatusBadge { text: modelData; status: "processing" }
                                }
                            }
                        }

                        ColumnLayout {
                            visible: downloaderPage.mediaMetadata.audio_qualities.length > 0
                            Layout.fillWidth: true
                            spacing: Theme.spacingXs
                            Text {
                                text: "AUDIO QUALITIES"
                                color: Theme.textMuted
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontLabel
                                font.weight: Theme.weightLabel
                            }
                            Flow {
                                Layout.fillWidth: true
                                spacing: Theme.spacingXs
                                Repeater {
                                    model: downloaderPage.mediaMetadata.audio_qualities
                                    delegate: StatusBadge { text: modelData; status: "neutral" }
                                }
                            }
                        }
                    }
                }
            }
        }

        Card {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 4
            Layout.minimumHeight: 190
            title: "Download options"
            subtitle: "Metadata inspection only; downloading is not part of this phase."

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
