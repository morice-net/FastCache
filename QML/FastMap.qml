import QtQuick 2.3
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    width: parent.width
    height: parent.height

    property alias mapItem: map

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

        Repeater {
            id: displayCaches
            model: cachesBBox.caches
            delegate:MapQuickItem {
                coordinate:QtPositioning.coordinate(modelData.lat(),modelData.lon())
                sourceItem: CacheIcon{

                }
            }
        }

    }

}
