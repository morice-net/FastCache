import QtQuick
import QtLocation
import QtPositioning

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions
import "JavaScript/helper.js" as Helper

Map {
    id: map

    property var selectedCache
    property MapCircle circle
    property MapCircle circleWaypoint
    property MapCircle circleRadius
    property MapFullCacheItem singleCache
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
        id: pinch
        enabled: !userSettings.isMenuVisible() && viewState === "map" && !geocode.geocodeResponseOpened && !fastMenu.isMenuVisible() &&
                 !cachesRecordedLists.opened
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
        enabled: !userSettings.isMenuVisible() && viewState === "map" && !geocode.geocodeResponseOpened && !fastMenu.isMenuVisible() &&
                 !cachesRecordedLists.opened
        target: null
        onTranslationChanged: (delta) => {
                                  map.pan(-delta.x, -delta.y)
                                  if(cachesSingleList.caches.length !== 0) {
                                      fastMap.cachesOnMap = fastMap.countCachesOnMap() // count caches on map
                                  }
                                  Functions.reloadCachesBBox()
                              }
    }

    onZoomLevelChanged: {
        scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
        if(cachesSingleList.caches.length !== 0)
            fastMap.cachesOnMap = fastMap.countCachesOnMap() // count caches on map
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
        x: main.width * 0.32
        z: map.z + 3
        anchors.top: parent.top
        font.pointSize: 17
        color: Palette.black()
        font.family: localFont.name
        text: !fastMap.compassMapButton ? listModeText(fastMap.cachesOnMap) : fullCache.type !== "labCache" ?
                                              "Cache   " + fullCache.geocode : "Lab Cache   " + fullCache.geocode.substring(0,10) + "..."
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
            if(!fastMap.compassMapButton && !fastMenuHeader.isFiltersVisible())  // Whether or not to save a cache from the map
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
            if (opacity -1 === 0 )
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
            // Map facing north
            map.bearing = 0
            fastMap.mapNorth = true

            fastMap.compassMapButton = false
            fastMap.mapItem.oneCacheOnMap(fullCache.geocode , false) //makes all caches visible on map
            fastMap.mapItem.allCirclesOnMap(true) // makes all cache circles visible on the map
            // is cache in list of caches?
            if(!fastCache.geocodeInCachesList)
                deleteCacheOnMap() // delete cache on map
            // restores the center and the zoom of the map
            center = QtPositioning.coordinate(latCenterMap , lonCenterMap)
            fastMap.currentZoomlevel = zoomMap

            // delete waypoints cache on map
            deleteWaypointsCacheOnMap()

            // delete user waypoints cache on map
            deleteUserWaypointsCacheOnMap()

            // delete circle around  waypoint or cache on map
            deleteCircleWaypoint()

            viewState = "fullcache"
        }
    }

    FastButtonIcon {
        id: north
        visible: fastMap.compassMapButton
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        buttonRadius: width / 2
        sourceHeight: 30
        source: fastMap.oldMapNorth ? "../Image/" + "icon_north.png" : "../Image/" + "icon_compass.png"
        onClicked: {
            if(fastMap.oldMapNorth) {
                north.source = "../Image/" + "icon_compass.png"
                fastMap.mapNorth = false
                fastMap.oldMapNorth = fastMap.mapNorth
                map.bearing = locationSource.azimuthTo(QtPositioning.coordinate(fastCache.goalLat , fastCache.goalLon))
            } else {
                north.source = "../Image/" + "icon_north.png"
                fastMap.mapNorth = true
                fastMap.oldMapNorth = fastMap.mapNorth
                map.bearing = 0
            }
        }
    }

    Item {
        id: littleCompass
        visible: fastMap.compassMapButton
        width: compassMapSwipeButton.width
        anchors.left: compassMapSwipeButton.left
        anchors.top: compassMapSwipeButton.bottom

        Text {
            id:distance
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 8
            font.family: localFont.name
            font.bold: true
            font.pointSize: 17
            color: Palette.black()
            clip: true
            text: Helper.formatDistance(Math.round(locationSource.distanceTo(QtPositioning.coordinate(fastCache.goalLat ,
                                                                                                      fastCache.goalLon))))
        }

        Image {
            id: smallCompassNeedle
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 8
            scale: 1.2
            source: "../Image/Compass/compass_mini.png"

            Behavior on rotation { NumberAnimation { duration: 2000 } }
        }

        function updateRotation() {
            if (fastCache === undefined || fastCache === undefined)
                return
            smallCompassNeedle.rotation = - azimutDevice + locationSource.azimuthTo(QtPositioning.coordinate(fastCache.goalLat , fastCache.goalLon))
        }
        Component.onCompleted: {
            main.positionUpdated.connect(updateRotation)
        }
    }
    onSelectedCacheChanged: {
        if(fastMap.compassMapButton) {
            fastMap.mapItem.deleteCircleWaypoint()
            fastMap.mapItem.createCircleWaypoint(fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                                 fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
            fastCache.compassPageInit(fastCache.compassPageTitleFullCache() , fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                      fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
        }
        selectedCacheItem.show(selectedCache)
    }

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
        fastMap.cachesOnMap = fastMap.countCachesOnMap()  // count caches on map
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
        waypointCacheItems.forEach((item) => item.destroy())
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
        userWaypointCacheItems.forEach((item) => item.destroy())
        userWaypointCacheItems = []
    }

    // Makes a single cache visible on the map if flag is true, makes all caches visible if not.
    function oneCacheOnMap(geocode , flag) {
        for (var i = 0; i < cacheItems.length; i++) {
            if(cacheItems[i].geocode !== geocode)
                cacheItems[i].visible = !flag
        }
    }

    // Makes all cache circles visible on the map if flag is true, makes all cache circles invisible if not
    function allCirclesOnMap(flag) {
        if(settings.circlesCaches)  {
            for (var i = 0; i < cacheItems.length; i++) {
                circleCacheItems[i].visible = flag
            }
        }
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
        circleRadius.radius = radius * 1000
        circleRadius.color = 'green'
        circleRadius.opacity = 0.2
        circleRadius.z = 0
        addMapItem(circleRadius)
    }

    function deleteCircleRadius() {
        removeMapItem(circleRadius)
    }

    // create a circle on map around a waypoint
    function createCircleWaypoint(lat, lon) {
        circleWaypoint = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circleWaypoint.center = QtPositioning.coordinate(lat, lon)
        circleWaypoint.radius = 6.0
        circleWaypoint.color = Palette.turquoise()
        circleWaypoint.border.color = Palette.black()
        circleWaypoint.border.width = 4
        circleWaypoint.opacity = 0.6
        circleWaypoint.z = 0
        fastMap.circleCacheItems.push(circleWaypoint)
        addMapItem(circleWaypoint)
    }

    function deleteCircleWaypoint() {
        removeMapItem(circleWaypoint)
    }



    function supportedMap() {
        //osm
        if(settings.namePlugin === settings.listPlugins[0])
            return 6
        // googlemaps road map
        if(settings.namePlugin === settings.listPlugins[1] && settings.sat === false)
            return 0
        // googlemaps sat
        if(settings.namePlugin === settings.listPlugins[1] && settings.sat === true)
            return 3
        // cyclOsm
        if(settings.namePlugin === settings.listPlugins[2])
            return 6
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

    Component.onCompleted: {
        map.center = locationSource
    }
}

