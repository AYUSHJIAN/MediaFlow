import QtQuick
import QtQuick.Layouts
import "../theme"

Item {
    id: root

    property int pagePadding: width < 900 ? Theme.spacingMd : Theme.spacingXl
    property int sectionSpacing: Theme.spacingLg
    default property alias content: pageLayout.data

    implicitWidth: 520
    implicitHeight: 420

    ColumnLayout {
        id: pageLayout
        anchors.fill: parent
        anchors.margins: root.pagePadding
        spacing: root.sectionSpacing
    }
}
