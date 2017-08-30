import QtQuick 2.3

Item {

    property int type: 0
    Image {
        id: cacheIconBackground
        source: "qrc:/Image/marker.png"
    }

    AnimatedSprite {
        id: cacheIconSprite
        paused: true
        x: cacheIconBackground.width * 0.05
        source: "qrc:/Image/cacheList.png"
        frameCount: 14
        currentFrame: type % 14
        width: cacheIconBackground.width * 0.9
        height: width

    }

    MouseArea {
        anchors.fill: cacheIconBackground
        onClicked: type++
    }

}
