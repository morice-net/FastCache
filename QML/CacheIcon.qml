import QtQuick

Item {

    property int type: 0
    property bool found: false
    property bool registered: false
    property bool toDoLog: false
    property bool own: false
    property bool isLabCache: false

    width: cacheIconBackground.width
    height: cacheIconBackground.height

    Image {
        id: cacheIconBackground
        source: "../Image/marker.png"
    }

    AnimatedSprite {
        id: cacheIconSprite
        visible: !isLabCache
        running: false
        x: cacheIconBackground.width * 0.05
        source: "../Image/cacheList.png"
        frameCount: 15
        currentFrame: type
        width: cacheIconBackground.width * 0.9
        height: width
        anchors.centerIn: cacheIconBackground
    }

    Image {
        id: labCache
        visible: isLabCache
        x: cacheIconBackground.width * 0.05
        source: "../Image/labCache.png"
        width: cacheIconBackground.width * 0.65
        height: width
        anchors.centerIn: cacheIconBackground
    }

    Image {
        visible: found
        source: "../Image/marker_found.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }

    Image {
        visible: toDoLog
        source: "../Image/not_logged.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }

    Image {
        visible: own
        source: "../Image/marker_own.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }


    Image {
        visible: registered
        source: "../Image/marker_save.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 1.2
        height: parent.height / 2.2
        x: -1*parent.height / 8
        y: parent.height / 8
    }

    MouseArea {
        anchors.fill: cacheIconBackground
    }
}
