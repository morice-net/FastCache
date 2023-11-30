import QtQuick
import QtLocation
import QtPositioning

MapQuickItem {

    property string geocode: fullCache.geocode

    coordinate: QtPositioning.coordinate(fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat,
                                         fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
    anchorPoint.x: cacheIcon.width/2
    anchorPoint.y: cacheIcon.height
    sourceItem: CacheIcon {
        id: cacheIcon
        type: fullCache.typeIndex
        found: fullCache.found
        registered: fullCache.registered
        toDoLog: fullCache.toDoLog
        own: fullCache.own

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(fastMap.compassMapButton) {
                    fastMap.mapItem.deleteCircleWaypoint()
                    fastMap.mapItem.createCircleWaypoint(fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                                         fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
                    fastCache.compassPageInit(fastCache.compassPageTitleFullCache() , fullCache.isCorrectedCoordinates ?
                                                  fullCache.correctedLat : fullCache.lat , fullCache.isCorrectedCoordinates ?
                                                  fullCache.correctedLon : fullCache.lon)
                }
            }
        }
    }
}

