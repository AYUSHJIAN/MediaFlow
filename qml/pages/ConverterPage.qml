import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
import "../theme"

PageContainer {
    id: converterPage

    SectionHeader {
        eyebrow: "MEDIA CONVERTER"
        title: "Transcode, Remux & Extract Audio"
        description: "Conversion profiles are illustrative placeholders; no media processing is connected."
        accentColor: Theme.accent
    }

    FileDropZone {
        Layout.fillWidth: true
        zoneTitle: "Select a local media file"
        zoneDescription: "File browsing and drag-and-drop are reserved for a later phase."
    }

    Text {
        text: "PROFILE PREVIEWS"
        color: Theme.textMuted
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontLabel
        font.weight: Theme.weightLabel
    }

    GridLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: converterPage.width < 1120 ? 1 : 3
        columnSpacing: Theme.spacingMd
        rowSpacing: Theme.spacingMd

        Repeater {
            model: [
                { title: "MP4 to MP3", type: "Audio extraction", detail: "An example audio output profile." },
                { title: "MP4 to MOV", type: "Apple ecosystem", detail: "An example container and codec profile." },
                { title: "MOV to MP4", type: "Universal web", detail: "An example web delivery profile." }
            ]
            delegate: Card {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 115
                title: modelData.title
                subtitle: modelData.detail

                StatusBadge {
                    text: modelData.type
                    status: "neutral"
                }
            }
        }
    }
}
