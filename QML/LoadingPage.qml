import QtQuick 2.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: background
    anchors.fill: parent
    color: Palette.backgroundGrey()
    opacity: 1

    Text {
        id: title
        text: "Fast cache"
        font.pointSize: 22
        anchors.horizontalCenter: parent.horizontalCenter
        color: Palette.greenSea()
        y: parent.height/3
    }
    Text {
        id: loading
        text: "Laoding..."
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 15
        color:  Palette.turquoise()
    }
    Behavior on opacity { PropertyAnimation { duration: 800 } }
}
