import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Rectangle {
    property int type
    property bool selected: false
    property bool favourite: false

    height: favourite ? searchRectangle.width / 5 : searchRectangle.width / 6
    width: height
    color: selected ? Palette.greenSea() : "#00000000"

    AnimatedSprite {
        id: cacheIconSprite
        paused: true
        x: parent.width * 0.05
        source: "qrc:/Image/cacheList.png"
        frameCount: 14
        currentFrame: type % 14
        width: parent.width * 0.9
        height: width
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: selected = !selected
    }
}
