import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

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
