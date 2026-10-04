import QtQuick
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root

    property string status: "neutral"
    property string text: ""
    readonly property color statusColor: {
        if (status === "success") return Theme.success
        if (status === "warning") return Theme.warning
        if (status === "error") return Theme.error
        if (status === "processing") return Theme.accent
        return Theme.textMuted
    }
    readonly property string statusSymbol: {
        if (status === "success") return "✓"
        if (status === "warning") return "!"
        if (status === "error") return "×"
        if (status === "processing") return "…"
        return "•"
    }

    implicitWidth: badgeLayout.implicitWidth + Theme.spacingMd
    implicitHeight: 28
    radius: Theme.radiusPill
    color: Theme.surfaceSecondary
    border.color: statusColor
    border.width: 1
    Accessible.name: text.length > 0 ? text + ", " + status : status

    RowLayout {
        id: badgeLayout
        anchors.centerIn: parent
        spacing: Theme.spacingXs
        Text {
            text: root.statusSymbol
            color: root.statusColor
            font.pixelSize: Theme.fontStatus
            font.weight: Theme.weightBold
        }
        Text {
            text: root.text
            visible: root.text.length > 0
            color: Theme.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontStatus
            font.weight: Theme.weightStatus
        }
    }
}
