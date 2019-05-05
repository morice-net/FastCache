import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id:loadingPage

    Rectangle {
        x:10
        width:main.width*0.9
        height: main.height*0.9
        color: Palette.greenSea()
        border.color: Palette.black()
        border.width: 1
        radius:10
        visible: sendCacheNote.state === "loading" ||sendCacheLog.state === "loading" || fullCache.state === "loading"

        Text {
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 20
            text: "Loading....\n\n\n"
            color: Palette.white()

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: sendCacheNote.state === "loading" ||sendCacheLog.state === "loading" || fullCache.state === "loading"
        }
    }
}
