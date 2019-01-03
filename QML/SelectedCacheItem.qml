import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette
import "JavaScript/helper.js" as Helper
import com.mycompany.connecting 1.0

Rectangle {
    id: selectedCacheItem

    color: Palette.white().replace("#","#99")
    radius: parent.width/30
    border.width: 2
    border.color: main.viewState == "map" ? Palette.greenSea() : Palette.silver()

    width: main.width - 40
    height: main.height * 0.12

    opacity: 0
    visible: opacity > 0

    property var selectedCache: Cache {}

    AnimatedSprite {
        id: selectedCacheIconField
        property int type: 0
        paused: true
        source: "qrc:/Image/cacheList.png"
        frameCount: 15
        currentFrame: type % 15
        width: selectedCacheNameField.height + selectedCacheGeocodeField.height + 10
        height: width
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Text {
        id: selectedCacheNameField
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: selectedCacheIconField.right
        font.family: localFont.name
        font.pixelSize: parent.height * 0.15
        color: Palette.black()
        clip: true
        width: parent.width - selectedCacheIconField.width - 3 * anchors.margins
        text: selectedCache.name
    }

    Text {
        id: selectedCacheGeocodeField
        anchors.margins: 10
        anchors.top: selectedCacheNameField.bottom
        anchors.left: selectedCacheIconField.right
        font.family: localFont.name
        font.pixelSize: parent.height * 0.15
        color: Palette.black()
        clip: true
        text: selectedCache.geocode
    }

    Text {
        id: selectedCacheSizeField
        anchors.margins: 10
        anchors.top: selectedCacheNameField.bottom
        anchors.left: selectedCacheTerrainField.left
        font.family: localFont.name
        font.pixelSize: parent.height * 0.15
        color: Palette.black()
        clip: true
    }

    RaterField {
        id: selectedCacheDifficultyField
        anchors.topMargin: 10
        anchors.leftMargin: 20
        anchors.top: selectedCacheGeocodeField.bottom
        anchors.left: parent.left

        ratingName: "Difficulté"
        ratingValue: selectedCache.difficulty
    }

    RaterField {
        id: selectedCacheTerrainField
        anchors.margins: 10
        anchors.top: selectedCacheGeocodeField.bottom
        anchors.left: selectedCacheDifficultyField.right

        ratingName: "Terrain"
        ratingValue: selectedCache.terrain
    }

    MouseArea {
        id: cacheItemArea
        anchors.fill: parent

        onClicked: {
            fullCache.geocode = selectedCache.geocode
            fullCache.sendRequest(connector.tokenKey)
            main.viewState = "fullcache"
        }
    }

    Timer {
        id: hideTimer
        interval: 3200
        onTriggered: selectedCacheItem.opacity = 0
    }

    Location {
        id: selectedCacheLocation
        coordinate {
            latitude: selectedCache.lat
            longitude: selectedCache.lon
        }
    }

    Item {
        id: littleCompass
        height: parent.height /2
        width: height
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top
        clip: false

        Text {
            id:distance
            anchors.margins: 5
            anchors.top: parent.top
            anchors.right: parent.right
            font.family: localFont.name
            font.pixelSize: selectedCacheItem.height * 0.15
            color: Palette.black()
            clip: true
            text: Helper.formatDistance(Math.round(currentPosition.position.coordinate
                                                   .distanceTo(QtPositioning.coordinate(selectedCache.lat, selectedCache.lon))))
        }

        Image {
            id: smallCompassNeedle
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "qrc:/Image/Compass/compass_mini.png"
            width: sourceSize.width*1.8
            height: sourceSize.height*1.8
        }

        function updateRotation() {
            console.log("Updating small compass...")
            if (currentPosition == undefined)
                return
            smallCompassNeedle.rotation = currentPosition.position.coordinate.azimuthTo(selectedCacheLocation.coordinate)
        }
        Component.onCompleted: {
            main.positionUpdated.connect(updateRotation)
        }
    }

    Behavior on opacity { NumberAnimation { duration: 250 } }

    function show(selectedCacheVar) {
        if (!selectedCacheVar)
            return;

        selectedCache = selectedCacheVar

        // Size rounding
        selectedCacheSizeField.text = "Taille: ??? "
        for (var i = 0; i < cacheSizes.sizes.length; i++) {
            if(cacheSizes.sizes[i].sizeIdGs === selectedCacheVar.size ){
                selectedCacheSizeField.text = "Taille: " + cacheSizes.sizes[i].frenchPattern
                break;
            }
        }

        selectedCacheIconField.type = cacheMarkerId(selectedCacheVar.type)
        if (hideTimer.running)
            hideTimer.restart()

        opacity = 1
    }

    function hide() {
        hideTimer.start()
    }
}
