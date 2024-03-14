import QtQuick
import QtLocation
import QtPositioning

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: positionMarker
    color: Palette.turquoise()
    width: 25
    height: width
    radius: height/2
    x: map.fromCoordinate(locationSource).x
    y: map.fromCoordinate(locationSource).y
    
    NumberAnimation on opacity { from: 0; to: 0.8; duration: 1200;  easing.type: Easing.OutCubic; running: true; loops: NumberAnimation.Infinite }
    Behavior on x { NumberAnimation { duration: 250} }
    Behavior on y { NumberAnimation { duration: 250} }
    
    Timer {
        interval: 300; running: true; repeat: true
        onTriggered: {
            if (map.visibleRegion.contains(locationSource)) {
                positionMarker.x = map.fromCoordinate(locationSource).x
                positionMarker.y = map.fromCoordinate(locationSource).y
            } else {
                positionMarker.x = -positionMarker.width
            }
        }
    }
}
