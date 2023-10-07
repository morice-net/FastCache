import QtQuick
import QtLocation
import QtPositioning

MapQuickItem {

    property int index: 0

    coordinate: QtPositioning.coordinate(fullCache.wptsLat[index], fullCache.wptsLon[index])
    anchorPoint.x: image.width/2
    anchorPoint.y: image.height
    sourceItem: Image {
        id: image
        source: fullCache.wptsIcon[index] !== undefined ? fullCache.wptsIcon[index] : ""
        scale: 1.5
    }
}
