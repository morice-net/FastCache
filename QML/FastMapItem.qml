import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0
    property string geocode: index < listCaches().length ? listCaches()[index].geocode  : ""

    coordinate: index < listCaches().length ? QtPositioning.coordinate(listCaches()[index].lat, listCaches()[index].lon) : QtPositioning.coordinate(-1,-1)
    anchorPoint.x: cacheIcon.width/2
    anchorPoint.y: cacheIcon.height
    sourceItem: CacheIcon {
        id: cacheIcon
        type: index < listCaches().length ? listCaches()[index].typeIndex : 0
        found: index < listCaches().length ? listCaches()[index].found : false
        registered: index < listCaches().length ? listCaches()[index].registered : false
        toDoLog: index < listCaches().length ? listCaches()[index].toDoLog : false
        own: index < listCaches().length ? listCaches()[index].own : false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(listCaches().length !==0)
                    selectedCache = listCaches()[index]
            }
        }
    }

    function listCaches() {
        return cachesSingleList.caches
    }
    Component.onCompleted: {
        console.log("FastMapItem " + index + " created.")
    }
    Component.onDestruction: {
        console.log("FastMapItem " + index + " destroyed.")
    }
}
