import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent
    opacity: main.state == "map" ? 1 : 0
    
    property alias mapItem: map
    property var component
    property var selectedCache
    
    // Map properties
    property real zoomlevelRecord: 14.5
    property real currentZoomlevel: 14.5
    Plugin {
        id: mapPlugin
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
    Map {
        id: map
        plugin: mapPlugin
        property int lastCachesLength: 0
        
        anchors.fill: parent
        zoomLevel: currentZoomlevel
        
        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
        gesture.onPanFinished: { reloadCaches() }
        
        onZoomLevelChanged: {
            console.log(zoomLevel)
            if ((zoomlevelRecord > (zoomLevel + 0.6)) || (zoomlevelRecord < (zoomLevel - 0.6))) {
                zoomlevelRecord = zoomLevel
                reloadCaches()
            }
        }
        
        minimumZoomLevel: 8.
        maximumZoomLevel: 18.
        
        FastScale {
            id: scale
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: mapControls.show()
        }

        function updateCachesOnMap() {
            var currentCachesLength = cachesBBox.caches.length
            if (lastCachesLength >= currentCachesLength) {
                clearMap()
                lastCachesLength = 0
            }

            for (var i = lastCachesLength; i < currentCachesLength; i++) {
                if (cachesBBox.caches[i].lat !== "" && cachesBBox.caches[i].lon !== "") {
                    var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                    itemMap.index = i
                    addMapItem(itemMap)
                }
            }
            scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
            lastCachesLength = cachesBBox.caches.length
        }
        
        
        Component.onCompleted: map.center = currentPosition.position.coordinate
    }
    
    PositionMarker {
        id: positionMarker
    }
    
    MapControls {
        id: mapControls
    }
    
    SelectedCacheItem {
        id: selectedCacheItem

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20

        onOpacityChanged: {
            if (opacity == 1)
                hide()
        }
    }
    
    onSelectedCacheChanged: selectedCacheItem.show(selectedCache)


    function clearMap() {
        map.clearMapItems()
    }
}
