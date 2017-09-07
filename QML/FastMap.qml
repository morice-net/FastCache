import QtQuick 2.3
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    width: parent.width
    height: parent.height

    Plugin {
        id: osm
        name: "osm"
    }

    Map {
        id: map
        plugin: osm
        anchors.fill: parent
        center: currentPosition.position.coordinate
        zoomLevel: { 14.5 }
        gesture.enabled: true

        //gesture.activeGestures: MapGestureArea.ZoomGesture
        MapCircle {
            id: circleSearchArea
            center: parent.center
            radius: 1000
            color: Palette.turquoise()
            border.width: 1
            border.color: Palette.greenSea()
            opacity: 0.25
        }

        MapQuickItem {
            id: centerItem
            coordinate: parent.center

            sourceItem: CacheIcon {
                id: cacheIcon
            }
        }

        MapQuickItem {
            id: firstCache
            coordinate: parent.center
            visible: false

            anchorPoint.x: cacheImage.width * 0.5
            anchorPoint.y: cacheImage.height

            sourceItem: Image {
                id: cacheImage
                source: "qrc:/Image/cache.png"
                opacity: 0.8
            }
        }
    }

    function getTopLeft() {
        return map.toCoordinate(Qt.point(0,0))
    }

    function getBottomRight() {
        return map.toCoordinate(Qt.point(width,height))
    }
}


