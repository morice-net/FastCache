import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: selectableIcon
    property int type
    property bool selected

    height: searchRectangle.width /7
    width: height
    radius: 15
    border.width:1
    border.color: Palette.black()
    color: selected ? Palette.greenSea() : "#00000000"

    AnimatedSprite {
        id: cacheIconSprite
        paused: true
        x: parent.width * 0.05
        source: "qrc:/Image/cacheList.png"
        frameCount: 15
        currentFrame: type % 15
        width: parent.width * 0.9
        height: width
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            selected = !selected
            settingsFilterType.filterTypes[index] = selected
        }
    }

}
