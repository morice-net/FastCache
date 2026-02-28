import QtQuick

import "JavaScript/Palette.js" as Palette

Rectangle {
    id : cursorRect
    width: 2
    color: Palette.turquoise()
    opacity: parent.focus ? 1 : 0

    SequentialAnimation on opacity {
        running: parent.focus
        loops: Animation.Infinite

        NumberAnimation { from: 1; to: 0; duration: 600 }
        NumberAnimation { from: 0; to: 1; duration: 600 }
    }
}








