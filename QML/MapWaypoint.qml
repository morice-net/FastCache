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

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(fastMap.compassMapButton) {
                    fastMap.mapItem.deleteCircleWaypoint()
                    fastMap.mapItem.createCircleWaypoint(fullCache.wptsLat[index], fullCache.wptsLon[index])
                    fastCache.compassPageInit(fullCache.wptsDescription[index] , fullCache.wptsLat[index] , fullCache.wptsLon[index])
                }
            }
        }

        Image {
            visible: fullCache.type === "labCache" && fullCache.wptsIsComplete[index]  // if lab cache with stage completed
            anchors.fill: parent
            source: "qrc:/Image/" + "icon_check.png"
            scale: 0.7
        }
    }
}
