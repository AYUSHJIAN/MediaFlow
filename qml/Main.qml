import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "components"
import "pages"
import "theme"

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1160
    height: 760
    minimumWidth: 760
    minimumHeight: 560
    title: "MediaFlow - Professional Creator Workspace"
    color: Theme.background

    // Application Navigation State
    property int currentNavIndex: 0
    readonly property bool compactLayout: width < 960

    readonly property var navItems: [
        { name: "Downloader", icon: "⬇️", subtitle: "Ingest Online Media" },
        { name: "Converter", icon: "🔄", subtitle: "Transcode & Remux" },
        { name: "History", icon: "📜", subtitle: "Activity Log" },
        { name: "Settings", icon: "⚙️", subtitle: "Preferences & Engines" }
    ]

    header: TopBar {
        pageName: rootWindow.navItems[rootWindow.currentNavIndex].name
        pageSubtitle: rootWindow.navItems[rootWindow.currentNavIndex].subtitle
        compact: rootWindow.compactLayout
        padding: Theme.spacingMd
    }

    // Main Workstation Body: Sidebar Navigation + Content Area
    RowLayout {
        anchors.fill: parent
        spacing: 0

        AppSidebar {
            id: appSidebar
            objectName: "appSidebar"
            items: rootWindow.navItems
            currentIndex: rootWindow.currentNavIndex
            compact: rootWindow.compactLayout
            onNavigate: index => rootWindow.currentNavIndex = index
        }

        // Central Multi-View Content Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.background

            StackLayout {
                id: contentStack
                anchors.fill: parent
                currentIndex: rootWindow.currentNavIndex

                DownloaderPage {
                    id: downloaderView
                    metadataBridge: typeof metadataController === "undefined" ? null : metadataController
                }

                ConverterPage {
                    id: converterView
                }

                HistoryPage {
                    id: historyView
                }

                SettingsPage {
                    id: settingsView
                }
            }
        }
    }

    // Workstation Footer Status Bar
    footer: ToolBar {
        background: Rectangle {
            color: Theme.background
            border.color: Theme.border
            border.width: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20

            Text {
                text: "Qt Quick • Python services remain separate from the UI"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontMetadata
                color: Theme.textMuted
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: "Active View: " + rootWindow.navItems[rootWindow.currentNavIndex].name + " • MediaFlow v0.1.0"
                visible: !rootWindow.compactLayout
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontMetadata
                color: Theme.textMuted
            }
        }
    }
}
