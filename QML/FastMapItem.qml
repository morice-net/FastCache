import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0
    property string geocode: listCaches().length !==0 ? listCaches()[index].geocode  : ""

    coordinate: listCaches().length !==0 ? QtPositioning.coordinate(listCaches()[index].lat, listCaches()[index].lon) : QtPositioning.coordinate(-1,-1)
    anchorPoint.x: cacheIcon.width/2
    anchorPoint.y: cacheIcon.height
    sourceItem: CacheIcon {
        id: cacheIcon
        type: listCaches().length !==0 ? listCaches()[index].typeIndex : 0
        found: listCaches().length !==0 ? listCaches()[index].found : false
        registered: listCaches().length !==0 ? listCaches()[index].registered : false
        toDoLog: listCaches().length !==0 ? listCaches()[index].toDoLog : false
        own: listCaches().length !==0 ? listCaches()[index].own : false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(listCaches().length !==0)
                    selectedCache = listCaches()[index]
            }
        }
    }

    function listCaches() {
        if(main.cachesActive || main.state === "near" || main.state ==="address" || main.state === "coordinates" || main.state === "recorded")
            return cachesSingleList.caches
    }
    Component.onCompleted: {
        console.log("FastMapItem " + index + " created.")
    }
    Component.onDestruction: {
        console.log("FastMapItem " + index + " destroyed.")
    }
}
