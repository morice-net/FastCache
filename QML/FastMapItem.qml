import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0

    coordinate: QtPositioning.coordinate(listCaches()[index].lat, listCaches()[index].lon)
    anchorPoint.x: cacheIcon.width/2
    anchorPoint.y: cacheIcon.height
    sourceItem: CacheIcon {
        id: cacheIcon
        type: listCaches()[index].typeIndex
        found: listCaches()[index].found
        registered: listCaches()[index].registered

        MouseArea {
            anchors.fill: parent
            onClicked: selectedCache = listCaches()[index]
        }
    }

    function listCaches() {
        if(main.cachesActive)
            return cachesBBox.caches
        if(main.state === "near" || main.state ==="address" || main.state === "coordinates" )
            return cachesNear.caches
    }
}
