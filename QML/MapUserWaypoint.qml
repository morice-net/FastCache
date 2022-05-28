import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0

    coordinate: QtPositioning.coordinate(fullCache.userWptsLat[index], fullCache.userWptsLon[index])
    anchorPoint.x: image.width/2
    anchorPoint.y: image.height
    sourceItem: Image {
        id: image
        source: "qrc:/Image/Waypoints/waypoint_user.png"
        scale: 1.3
    }
}
