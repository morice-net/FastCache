import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette
import "JavaScript/helper.js" as Helper
import com.mycompany.connecting 1.0

Rectangle {
    id: selectedCacheItem
    visible: opacity > 0 && !fastMap.compassMapButton
    radius: 10
    border.width: 2
    border.color: main.viewState === "map" ? Palette.greenSea() : Palette.silver()
    width: main.width - 40
    height: main.height * 0.12
    opacity: 0

    property var selectedCache: Cache {}

    AnimatedSprite {
        id: selectedCacheIconField

        property int type: 0

        running: false
        source: "qrc:/Image/cacheList.png"
        frameCount: 15
        currentFrame: type
        width: selectedCacheNameField.height + selectedCacheGeocodeField.height + 10
        height: width
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Image {
        visible: selectedCache !== null ? selectedCache.found : false
        source: "qrc:/Image/marker_found.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 2
        height: selectedCacheIconField.height / 3
        x: selectedCacheIconField.x + selectedCacheIconField.width/2
        y: selectedCacheIconField.y + selectedCacheIconField.height/2
    }

    Image {
        visible: selectedCache !== null ? selectedCache.toDoLog : false
        source: "qrc:/Image/not_logged.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 2
        height: selectedCacheIconField.height / 3
        x: selectedCacheIconField.x + selectedCacheIconField.width/2
        y: selectedCacheIconField.y + selectedCacheIconField.height/2
    }

    Image {
        visible: selectedCache !== null ? selectedCache.own : false
        source: "qrc:/Image/marker_own.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 2
        height: selectedCacheIconField.height / 3
        x: selectedCacheIconField.x + selectedCacheIconField.width/2
        y: selectedCacheIconField.y + selectedCacheIconField.height/2
    }

    Image {
        visible: selectedCache !== null ? selectedCache.registered : false
        source: "qrc:/Image/marker_save.png"
        fillMode: Image.PreserveAspectFit
        width: selectedCacheIconField.width / 1.2
        height: selectedCacheIconField.height / 2.2
        x: -0.1*selectedCacheIconField.x
        y: selectedCacheIconField.y
    }

    Text {
        id: selectedCacheNameField
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: selectedCacheIconField.right
        anchors.right: littleCompass.left
        font.family: localFont.name
        font.pointSize: parent.height * 0.08
        color: Palette.black()
        elide: Text.ElideRight
        text: selectedCache !== null ? selectedCache.name : ""
    }

    Text {
        id: selectedCacheGeocodeField
        anchors.margins: 10
        anchors.top: selectedCacheNameField.bottom
        anchors.left: selectedCacheIconField.right
        font.family: localFont.name
        font.pointSize: parent.height * 0.08
        color: Palette.black()
        clip: true
        text: selectedCache !== null ? selectedCache.geocode : ""
    }

    Text {
        id: selectedCacheSizeField
        anchors.topMargin: 10
        anchors.top: selectedCacheNameField.bottom
        x: selectedCacheItem.width * 0.5
        font.family: localFont.name
        font.pointSize: parent.height * 0.08
        color: Palette.black()
        clip: true
    }

    RaterField {
        id: selectedCacheDifficultyField
        anchors.margins: 10
        anchors.top: selectedCacheGeocodeField.bottom
        anchors.left: parent.left
        ratingName: "Difficulté"
        ratingValue: selectedCache !== null ? selectedCache.difficulty : 0
        ratingTextPointSize: selectedCacheItem.height * 0.075
    }

    RaterField {
        id: selectedCacheTerrainField
        anchors.margins: 10
        anchors.top: selectedCacheGeocodeField.bottom
        anchors.right: parent.right
        ratingName: "Terrain"
        ratingValue: selectedCache !== null ? selectedCache.terrain : 0
        ratingTextPointSize: selectedCacheItem.height * 0.075
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
                if(main.state === "recorded" && selectedCache.registered === true){
                    previousViewState[0] = viewState
                    fullCacheRetriever.parseJson(sqliteStorage.readObject("fullcache" , fullCache.geocode ))
                }else{
                    fullCacheRetriever.sendRequest(connector.tokenKey)
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
            anchors.margins: 5
            anchors.top: parent.top
            anchors.right: parent.right
            font.family: localFont.name
            font.pointSize: selectedCacheItem.height * 0.08
            color: Palette.black()
            clip: true
            text: selectedCache !== null ? Helper.formatDistance(Math.round(currentPosition.position.coordinate
                                                                            .distanceTo(QtPositioning.coordinate(selectedCache.lat,
                                                                                                                 selectedCache.lon)))) : ""
        }

        Image {
            id: smallCompassNeedle
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "qrc:/Image/Compass/compass_mini.png"
            width: sourceSize.width*1.8
            height: sourceSize.height*1.8

            Behavior on rotation { NumberAnimation { duration: 2000 } }
        }

        function updateRotation() {
            console.log("Updating small compass...")
            if (currentPosition == undefined)
                return
            smallCompassNeedle.rotation = -1*beginLocation.coordinate.azimuthTo(currentPosition.position.coordinate) +
                    currentPosition.position.coordinate.azimuthTo(selectedCacheLocation.coordinate)
            main.beginLat = currentPosition.position.coordinate.latitude;
            main.beginLon = currentPosition.position.coordinate.longitude;
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
