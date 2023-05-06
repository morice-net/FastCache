import QtQuick
import QtLocation
import QtPositioning

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent
    opacity: (main.viewState === "map" || main.viewState === "fullcache") ? 1 : 0

    property var mapItem
    property var map
    property var component
    property var cacheItems: []
    property var circleCacheItems: []

    // Map properties
    property real currentZoomlevel: 13
    property int currentCacheIndex: 0

    // compassMap
    property bool compassMapButton: false   // false: compassMapButton not clicked

    property bool mapNorth : true  // map orientation
    property bool oldMapNorth : true

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
                name: "osm.mapping.custom.host"
                value: "https://maps.wikimedia.org/"
            },
            PluginParameter {
                name: "osm.mapping.offline.directory"
                value: tilesDownloader.dirOsm
            }
        ]
    }

    Plugin {
        id: mapboxPlugin
        name: "mapbox"
        parameters: [
            PluginParameter {
                name: "mapbox.access_token"
                value: "pk.eyJ1IjoiZ2VyYXJkYXJ0YXV0IiwiYSI6ImNsZ3c4eTNidjEybGkzc281MWFqMjJ1MmwifQ.63ioe_G6lECaFUs-8aWMwg"
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
        if(settings.namePlugin === "mapbox")
            return mapboxPlugin
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
        cacheItems.forEach((item) => item.destroy())
        cacheItems = []
        circleCacheItems.forEach((item) => item.destroy())
        circleCacheItems = []
        currentCacheIndex = 0

        // Does not erase the possible circle on the map
        if(settings.circleMap)
            fastMap.mapItem.createCircleRadius(settings.circleMapRadius)
    }

    function listGeocodesOnMap() {
        var listGeocodes = []
        for (var i = 0; i < cacheItems.length; i++) {
            // is in viewport
            if(map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN")
                listGeocodes.push(cacheItems[i].geocode)
        }
        return listGeocodes
    }

    function countCachesOnMap() {
        var count  = 0
        for (var i = 0; i < cacheItems.length; i++) {
            //    is in viewport
            if(map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN")
                count = count + 1
        }
        return count
    }

    function isGeocodeInCachesList(geocode) {
        for (var i = 0; i < cachesSingleList.caches.length; i++) {
            if(cachesSingleList.caches[i].geocode === geocode)
                return true
        }
        return false
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
