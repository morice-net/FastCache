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
                name: "googlemaps.mapping.offline.directory"
                value: "./googleMapsTiles"
            },
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
        parameters: [
            PluginParameter {
                name: "osm.mapping.providersrepository.address"
                value: "http://a.tile.openstreetmap.org/"
            },
            PluginParameter {
                name: "osm.mapping.offline.directory"
                value: tilesDownloader.dirOsm
            }
        ]
    }
    Plugin {
        id: herePlugin
        name: "here"
        parameters: [
            PluginParameter {
                name: "here.app_id"
                value: "bY3AcUUJgHwHZRzHZKt9"
            },
            PluginParameter {
                name: "here.token"
                value: "conK3PVPnfUJRFjsf0NRvw"
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
        if(settings.namePlugin === "here")
            return herePlugin
    }

    function deleteMap() {
        clearMap()
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

        // Does not erase the possible circle on the map
        if(settings.circleMap)
            fastMap.mapItem.createCircleRadius(settings.circleMapRadius)
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
        if(main.state !== "recorded") {
            for (var i = 0; i < cachesSingleList.caches.length; i++) {
                if(listGeocodesOnMap().indexOf(cachesSingleList.caches[i].geocode) !== -1){
                    cachesSingleList.caches[i].registered = true
                }
            }
        }
    }
}
