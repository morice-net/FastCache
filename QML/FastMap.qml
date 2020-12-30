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
    property real currentZoomlevel: 14.5
    property int currentCacheIndex: 0

    Plugin {
        id: mapPlugin
        name: "googlemaps"
        parameters: [
            // configure googlemaps
            PluginParameter {
                name: "googlemaps.maps.apikey"
                value: "AIzaSyDGoRP53cn7a8rQ4oXgFXKLDoag3rlGvV4"
            },
            PluginParameter {
                name: "googlemaps.geocode.apikey"
                value: "AIzaSyDIgUAHUcSx5jBqcXN3-HiFSORfU6Y-Fl4"
            },

            // configure mapbox
            PluginParameter {
                name: "mapbox.mapping.map_id"
                value: "mapbox.streets"
            },
            PluginParameter {
                name: "mapboxgl.access_token"
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
        activeMapType: supportedMapTypes[settings.sat === false ? 0 : 3]
        anchors.fill: parent
        zoomLevel: currentZoomlevel
        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
        gesture.onPanFinished: reloadCaches()
        onZoomLevelChanged: {
            if(main.viewState === "map") {
                scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
                reloadCaches()
            }
        }
        onMapReadyChanged: scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
        minimumZoomLevel: 6.
        maximumZoomLevel: 18.

        LoadingPage {
            id: loadingPage
        }

        FastScale {
            id: scale
        }

        MouseArea {
            anchors.fill: parent
            onClicked: mapControls.show()
            onPressAndHold: {
                if(main.state === "near" || main.state === "address" || main.state === "coordinates" || main.state === "recorded" ||main.cachesActive)
                    cachesRecordedLists.open()
            }
        }

        function updateCachesOnMap(caches) {
            while(currentCacheIndex <= caches.length) {
                if (caches[currentCacheIndex].lat !== "" && caches[currentCacheIndex].lon !== "") {
                    var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                    itemMap.index = currentCacheIndex
                    cacheItems.push(itemMap)
                    addMapItem(itemMap)
                    currentCacheIndex++
                }
            }
        }

        function updateCacheOnMap(indexList) {
            var itemMap = Qt.createQmlObject('FastMapItem {}', map)
            itemMap.index = indexList
            cacheItems.push(itemMap)
            addMapItem(itemMap)
            currentCacheIndex++
        }

        Component.onCompleted:{
            map.center = currentPosition.position.coordinate
        }
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
        currentCacheIndex = 0
    }

    function listGeocodesOnMap() {
        var listGeocodes = []
        for (var i = 0; i < map.mapItems.length; i++) {
            // is in viewport
            if(map.fromCoordinate(map.mapItems[i].coordinate, true).x.toString() !== "NaN")
                listGeocodes.push(map.mapItems[i].geocode)
        }
        return listGeocodes
    }

    function markedCachesRegistered() {
        if(main.state === "near" || main.state === "address" || main.state === "coordinates" ) {
            for (var i = 0; i < cachesNear.caches.length; i++) {
                if(listGeocodesOnMap().indexOf(cachesNear.caches[i].geocode) !== -1){
                    cachesNear.caches[i].registered = true
                }
            }
        }
        if(main.cachesActive) {
            for (var j = 0; j < cachesBBox.caches.length; j++) {
                if(listGeocodesOnMap().indexOf(cachesBBox.caches[j].geocode) !== -1) {
                    cachesBBox.caches[j].registered = true
                }
            }
        }
    }
}
