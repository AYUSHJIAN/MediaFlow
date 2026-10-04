import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme"

Item {
    id: btnRoot

    property string text: ""
    property string icon: ""
    property bool loading: false
    property string variant: "primary" // "primary", "accent", "success"

    signal clicked()

    implicitWidth: Math.max(buttonLayout.implicitWidth + Theme.spacingLg, 100)
    implicitHeight: 38

    activeFocusOnTab: enabled && !loading
    Accessible.role: Accessible.Button
    Accessible.name: text

    Keys.onReturnPressed: if (enabled && !loading) btnRoot.clicked()
    Keys.onSpacePressed: if (enabled && !loading) btnRoot.clicked()

    // Determine base and hover colors based on variant
    readonly property color baseColor: {
        if (variant === "accent") return Theme.accent
        if (variant === "success") return Theme.success
        return Theme.primary
    }

    readonly property color hoverColor: {
        if (variant === "accent") return Theme.accentHover
        if (variant === "success") return Theme.successHover
        return Theme.primaryHover
    }

    readonly property color pressedColor: {
        if (variant === "accent") return Theme.accentPressed
        if (variant === "success") return Theme.successPressed
        return Theme.primaryPressed
    }

    // Outer Focus Ring (Accessibility)
    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: Theme.radiusSm + 3
        color: "transparent"
        border.color: Theme.accent
        border.width: 2
        visible: btnRoot.activeFocus
    }

    // Main Button Body
    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: Theme.radiusSm
        scale: mouseArea.pressed && btnRoot.enabled && !btnRoot.loading ? 0.98 : 1.0

        color: {
            if (!btnRoot.enabled) return Theme.surfaceHover
            if (mouseArea.pressed) return btnRoot.pressedColor
            if (mouseArea.containsMouse) return btnRoot.hoverColor
            return btnRoot.baseColor
        }

        opacity: btnRoot.enabled ? 1.0 : 0.45

        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on scale { NumberAnimation { duration: 80 } }

        RowLayout {
            id: buttonLayout
            anchors.centerIn: parent
            spacing: Theme.spacingSm

            // Loading Spinner / Indicator
            Rectangle {
                visible: btnRoot.loading
                width: 14
                height: 14
                radius: 7
                color: "transparent"
                border.color: Theme.textOnPrimary
                border.width: 2

                RotationAnimation on rotation {
                    running: btnRoot.loading
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 900
                }
            }

            // Leading Glyph/Icon
            Text {
                visible: btnRoot.icon.length > 0 && !btnRoot.loading
                text: btnRoot.icon
                font.pixelSize: Theme.fontButton
                color: Theme.textOnPrimary
            }

            // Button Label Text
            Text {
                text: btnRoot.loading ? "Processing..." : btnRoot.text
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontButton
                font.weight: Theme.weightBold
                color: btnRoot.enabled ? Theme.textOnPrimary : Theme.textMuted
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: btnRoot.enabled && !btnRoot.loading
            cursorShape: (btnRoot.enabled && !btnRoot.loading) ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                if (btnRoot.enabled && !btnRoot.loading) {
                    btnRoot.forceActiveFocus()
                    btnRoot.clicked()
                }
            }
        }
    }
}
