import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Column {
    id: columnMaps
    spacing: 20

    property var mapNames: ["Open Street Map" , "Google Maps : plan" , "Google Maps : satellite" , "Cyclo OSM"]
    property var folders: [tilesDownloader.dirOsm , tilesDownloader.dirGooglemaps , tilesDownloader.dirGooglemaps , tilesDownloader.dirCyclOsm]
    property var sats: [false , false , true , false]

    RadioButton {
        id: button
        visible: true
        text: mapNames[index]
        checked: settings.namePlugin === pluginName(index) && settings.sat === sats[index]
        onClicked: {
            settings.sat = sats[index]
            if(settings.namePlugin !== pluginName(index)) {
                updateMap(index)
            }
        }
        contentItem: Text {
            text: button.text
            font.family: localFont.name
            font.pointSize: 16
            color: button.checked ? Palette.greenSea() : Palette.silver()
            leftPadding: button.indicator.width + button.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 25
            implicitHeight: 25
            radius: 10
            border.width: 1

            Rectangle {
                anchors.fill: parent
                visible: button.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    ButtonTiles {
        anchors.top: button.bottom
        folderTiles: folders[index]
        satTiles: sats[index]
        Component.onCompleted: tilesDownloader.dirSizeFolder(folders[index] , sats[index])
    }

    function pluginName(index) {
        if(index === 0 )
            return settings.listPlugins[0]
        if(index === 1 )
            return settings.listPlugins[1]
        if(index === 2 )
            return settings.listPlugins[1]
        if(index === 3 )
            return settings.listPlugins[2]
    }

    function updateMap(index) {
        var indexList
        var center = fastMap.mapItem.center
        if(index === 0 )
            indexList = 0
        else if(index === 1)
            indexList = 1
        else if(index === 2)
            indexList = 1
        else if(index === 3)
            indexList = 2
        fastMap.deleteMap()
        settings.namePlugin = settings.listPlugins[indexList]
        fastMap.createMap()
        fastMap.mapItem.center = center
        addCachesOnMap()
    }
}

