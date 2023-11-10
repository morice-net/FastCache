import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "JavaScript/Palette.js" as Palette

CheckBox {
    id: control
    Layout.alignment: Qt.AlignLeft
    Layout.preferredHeight: 28
    contentItem: Text {
        text: control.text
        font.family: localFont.name
        font.pointSize: 16
        color: Palette.greenSea()
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control .spacing + 10
    }
    indicator: Rectangle {
        implicitWidth: 22
        implicitHeight: 22
        radius: 3
        border.width: 1
        x: 10
        y: parent.height / 2 - height / 2

        Rectangle {
            anchors.fill: parent
            visible: control.checked
            color: Palette.greenSea()
            radius: 3
            anchors.margins: 4
        }
    }
}
