import QtQuick 2.6

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: rect

    property real margin: 10

    visible: false
    x:20
    y:main.height*0.7
    height: message.height + margin
    width: main.width*0.5
    radius: margin
    color:Palette.white()

    Text {
        id: message
        font.pointSize: 14
        font.family: localFont.name
        color: Palette.greenSea()
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignLeft
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: margin / 2
        }
    }

    Timer {
        id:toastTimer
        interval: 9000
        running: true
        repeat: false
        onTriggered: rect.visible = false
    }

    function show(text) {
        message.text = text;
        toastTimer.start()
    }
}
