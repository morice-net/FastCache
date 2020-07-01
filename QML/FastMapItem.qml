import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0

    coordinate: listCaches().length >index ? QtPositioning.coordinate(listCaches()[index].lat, listCaches()[index].lon) : QtPositioning.coordinate(-1,-1)
    anchorPoint.x: cacheIcon.width/2
    anchorPoint.y: cacheIcon.height
    sourceItem: CacheIcon {
        id: cacheIcon
        type: listCaches().length >index ? listCaches()[index].typeIndex : 0
        found: listCaches().length >index ? listCaches()[index].found : false
        registered: listCaches().length >index ? listCaches()[index].registered : false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(listCaches().length >index)
                    selectedCache = listCaches()[index]
            }
        }
    }

    function listCaches() {
        if(main.cachesActive)
            return cachesBBox.caches
        if(main.state === "near" || main.state ==="address" || main.state === "coordinates" )
            return cachesNear.caches
        if(main.state === "recorded"){
            console.log("INDEX:  " + index )
            return cachesRecorded.caches
        }
    }
}
