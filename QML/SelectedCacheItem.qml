import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

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
    
    AnimatedSprite {
        id: selectedCacheIconField
        property int type: 0
        paused: true
        source: "qrc:/Image/cacheList.png"
        frameCount: 15
        currentFrame: type % 15
        width: selectedCacheNameField.height + selectedCacheGeocadeField.height + 10
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
    }
    
    Text {
        id: selectedCacheGeocadeField
        anchors.margins: 10
        anchors.top: selectedCacheNameField.bottom
        anchors.left: selectedCacheIconField.right
        font.family: localFont.name
        font.pixelSize: parent.height * 0.15
        color: Palette.black()
        clip: true
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
        anchors.top: selectedCacheGeocadeField.bottom
        anchors.left: parent.left

        ratingName: "Difficulté"
    }
    
    RaterField {
        id: selectedCacheTerrainField
        anchors.margins: 10
        anchors.top: selectedCacheGeocadeField.bottom
        anchors.left: selectedCacheDifficultyField.right

        ratingName: "Terrain"
    }

    Timer {
        id: hideTimer
        interval: 3200
        onTriggered: selectedCacheItem.opacity = 0
    }

    Behavior on opacity { NumberAnimation { duration: 250 } }

    function show(selectedCacheVar) {
        if (!selectedCacheVar)
            return;

        selectedCacheNameField.text = selectedCacheVar.name
        selectedCacheGeocadeField.text = selectedCacheVar.geocode

        // Size rounding
        selectedCacheSizeField.text = "Taille: ??? "
        for (var i = 0; i < cacheSizes.sizes.length; i++) {
            if(cacheSizes.sizes[i].sizeIdGs === selectedCacheVar.size ){
                selectedCacheSizeField.text = "Taille: " + cacheSizes.sizes[i].sizeId
                break;
            }
        }

        selectedCacheDifficultyField.ratingValue = selectedCacheVar.difficulty
        selectedCacheTerrainField.ratingValue = selectedCacheVar.terrain
        selectedCacheIconField.type = cacheMarkerId(selectedCacheVar.type)
        if (hideTimer.running)
            hideTimer.restart()

        opacity = 1
    }

    function hide() {
        hideTimer.start()
    }
}
