import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Button {

    property string buttonText

    contentItem: Text {
        id: content
        text: buttonText
        font.family: localFont.name
        font.pointSize: 20
        color: Palette.white()
    }
    background: Rectangle {
        anchors.fill: parent
        color: Palette.greenSea()
        border.color: Palette.white()
        border.width: 1
        radius: 5
    }
}
