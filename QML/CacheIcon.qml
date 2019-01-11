import QtQuick 2.6

Item {

    property int type: 0

    width: cacheIconBackground.width
    height: cacheIconBackground.height

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

    Image {
        source: "qrc:/Image/marker_found.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }

    MouseArea {
        anchors.fill: cacheIconBackground
    }
}
