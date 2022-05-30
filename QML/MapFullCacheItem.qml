import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

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
    }
}

