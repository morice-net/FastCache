import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Button {
    id:button

    property string source
    property int sourceWidth: 20
    property int sourceHeight: 20
    property int buttonRadius: 6

    background: Rectangle {
        border.width: button.activeFocus ? 2 : 1
        border.color: Palette.silver()
        color: Palette.white()
        radius: buttonRadius
        width: image.sourceSize.width + 1
        height: image.sourceSize.height + 1

        Image {
            id: image
            source: button.source
            sourceSize.width: button.sourceWidth
            sourceSize.height: button.sourceHeight
            anchors.centerIn: parent
            anchors.fill: parent
        }
    }
}

