import QtQuick

Item {

    property int type: 0
    property bool found: false
    property bool registered: false
    property bool toDoLog: false
    property bool own: false

    width: cacheIconBackground.width
    height: cacheIconBackground.height

    Image {
        id: cacheIconBackground
        source: "qrc:/Image/marker.png"
    }

    AnimatedSprite {
        id: cacheIconSprite
        running: false
        x: cacheIconBackground.width * 0.05
        source: "qrc:/Image/cacheList.png"
        frameCount: 15
        currentFrame: type
        width: cacheIconBackground.width * 0.9
        height: width
        anchors.centerIn: cacheIconBackground
    }

    Image {
        visible: found
        source: "qrc:/Image/marker_found.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }

    Image {
        visible: toDoLog
        source: "qrc:/Image/not_logged.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }

    Image {
        visible: own
        source: "qrc:/Image/marker_own.png"
        fillMode: Image.PreserveAspectFit
        width: parent.width / 2
        height: parent.height / 3
        x: 3 * parent.width / 5
        y: 3 * parent.height / 5
    }


    Image {
        visible: registered
        source: "qrc:/Image/marker_save.png"
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
