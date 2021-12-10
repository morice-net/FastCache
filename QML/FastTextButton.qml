import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Button {
    id: control

    property string buttonText

    contentItem: Text {
        id: content
        text: buttonText
        font.family: localFont.name
        font.pointSize: 20
        color: control.down ? Palette.silver() : Palette.white()
    }
    background: Rectangle {
        anchors.fill: parent
        color: Palette.greenSea()
        border.color: control.down ? Palette.silver() : Palette.white()
        border.width: 2
        radius: 5
    }
}
