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

    // compassMap
    property bool compassMapButton: false   // false: compassMapButton not clicked

    Plugin {
        id: googlemapsPlugin
        name: "googlemaps"
        parameters: [
            PluginParameter {
                name: "googlemaps.mapping.offline.directory"
                value:  tilesDownloader.dirGooglemaps
            },
            PluginParameter {
                name: "googlemaps.maps.apikey"
                value: Qt.atob("QUl6YVN5QUpXZUFyZUdtbE1tdGlVN1lROWVEWFM5Z1ZMLVV2ZkE0")
            },
            PluginParameter {
                name: "googlemaps.geocode.apikey"
                value: Qt.atob("QUl6YVN5Q2JiSXJkYi1DbFM4REQ1VDVacGV2SExBUWx3ME43ME1z")
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
                value: Qt.atob("YlkzQWNVVUpnSHdIWlJ6SFpLdDk=")
            },
            PluginParameter {
                name: "here.token"
                value: Qt.atob("Y29uSzNQVlBuZlVKUkZqc2YwTlJ2dw==")
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

    function countCachesOnMap() {
        var count  = 0
        for (var i = 0; i < map.mapItems.length; i++) {
            // is in viewport
            if(map.fromCoordinate(map.mapItems[i].coordinate, true).x.toString() !== "NaN")
                count = count + 1
        }
        return count
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
