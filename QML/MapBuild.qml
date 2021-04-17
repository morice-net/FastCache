import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

Map {
    id: map

    property var selectedCache

    activeMapType: supportedMapTypes[settings.sat === false ? 0 : 3]
    anchors.fill: parent
    zoomLevel: currentZoomlevel
    gesture.enabled: true
    gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture
    gesture.onPanFinished: reloadCaches()
    onZoomLevelChanged: {
        scale.updateScale(map.toCoordinate(Qt.point(scale.x,scale.y)), map.toCoordinate(Qt.point(scale.x + scale.imageSourceWidth,scale.y)))
        reloadCaches()
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
            if(main.state !== "")
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

    function updateCachesOnMap(caches) {
        while(fastMap.currentCacheIndex <= caches.length) {
            if (caches[fastMap.currentCacheIndex].lat !== "" && caches[fastMap.currentCacheIndex].lon !== "") {
                var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                itemMap.index = fastMap.currentCacheIndex
                cacheItems.push(itemMap)
                addMapItem(itemMap)
                fastMap.currentCacheIndex++
            }
        }
    }

    function updateCacheOnMap(indexList) {
        var itemMap = Qt.createQmlObject('FastMapItem {}', map)
        itemMap.index = indexList
        cacheItems.push(itemMap)
        addMapItem(itemMap)
        fastMap.currentCacheIndex++
    }

    Component.onCompleted:{
        map.center = currentPosition.position.coordinate
    }
}

