import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3



import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    width: parent.width
    height: parent.height

    property alias mapItem: map
    property var component

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

    }

    function updateCachesOnMap() {
        for (var i = 0; i < cachesBBox.caches.length; i++) {
            var itemMap = Qt.createQmlObject('FastMapItem {}', map)
            itemMap.index = i
            map.addMapItem(itemMap)
        }

    }
}
