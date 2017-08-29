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
            anchorPoint.x: image.width * 0.5
            anchorPoint.y: image.height

            sourceItem: Image {
                id: image
                source: "qrc:/Image/cache.png"
                opacity: 0.8
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { target: image; property: "opacity"; from: 0; to: 1; duration: 1000; easing.type: "OutQuart" }
                    NumberAnimation{ target: image; property: "opacity"; from: 1; to: 0; duration: 1000; easing.type: "InQuart" }
                }
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
}


