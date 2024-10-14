import QtQuick
import QtLocation
import QtPositioning

MapQuickItem {

    property int index: 0

    coordinate: QtPositioning.coordinate(fullCache.userWptsLat[index], fullCache.userWptsLon[index])
    anchorPoint.x: image.width/2
    anchorPoint.y: image.height
    sourceItem: Image {
        id: image
        source: "../Image/Waypoints/waypoint_user.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(fastMap.compassMapButton) {
                    fastMap.mapItem.deleteCircleWaypoint()
                    fastMap.mapItem.createCircleWaypoint(fullCache.userWptsLat[index] , fullCache.userWptsLon[index] )
                    fastCache.compassPageInit(fullCache.userWptsDescription[index] , fullCache.userWptsLat[index] , fullCache.userWptsLon[index])
                }
            }
        }
    }
}
