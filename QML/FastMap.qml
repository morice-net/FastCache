import QtQuick
import QtLocation
import QtPositioning

Rectangle {
    id: fastMap
    anchors.fill: parent
    opacity: (main.viewState === "map" || main.viewState === "fullcache") ? 1 : 0

    property var mapItem
    property var map
    property var component
    property var cacheItems: []
    property var circleCacheItems: []

    // map properties
    property real currentZoomlevel: 13
    property int currentCacheIndex: 0

    // compassMap
    property bool compassMapButton: false   // false: compassMapButton not clicked

    property bool mapNorth : true  // map orientation
    property bool oldMapNorth : true

    property int cachesOnMap: countCachesOnMap()  // number of caches on map

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
                value: "https://a.tile.openstreetmap.de/"
            },
            PluginParameter {
                name: "osm.mapping.offline.directory"
                value: tilesDownloader.dirOsm
            },
            PluginParameter {
                name: "osm.mapping.providersrepository.disabled"
                value: true
            },
            PluginParameter {
                name: "osm.mapping.cache.directory"
                value: cacheMapTiles.dirCacheOsm
            }
        ]
    }

    Plugin {
        id: cyclOsmPlugin
        name: "osm"
        parameters: [
            PluginParameter {
                name: "osm.mapping.custom.host"
                value: "https://a.tile-cyclosm.openstreetmap.fr/cyclosm/"
            },
            PluginParameter {
                name: "osm.mapping.offline.directory"
                value: tilesDownloader.dirCyclOsm
            },
            PluginParameter {
                name: "osm.mapping.providersrepository.disabled"
                value: true
            },
            PluginParameter {
                name: "osm.mapping.cache.directory"
                value: cacheMapTiles.dirCacheCyclOsm
            }
        ]
    }

    Component.onCompleted: {
        mapItem = Qt.createQmlObject('MapBuild {id:map; plugin: checkedPluginMap()}', fastMap)
        map = mapItem
    }

    function checkedPluginMap() {
        if(settings.namePlugin === "osmPlugin")
            return osmPlugin
        if(settings.namePlugin === "googlemapsPlugin")
            return googlemapsPlugin
        if(settings.namePlugin === "cyclOsmPlugin")
            return cyclOsmPlugin
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
            //is cache GC and is in viewport
            if(cacheItems[i].geocode.substring(0,2) === "GC" && (map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN"))
                listGeocodes.push(cacheItems[i].geocode)
        }
        return listGeocodes
    }

    function listIdsLabCachesOnMap() {
        var listIds = []
        for (var i = 0; i < cacheItems.length; i++) {
            //is lab cache and is in viewport
            if(cacheItems[i].geocode.substring(0,2) !== "GC" && (map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN"))
                listIds.push(cacheItems[i].geocode)
        }
        return listIds
    }

    function listLatitudeLabCachesOnMap() {
        var listLatitude = []
        for (var i = 0; i < cacheItems.length; i++) {
            //is lab cache and is in viewport
            if(cacheItems[i].geocode.substring(0,2) !== "GC" && (map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN"))
                listLatitude.push(cacheItems[i].coordinate.latitude)
        }
        return listLatitude
    }

    function listLongitudeLabCachesOnMap() {
        var listLongitude = []
        for (var i = 0; i < cacheItems.length; i++) {
            //is lab cache and is in viewport
            if(cacheItems[i].geocode.substring(0,2) !== "GC" && (map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN"))
                listLongitude.push(cacheItems[i].coordinate.longitude)
        }
        return listLongitude
    }

    function listAllCodesOnMap() {
        var list = []
        for (var i = 0; i < cacheItems.length; i++) {
            // is in viewport
            if((map.fromCoordinate(cacheItems[i].coordinate, true).x.toString() !== "NaN"))
                list.push(cacheItems[i].geocode)
        }
        return list
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
        if(main.listState !== "recorded") {
            var listGeocodes = listGeocodesOnMap()
            var listIds = listIdsLabCachesOnMap()
            for (var i = 0; i < cachesSingleList.caches.length; i++) {
                if(listGeocodes.indexOf(cachesSingleList.caches[i].geocode) !== -1 || listIds.indexOf(cachesSingleList.caches[i].geocode) !== -1 ){
                    cachesSingleList.caches[i].registered = true
                }
            }
        }
    }
}
