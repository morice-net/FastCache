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
        id: descriptionText
        anchors.fill: parent
        font.family: localFont.name
        font.pointSize: 20
        text: fullCache.state == "loading" ? "Loading....\n\n\n" : fullCache.description
        color: Palette.white()

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: fullCache.state == "loading"
    }

}
