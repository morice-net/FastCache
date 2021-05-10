import QtQuick 2.6

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: rect

    property real margin: 10

    visible: false
    anchors.horizontalCenter: parent.horizontalCenter
    y:main.height*0.7
    z: 4
    height: message.height + margin
    width: main.width*0.8
    radius: margin
    color:Palette.black()

    Text {
        id: message
        font.pointSize: 16
        font.family: localFont.name
        color: Palette.greenSea()
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: margin / 2
        }
    }

    Timer {
        id:toastTimer
        interval: 8000
        running: true
        repeat: false
        onTriggered: rect.visible = false
    }

    function show(text) {
        message.text = text;
        toastTimer.start()
    }
}
