import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent
    opacity: (main.viewState === "map" || main.viewState === "fullcache") ? 1 : 0

    property alias mapItem: map
    property alias mapPlugin:mapPlugin
    property var component
    property var selectedCache
    property var cacheItems: []

    // Map properties
    property real zoomlevelRecord: 14.5
    property real currentZoomlevel: 14.5

    Plugin {
        id: mapPlugin
        name: "esri"
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
        anchors.fill: parent
        zoomLevel: currentZoomlevel
        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
        gesture.onPanFinished: { reloadCaches() }
        onZoomLevelChanged: {
            scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))

            if ((zoomlevelRecord > (zoomLevel + 0.6)) || (zoomlevelRecord < (zoomLevel - 0.6))) {
                zoomlevelRecord = zoomLevel
                reloadCaches()
            }
        }

        onMapReadyChanged: scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y))) ;

        minimumZoomLevel: 6.
        maximumZoomLevel: 18.

        FastScale {
            id: scale
        }

        MouseArea {
            anchors.fill: parent
            onClicked: mapControls.show()
            onPressAndHold: {
                console.log("list of geocodes:   " + listGeocodesOnMap())
                cachesRecordedLists.open()
                fullCachesRecorded.sendRequest(connector.tokenKey , listGeocodesOnMap() , [] , sqliteStorage)
            }
        }

        function updateCachesOnMap(caches) {
            for (var i = 0; i < caches.length; i++) {
                if (caches[i].lat !== "" && caches[i].lon !== "") {
                    var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                    itemMap.index = i
                    cacheItems.push(itemMap)
                    addMapItem(itemMap)
                }
            }
        }

        function updateCacheOnMap(caches , indexList) {
            var itemMap = Qt.createQmlObject('FastMapItem {}', map)
            itemMap.index = indexList
            cacheItems.push(itemMap)
            addMapItem(itemMap)
        }

        Component.onCompleted:{
            map.center = currentPosition.position.coordinate
        }
    }

    CachesRecordedLists {
        id:cachesRecordedLists
        x: main.width/6
        y: 10
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

    CompassMapSwipeButton {
        id: compassMapSwipeButton
        buttonText: "Voir la\nboussole"
        visible: viewState == "fullcache"
        anchors.topMargin: 20 + parent.height * 0.05
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.right: parent.right
        function buttonClicked()
        {
            fastCache.z = 0
        }
    }

    onSelectedCacheChanged: selectedCacheItem.show(selectedCache)

    function clearMap() {
        map.clearMapItems()
        cacheItems.forEach(item => item.destroy())
        cacheItems = []
    }

    function listGeocodesOnMap() {
        var listGeocodes = []
        for (var i = 0; i < map.mapItems.length; i++) {
            listGeocodes.push(map.mapItems[i].geocode)
        }
        return listGeocodes
    }
}
