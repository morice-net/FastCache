import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Button {
    id:button
    contentItem: Text {
        text: button.text
        font.family: localFont.name
        font.pointSize: button.font.pixelSize
        color: Palette.greenSea()
        opacity: button.opacity
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        border.width: button.activeFocus ? 2 : 1
        border.color: button.down ? Palette.silver() : Palette.white()
        color: Palette.white()
        radius: 6
    }
}
