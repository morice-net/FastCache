import QtQuick 2.6

Item {

    property int type: 0
    Image {
        id: cacheIconBackground
        source: "qrc:/Image/marker.png"
        width: sourceSize.width * 1.8
        height: sourceSize.height * 1.8
    }

    AnimatedSprite {
        id: cacheIconSprite
        paused: true
        x: cacheIconBackground.width * 0.05
        source: "qrc:/Image/cacheList.png"
        frameCount: 15
        currentFrame: type % 15
        width: cacheIconBackground.width * 0.9
        height: width
        anchors.centerIn: cacheIconBackground

    }

    MouseArea {
        anchors.fill: cacheIconBackground
    }
}
