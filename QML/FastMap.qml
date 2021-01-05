import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent
    opacity: (main.viewState === "map" || main.viewState === "fullcache") ? 1 : 0

    property var mapItem
    property var map
    property var component
    property var cacheItems: []

    // Map properties
    property real currentZoomlevel: 14.5
    property int currentCacheIndex: 0

    Plugin {
        id: googlemapsPlugin
        name: "googlemaps"
        parameters: [
            PluginParameter {
                name: "googlemaps.maps.apikey"
                value: "AIzaSyDGoRP53cn7a8rQ4oXgFXKLDoag3rlGvV4"
            },
            PluginParameter {
                name: "googlemaps.geocode.apikey"
                value: "AIzaSyDIgUAHUcSx5jBqcXN3-HiFSORfU6Y-Fl4"
            }]
    }

    Plugin {
        id: osmPlugin
        name: "osm"
    }

    Plugin {
        id: mapboxPlugin
        name: "mapboxgl"
        parameters: [
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

    Component.onCompleted: {
        mapItem = Qt.createQmlObject('MapBuild {id:map; plugin: checkedPluginMap()}', fastMap)
        map = mapItem
    }

    function checkedPluginMap() {
        if(settings.namePlugin === "osm")
            return osmPlugin
        if(settings.namePlugin === "googlemaps")
            return googlemapsPlugin
    }

    function deleteMap() {
        map.destroy()
    }

    function createMap() {
        mapItem = Qt.createQmlObject('MapBuild {id:map; plugin: checkedPluginMap()}', fastMap)
        map = mapItem
    }

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
