import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3



import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent

    property alias mapItem: map
    property var component

    Map {
        id: map
        plugin: Plugin {
            name: "mapbox"
            // configure your own map_id and access_token here
            parameters: [  PluginParameter {
                    name: "mapbox.mapping.map_id"
                    value: "mapbox.streets"
                },
                PluginParameter {
                    name: "mapbox.access_token"
                    value: "pk.eyJ1IjoiZ3R2cGxheSIsImEiOiJjaWZ0Y2pkM2cwMXZqdWVsenJhcGZ3ZDl5In0.6xMVtyc0CkYNYup76iMVNQ"
                },
                PluginParameter {
                    name: "mapbox.mapping.highdpi_tiles"
                    value: true
                }]
        }
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
