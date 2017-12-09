import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3



import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent

    property alias mapItem: map
    property var component

    Plugin {
        id: osm
        preferred: ["osm"]
        //required: Plugin.AnyMappingFeatures | Plugin.AnyGeocodingFeatures
    }

    Map {
        id: map
        plugin: osm
        anchors.fill: parent
        center: currentPosition.position.coordinate
        property real zoomlevelRecord: 14.5
        zoomLevel: { 14.5 }
        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
        onZoomLevelChanged: {
            console.log(zoomLevel)
            if ((zoomlevelRecord > (zoomLevel + 1)) || (zoomlevelRecord < (zoomLevel - 1))) {
                zoomlevelRecord = zoomLevel
                map.clearMapItems()
                userInfo.sendRequest(connector.tokenKey)
            }
        }

        function updateCachesOnMap() {
            for (var i = 0; i < cachesBBox.caches.length; i++) {
                var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                itemMap.index = i
                addMapItem(itemMap)
            }

        }
    }

}
