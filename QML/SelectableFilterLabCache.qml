import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

CheckBox {
    id: control
    checked: settings.labCache
    font.family: localFont.name
    font.pointSize: 18
    onClicked: {
        settings.labCache = control.checked
    }
    indicator: Rectangle {
        implicitWidth: main.width / 10
        implicitHeight: width
        opacity: 0.8
        radius: 8
        border.color: Palette.black()
        border.width: 2

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: control.down ? Palette.backgroundGrey():Palette.greenSea()
            visible: control.checked
        }

        Image {
            id: cacheIcon
            anchors.fill: parent
            anchors.margins: 5
            source: "../Image/labCache.png"
        }
    }
    contentItem:  Text {
        text: control.text
        color: Palette.greenSea()
        font.family: control.font.family
        font.pointSize: control.font.pointSize
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}

