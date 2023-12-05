import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Column {
    id: columnCircle
    spacing: 20

    property var circleNames: ["Cerles autour des caches" , "Cercle (rayon en km) "]
    property var checkedButton: [settings.circlesCaches , settings.circleMap]

    Switch {
        id: button
        visible: true
        text: circleNames[index]
        checked: checkedButton[index]
        onClicked: clickedButton(index)
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

    function clickedButton(index) {
        if(index === 0 ) {
            settings.circlesCaches = !settings.circlesCaches
            fastMap.clearMap()
            addCachesOnMap()
        }
        else if(index === 1 ) {
            settings.circleMap = !settings.circleMap
            fastMap.mapItem.deleteCircleRadius()
            if(settings.circleMap && distance.text !== "")
                fastMap.mapItem.createCircleRadius(settings.circleMapRadius)
        }
    }
}


