import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Map {
    id: map

    property var selectedCache
    property MapCircle circle
    property MapCircle circleRadius
    property int cachesOnMap: fastMap.countCachesOnMap() // number of caches on map

    activeMapType: supportedMapTypes[supportedMap()]
    anchors.fill: parent
    zoomLevel: currentZoomlevel
    gesture.enabled: true
    gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
    gesture.onPanFinished: {
        if(cachesSingleList.caches.length !== 0)
            cachesOnMap = fastMap.countCachesOnMap() // update cachesOnMap
        Functions.reloadCachesBBox()
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
        font.pixelSize: 30
        color: Palette.black()
        font.family: localFont.name
        text: listModeText(cachesOnMap)
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
        anchors.right: parent.right
        anchors.margins: 20
        onOpacityChanged: {
            if (opacity == 1)
                hide()
        }
        color: Palette.white().replace("#","#99")
    }

    CompassMapSwipeButton {
        id: compassMapSwipeButton
        buttonText: "Voir la\nboussole"
        visible: viewState === "fullcache"
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

    function updateCacheOnMap(indexList) {
        var itemMap = Qt.createQmlObject('FastMapItem {}', map)
        itemMap.index = indexList
        cacheItems.push(itemMap)
        itemMap.z = 1
        addMapItem(itemMap)
        fastMap.currentCacheIndex++
    }

    // create a circle on map around a cache with radius 161m
    function createCircle(lat, lon) {
        circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circle.center = QtPositioning.coordinate(lat, lon)
        circle.radius = 161.0
        circle.color = 'red'
        circle.opacity = 0.3
        circle.z = 0
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

