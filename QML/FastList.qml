import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastList
    anchors.fill: parent
    opacity: main.state == "list" ? 1 : 0
    color: Palette.white()

    Rectangle {
        id: fastListHeader
        width: parent.width
        height: parent.height * 0.07
        color: Palette.white()

        Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.family: localFont.name
            font.pixelSize: parent.height * 0.65
            color: Palette.greenSea()
            text: "Liste de caches"
        }
    }

    ListView {
        id: fastListColumn
        width: parent.width
        height: parent.height - fastListHeader.height - 10
        y: fastListHeader.height + 10
        spacing: 5
        model: cachesBBox.caches
        delegate: SelectedCacheItem {
            x: (fastList.width - width ) / 2
            Component.onCompleted: show(modelData)
        }
    }
}
