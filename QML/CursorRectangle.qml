import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Rectangle {
    id : cursorRect
    property alias running: timer.running

    width: 2
    color: Palette.turquoise()

    Timer{
        id: timer
        interval: 500
        repeat: true
        onRunningChanged: cursorRect.visible = running
        onTriggered: cursorRect.visible = !cursorRect.visible
    }
}
