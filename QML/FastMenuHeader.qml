import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMenuHeader
    color: Palette.greenSea()
    width: parent.width
    height: parent.height * 0.08

    Image {
        source: "qrc:/Image/menuIcon.png"
        y: parent.height*0.1
        x: y
        height: parent.height*0.8
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: fastMenu.showMenu()
        }

    }
}
