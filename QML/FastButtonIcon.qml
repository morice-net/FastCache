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
        implicitWidth: image.sourceSize.width + 5
        implicitHeight: image.sourceSize.height + 5

        Image {
            id:image
            source: button.source
            sourceSize.width: button.sourceWidth
            sourceSize.height: button.sourceHeight
            anchors.centerIn: parent
        }
    }
}

