import QtQuick
import QtLocation
import QtPositioning

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Map {
    id: map

    property var selectedCache
    property MapCircle circle
    property MapCircle circleSingleCache
    property MapCircle circleRadius
    property MapFullCacheItem singleCache
    property int cachesOnMap: fastMap.countCachesOnMap() // number of caches on map
    property var waypointCacheItems: []  // list of waypoints of cache
    property var userWaypointCacheItems: []  // list of user waypoints of cache

    // memorizes the center and the zoom of the map
    property real latCenterMap
    property real lonCenterMap
    property real zoomMap

    property geoCoordinate startCentroid  // pinchHandler

    activeMapType: supportedMapTypes[supportedMap()]
    anchors.fill: parent
    zoomLevel: currentZoomlevel

    PinchHandler {
        enabled: !userSettings.isMenuVisible() && viewState === "map" && !geocode.geocodeResponseOpened && !fastMenu.isMenuVisible()
        target: null
        rotationAxis.enabled: false
        onActiveChanged: if (active) {
                             map.startCentroid = map.toCoordinate(centroid.position, false)
                         }
        onScaleChanged: (delta) => {
                            currentZoomlevel += Math.log2(delta)
                            map.alignCoordinateToPoint(map.startCentroid, centroid.position)
                        }
    }

    DragHandler {
        enabled: !userSettings.isMenuVisible() && viewState === "map" && !geocode.geocodeResponseOpened && !fastMenu.isMenuVisible()
        target: null
        onTranslationChanged: (delta) => {
                                  map.pan(-delta.x, -delta.y)
                                  if(cachesSingleList.caches.length !== 0) {
                                      cachesOnMap = fastMap.countCachesOnMap() // update cachesOnMap
                                  }
                                  Functions.reloadCachesBBox()
                              }
    }

    onZoomLevelChanged: {
        scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
        if(cachesSingleList.caches.length !== 0)
            cachesOnMap = fastMap.countCachesOnMap() // update cachesOnMap
        Functions.reloadCachesBBox()
    }

    onMapReadyChanged: scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
    minimumZoomLevel: 6.
    maximumZoomLevel: 18.
    onCenterChanged: {
        if(settings.circleMap) {
            deleteCircleRadius()
            createCircleRadius(settings.circleMapRadius)
        }
    }

    Text {
        id: numberCaches
        z: map.z + 3
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 17
        color: Palette.black()
        font.family: localFont.name
        text: !fastMap.compassMapButton ? listModeText(cachesOnMap) : "Cache   " + fullCache.geocode
    }

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
            if(!fastMap.compassMapButton)  // Whether or not to save a cache from the map
                cachesRecordedLists.open()
        }
    }

    PositionMarker {
        id: positionMarker
    }

    MapControls {
        id: mapControls
        z: 3
    }

    SelectedCacheItem {
        id: selectedCacheItem
        z: 3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        onOpacityChanged: {
            if (opacity === 1)
                hide()
        }
        color: Palette.white().replace("#","#99")
    }

    FastButton {
        id: compassMapSwipeButton
        opacity: 0.85
        font.pointSize: 17
        text: "Voir la\nboussole"
        visible: fastMap.compassMapButton
        anchors.topMargin: 20 + parent.height * 0.05
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.right: parent.right
        onClicked: {
            viewState = "fullcache"
            fastMap.compassMapButton = false
            fastMap.mapItem.oneCacheOnMap(fullCache.geocode , false) //makes all caches visible on map
            fastMap.mapItem.oneCircleOnMap(fullCache.geocode , false) // makes all circle caches visible on map
            // is cache in list of caches?
            if(!fastCache.geocodeInCachesList) {
                deleteCacheOnMap() // delete cache on map
                if(settings.circlesCaches)
                    deleteCircleSingleCache() // delete circle around singlecache
            }
            // restores the center and the zoom of the map
            center = QtPositioning.coordinate(latCenterMap , lonCenterMap)
            fastMap.currentZoomlevel = zoomMap

            // delete waypoints cache on map
            deleteWaypointsCacheOnMap()

            // delete user waypoints cache on map
            deleteUserWaypointsCacheOnMap()
        }
    }
    onSelectedCacheChanged: selectedCacheItem.show(selectedCache)

    function updateCachesOnMap(caches) {
        while(fastMap.currentCacheIndex < caches.length) {
            if (caches[fastMap.currentCacheIndex].lat !== "" && caches[fastMap.currentCacheIndex].lon !== "") {
                var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                itemMap.index = fastMap.currentCacheIndex
                cacheItems.push(itemMap)
                itemMap.z = 1
                addMapItem(itemMap)

                // add circle or not on the map
                if(settings.circlesCaches)
                    createCircle(caches[fastMap.currentCacheIndex].lat , caches[fastMap.currentCacheIndex].lon)
                fastMap.currentCacheIndex++
            }
        }
        cachesOnMap = fastMap.countCachesOnMap()  // update cachesOnMap
    }

    // cache on map
    function addCacheOnMap() {
        singleCache = Qt.createQmlObject('import QtLocation 5.3; MapFullCacheItem {}', map)
        singleCache.z = 1
        addMapItem(singleCache)
    }

    function deleteCacheOnMap() {
        removeMapItem(singleCache)
    }

    // waypoints cache on map
    function addWaypointsCacheOnMap() {
        for (var i = 0; i < fullCache.wptsComment.length; i++) {
            var waypoint = Qt.createQmlObject('import QtLocation 5.3; MapWaypoint {}', map)
            waypoint.index = i
            waypoint.z = 1
            waypointCacheItems.push(waypoint)
            addMapItem(waypoint)
        }
    }

    function deleteWaypointsCacheOnMap() {
        waypointCacheItems.forEach(item => item.destroy())
        waypointCacheItems = []
    }

    // user waypoints cache on map
    function addUserWaypointsCacheOnMap() {
        for (var i = 0; i < fullCache.userWptsCode.length; i++) {
            var userWaypoint = Qt.createQmlObject('import QtLocation 5.3; MapUserWaypoint {}', map)
            userWaypoint.index = i
            userWaypoint.z = 1
            userWaypointCacheItems.push(userWaypoint)
            addMapItem(userWaypoint)
        }
    }

    function deleteUserWaypointsCacheOnMap() {
        userWaypointCacheItems.forEach(item => item.destroy())
        userWaypointCacheItems = []
    }

    // Makes a single cache visible on the map if flag is true, makes all caches visible if not.
    function oneCacheOnMap(geocode , flag) {
        for (var i = 0; i < cacheItems.length; i++) {
            if(cacheItems[i].geocode !== geocode)
                cacheItems[i].visible = !flag
        }
    }

    // Makes a single cercle cache visible on the map if flag is true, makes all circle caches visible if not.
    function oneCircleOnMap(geocode , flag) {
        if(settings.circlesCaches)  {
            for (var i = 0; i < cacheItems.length; i++) {
                if(cacheItems[i].geocode !== geocode)
                    circleCacheItems[i].visible = !flag
            }
        }
    }

    // create a circle on map around a single cache with radius 161m
    function createCircleSingleCache(lat, lon) {
        circleSingleCache = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circleSingleCache.center = QtPositioning.coordinate(lat, lon)
        circleSingleCache.radius = 161.0
        circleSingleCache.color = 'red'
        circleSingleCache.opacity = 0.3
        circleSingleCache.z = 0
        addMapItem(circleSingleCache)
    }

    // delete a circle on map around a single cache with radius 161m
    function deleteCircleSingleCache(lat, lon) {
        removeMapItem(circleSingleCache)
    }

    // create a circle on map around a cache with radius 161m
    function createCircle(lat, lon) {
        circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circle.center = QtPositioning.coordinate(lat, lon)
        circle.radius = 161.0
        circle.color = 'red'
        circle.opacity = 0.3
        circle.z = 0
        fastMap.circleCacheItems.push(circle)
        addMapItem(circle)
    }

    // create circle on map with variable radius
    function createCircleRadius(radius) {
        circleRadius = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circleRadius.center = mapItem.center
        circleRadius.radius = radius*1000
        circleRadius.color = 'green'
        circleRadius.opacity = 0.2
        circleRadius.z = 0
        addMapItem(circleRadius)
    }

    function deleteCircleRadius() {
        removeMapItem(circleRadius)
    }

    function supportedMap() {
        //osm
        if(settings.namePlugin === settings.listPlugins[0])
            return 0
        // googlemaps road map
        if(settings.namePlugin === settings.listPlugins[1] && settings.sat === false)
            return 0
        // googlemaps sat
        if(settings.namePlugin === settings.listPlugins[1] && settings.sat === true)
            return 3
        // here
        if(settings.namePlugin === settings.listPlugins[2])
            return 0
    }

    function listModeText(count) {
        if(main.annexMainState === "cachesActive"){
            return "Carte active (" + count + ")"
        } else if(main.annexMainState === "near"){
            return  "Caches proches (" + count + ")"
        } else if(main.annexMainState === "address" ){
            return  "Par adresse (" + count + ")"
        } else if(main.annexMainState === "coordinates" ){
            return  "Par coordonnées (" + count + ")"
        } else if (main.annexMainState === "pocketQuery") {
            return "Pocket Query (" + count + ")"
        } else if(main.annexMainState === "recorded"){
            return "Caches enregistrées (" + count + ")"
        }
        return "Carte non active (" + count + ")"
    }

    Component.onCompleted:{
        map.center = currentPosition.position.coordinate
    }
}

