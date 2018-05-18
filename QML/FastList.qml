import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastList
    anchors.fill: parent
    visible: main.state == "list"
    color: Palette.white()
    
    property var selectedCache

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

    ScrollView {
        width: parent.width
        height: parent.height - fastListHeader.height - 10
        y: fastListHeader.height + 10
        Column {
            width: parent.width
            height: cachesBBox.caches.length * (0.12 * parent.height + 5)
            spacing: 5
            Repeater {
                model: cachesBBox.caches
                SelectedCacheItem {
                    x: (fastList.width - width ) / 2
                    Component.onCompleted: show(modelData)
                }
            }
        }
    }

    function updateCachesOnMap() {
        var currentCachesLength = cachesBBox.caches.length
        if (lastCachesLength >= currentCachesLength) {
            clearMap()
            lastCachesLength = 0
        }

        for (var i = lastCachesLength; i < currentCachesLength; i++) {
            if (cachesBBox.caches[i].lat != "" && cachesBBox.caches[i].lon != "") {
                var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                itemMap.index = i
                addMapItem(itemMap)
            }
        }
        lastCachesLength = cachesBBox.caches.length

        scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x+scale.width,scale.y)))
    }

}
