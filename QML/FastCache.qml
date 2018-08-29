import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: fastList
    anchors.fill: parent
    opacity: main.viewState == "fullcache" ? 1 : 0
    visible: opacity > 0
    color: Palette.greenSea()

    Text {
        anchors.fill: parent
        font.family: localFont.name
        font.pointSize: 24
        text: fullCache.state == "loading" ? "Loading...." : fullCache.description

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
