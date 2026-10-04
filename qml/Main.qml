import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "pages"

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1160
    height: 760
    minimumWidth: 920
    minimumHeight: 640
    title: "MediaFlow — Professional Creator Workstation"
    color: "#08090C"

    // Application Navigation State
    property int currentNavIndex: 0

    readonly property var navItems: [
        { name: "Downloader", icon: "⬇️", subtitle: "Ingest Online Media" },
        { name: "Converter", icon: "🔄", subtitle: "Transcode & Remux" },
        { name: "History", icon: "📜", subtitle: "Activity Log" },
        { name: "Settings", icon: "⚙️", subtitle: "Preferences & Engines" }
    ]

    // Top Workstation Header Bar
    header: ToolBar {
        background: Rectangle {
            color: "#111318"
            border.color: "#292E36"
            border.width: 1

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#292E36"
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 16

            // Application Brand & Glyph
            RowLayout {
                spacing: 10
                Rectangle {
                    width: 30
                    height: 30
                    radius: 7
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#7C5CFF" }
                        GradientStop { position: 1.0; color: "#00D4FF" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "MF"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                Text {
                    text: "MediaFlow"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#F5F7FA"
                }

                Rectangle {
                    implicitWidth: studioTxt.implicitWidth + 10
                    implicitHeight: 18
                    radius: 4
                    color: "#181B22"
                    border.color: "#7C5CFF"
                    border.width: 1

                    Text {
                        id: studioTxt
                        anchors.centerIn: parent
                        text: "STUDIO"
                        font.pixelSize: 9
                        font.bold: true
                        color: "#7C5CFF"
                    }
                }
            }

            Rectangle {
                width: 1
                height: 20
                color: "#292E36"
                Layout.leftMargin: 4
                Layout.rightMargin: 4
            }

            // Current Active View Breadcrumb
            RowLayout {
                spacing: 6
                Text {
                    text: rootWindow.navItems[rootWindow.currentNavIndex].name.toUpperCase()
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    color: "#F5F7FA"
                }
                Text {
                    text: "• " + rootWindow.navItems[rootWindow.currentNavIndex].subtitle
                    font.pixelSize: 11
                    color: "#8B93A1"
                }
            }

            Item { Layout.fillWidth: true }

            // Phase Status Indicator Badge
            Rectangle {
                implicitWidth: badgeLayout.implicitWidth + 20
                implicitHeight: 28
                radius: 14
                color: "#181B22"
                border.color: "#7C5CFF"
                border.width: 1

                RowLayout {
                    id: badgeLayout
                    anchors.centerIn: parent
                    spacing: 6

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#35D39A"
                    }

                    Text {
                        text: "Phase 2: Shell Active"
                        color: "#F5F7FA"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                }
            }
        }
    }

    // Main Workstation Body: Sidebar Navigation + Content Area
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Navigation Sidebar
        Rectangle {
            id: sidebar
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            color: "#111318"
            border.color: "#292E36"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                spacing: 6

                // Section Label
                Text {
                    text: "WORKSTATION NAVIGATION"
                    font.pixelSize: 10
                    font.bold: true
                    color: "#8B93A1"
                    Layout.leftMargin: 18
                    Layout.topMargin: 8
                    Layout.bottomMargin: 8
                }

                // Navigation Items Repeater
                Repeater {
                    model: rootWindow.navItems

                    Rectangle {
                        id: navButton
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        implicitHeight: 44
                        radius: 8

                        readonly property bool isCurrent: rootWindow.currentNavIndex === index
                        readonly property bool isHovered: navMouseArea.containsMouse

                        color: isCurrent ? "#181B22" : (isHovered ? "#14171E" : "transparent")
                        border.color: isCurrent ? "#7C5CFF" : (isHovered ? "#292E36" : "transparent")
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            // Left selection indicator accent pill
                            Rectangle {
                                width: 3
                                height: 18
                                radius: 1.5
                                color: navButton.isCurrent ? "#7C5CFF" : "transparent"
                            }

                            Text {
                                text: modelData.icon
                                font.pixelSize: 14
                            }

                            Text {
                                text: modelData.name
                                font.pixelSize: 13
                                font.weight: navButton.isCurrent ? Font.DemiBold : Font.Normal
                                color: navButton.isCurrent ? "#F5F7FA" : "#8B93A1"
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            id: navMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                rootWindow.currentNavIndex = index
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                // Sidebar Footer: Creator Mode Badge
                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 14
                    Layout.rightMargin: 14
                    implicitHeight: 52
                    radius: 8
                    color: "#181B22"
                    border.color: "#292E36"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Rectangle {
                            width: 28
                            height: 28
                            radius: 14
                            color: "#08090C"
                            border.color: "#292E36"

                            Text {
                                anchors.centerIn: parent
                                text: "⚡"
                                font.pixelSize: 12
                            }
                        }

                        ColumnLayout {
                            spacing: 1
                            Text {
                                text: "Creator Mode"
                                font.pixelSize: 11
                                font.bold: true
                                color: "#F5F7FA"
                            }
                            Text {
                                text: "Local Media Processing"
                                font.pixelSize: 10
                                color: "#8B93A1"
                            }
                        }
                    }
                }
            }
        }

        // Central Multi-View Content Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#08090C"

            StackLayout {
                id: contentStack
                anchors.fill: parent
                currentIndex: rootWindow.currentNavIndex

                DownloaderPage {
                    id: downloaderView
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
            color: "#08090C"
            border.color: "#292E36"
            border.width: 1
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20

            Text {
                text: "PySide6 (Qt 6) • Hardware-Accelerated Qt Quick Engine • StackLayout Router"
                font.pixelSize: 11
                color: "#8B93A1"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Active View: " + rootWindow.navItems[rootWindow.currentNavIndex].name + " • MediaFlow v0.1.0"
                font.pixelSize: 11
                color: "#8B93A1"
            }
        }
    }
}
