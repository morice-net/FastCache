import QtQuick
import QtLocation
import QtPositioning
import QtSensors

import "JavaScript/Palette.js" as Palette
import "JavaScript/helper.js" as Helper
import com.mycompany.connecting 1.0

Rectangle {
    id: selectedCacheItem
    visible: opacity > 0 && !fastMap.compassMapButton
    radius: 10
    border.width: 2
    border.color: main.viewState === "map" ? Palette.greenSea() : Palette.silver()
    width: main.width * 0.95
    height: main.height * 0.12
    x: (main.width - selectedCacheItem.width) / 2
    opacity: 0

    property var selectedCache: Cache {}

    AnimatedSprite {
        id: selectedCacheIconField
        visible: selectedCache !== null ? selectedCache.type !== "labCache" : false

        property int type: 0

        running: false
        source: "../Image/cacheList.png"
        frameCount: 15
        currentFrame: type
        width: selectedCacheNameField.height + selectedCacheGeocodeField.height
        height: width
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Image {
        id: labCache
        visible: selectedCache !== null ? selectedCache.type === "labCache" : false
        width: (selectedCacheNameField.height + selectedCacheGeocodeField.height) * 0.8
        height: width
        source: "../Image/labCache.png"
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Image {
        visible: selectedCache !== null ? selectedCache.found : false
        source: "../Image/marker_found.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 2
        height: selectedCacheIconField.height / 3
        x: selectedCacheIconField.x + selectedCacheIconField.width/2
        y: selectedCacheIconField.y + selectedCacheIconField.height/2
    }

    Image {
        visible: selectedCache !== null ? selectedCache.toDoLog : false
        source: "../Image/not_logged.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 2
        height: selectedCacheIconField.height / 3
        x: selectedCacheIconField.x + selectedCacheIconField.width/2
        y: selectedCacheIconField.y + selectedCacheIconField.height/2
    }

    Image {
        visible: selectedCache !== null ? selectedCache.own : false
        source: "../Image/marker_own.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 2
        height: selectedCacheIconField.height / 3
        x: selectedCacheIconField.x + selectedCacheIconField.width/2
        y: selectedCacheIconField.y + selectedCacheIconField.height/2
    }

    Image {
        visible: selectedCache !== null ? selectedCache.registered : false
        source: "../Image/marker_save.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 1.2
        height: selectedCacheIconField.height / 2.2
        x: -0.1*selectedCacheIconField.x
        y: selectedCacheIconField.y
    }

    Text {
        id: selectedCacheNameField
        width: selectedCacheItem.width * 0.7
        anchors.margins: 7
        anchors.top: parent.top
        anchors.left: selectedCacheIconField.right
        font.family: localFont.name
        font.pointSize: parent.height * 0.15
        color: Palette.black()
        elide: Text.ElideRight
        clip: true
        text: selectedCache !== null ? selectedCache.name : ""
    }

    Text {
        id: selectedCacheGeocodeField
        width: selectedCacheItem.width / 3
        anchors.margins: 7
        anchors.top: selectedCacheNameField.bottom
        anchors.left: selectedCacheIconField.right
        font.family: localFont.name
        font.pointSize: parent.height * 0.14
        color: Palette.black()
        elide: Text.ElideRight
        clip: true
        text: selectedCache !== null ? selectedCache.geocode : ""
    }

    Text {
        id: selectedCacheSizeField
        anchors.topMargin: 7
        anchors.top: selectedCacheNameField.bottom
        x: selectedCacheItem.width * 0.5
        font.family: localFont.name
        font.pointSize: parent.height * 0.14
        color: Palette.black()
        clip: true
    }

    RaterField {
        id: selectedCacheDifficultyField
        visible: selectedCache !== null ? selectedCache.type !== "labCache" : false
        anchors.margins: 7
        anchors.top: selectedCacheGeocodeField.bottom
        anchors.left: parent.left
        ratingName: "Difficulté"
        ratingValue: selectedCache !== null ? selectedCache.difficulty : 0
        ratingTextPointSize: selectedCacheItem.height * 0.15
    }

    RaterField {
        id: selectedCacheTerrainField
        visible: selectedCache !== null ? selectedCache.type !== "labCache" : false
        anchors.margins: 7
        anchors.top: selectedCacheGeocodeField.bottom
        anchors.right: parent.right
        ratingName: "Terrain"
        ratingValue: selectedCache !== null ? selectedCache.terrain : 0
        ratingTextPointSize: selectedCacheItem.height * 0.15
    }

    MouseArea {
        id: cacheItemArea
        anchors.fill: parent
        onClicked: {
            if(fastList.state === "selectedInList" && viewState === "list") {
                selectedInList[index] = !selectedInList[index]
                selectedInList = getSelectedInList()
            } else {
                fullCache.geocode = selectedCache.geocode
                if(main.listState === "recorded" && selectedCache.registered === true){
                    previousViewState[0] = viewState
                    if(fullCache.geocode.substring(0,2) === "GC" )  //cache GC..
                        fullCacheRetriever.parseJson(sqliteStorage.readColumnJson("fullcache" , fullCache.geocode ))
                    else {
                        fullLabCacheRetriever.parseJson(sqliteStorage.readColumnJson("fullcache" , fullCache.geocode )) // lab cache
                    }
                } else {
                    if(fullCache.geocode.substring(0,2) === "GC" )  //cache GC..
                        fullCacheRetriever.sendRequest(connector.tokenKey)
                    else {
                        fullLabCacheRetriever.sendRequest(connector.tokenKey)  // lab cache
                    }
                }
                main.viewState = "fullcache"
            }
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
            latitude: selectedCache !== null ? selectedCache.lat : 0
            longitude: selectedCache !== null ? selectedCache.lon : 0
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
            anchors.margins: 4
            anchors.top: parent.top
            anchors.right: parent.right
            font.family: localFont.name
            font.pointSize: selectedCacheItem.height * 0.16
            color: Palette.black()
            clip: true
            text: selectedCache !== null ? Helper.formatDistance(Math.round(locationSource.distanceTo(QtPositioning.coordinate(selectedCache.lat,
                                                                                                                               selectedCache.lon)))) : ""
        }

        Image {
            id: smallCompassNeedle
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "../Image/Compass/compass_mini.png"

            Behavior on rotation { NumberAnimation { duration: 2000 } }
        }

        function updateRotation() {
            if (selectedCache === undefined)
                return
            if (locationSource === undefined)
                return
            smallCompassNeedle.rotation = - azimutDevice + locationSource.azimuthTo(selectedCacheLocation.coordinate)
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
        selectedCacheSizeField.text = "Taille: " + selectedCacheVar.size
        selectedCacheIconField.type = selectedCacheVar.typeIndex
        if (hideTimer.running)
            hideTimer.restart()
        opacity = 1
    }

    function hide() {
        hideTimer.start()
    }
}
