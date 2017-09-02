import QtQuick 2.3

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
        frameCount: 14
        currentFrame: type % 14
        width: cacheIconBackground.width * 0.9
        height: width
        anchors.centerIn: cacheIconBackground

    }

    MouseArea {
        anchors.fill: cacheIconBackground
        z: 100
        onClicked: type++
    }

}
