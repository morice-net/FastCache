import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: selectedCacheItem
    property string geocode
    property int size
    property double difficulty
    property double terrain
    
    color: Palette.white().replace("#","#99")
    radius: parent.width/30
    border.width: 2
    border.color: Palette.greenSea()
    
    width: parent.width - 40
    height: parent.height * 0.12
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 20
    
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
    
    RaterField {
        id: selectedCacheSizeField
        anchors.margins: 10
        anchors.top: selectedCacheNameField.bottom
        anchors.left: selectedCacheTerrainField.left

        ratingName: "Taille"
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

    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 5
        color: Palette.white()
        border.color: Palette.turquoise()
        border.width: 1
        height: selectedCacheItem.height / 4.5
        width: height
        radius: width / 2
        Text {
            anchors.centerIn: parent
            text: "x"
            color: Palette.turquoise()
        }
        MouseArea {
            anchors.fill: parent
            onClicked: selectedCacheItem.opacity = 0
        }
    }

    Behavior on opacity { NumberAnimation { duration: 250 } }

    function show(selectedCache) {
        selectedCacheNameField.text = selectedCache.name
        selectedCacheGeocadeField.text = selectedCache.geocode
        selectedCacheSizeField.ratingValue = Math.floor((selectedCache.size + 1)/2)
        selectedCacheDifficultyField.ratingValue = Math.floor(selectedCache.difficulty)
        selectedCacheTerrainField.ratingValue = Math.floor(selectedCache.terrain)
        selectedCacheIconField.type = cacheMarkerId(selectedCache.type)
        opacity = 1
    }
}
