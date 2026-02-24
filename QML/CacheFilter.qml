import QtQuick

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {
    id: cacheFilter
    anchors.fill: parent  
    opacity: 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 600 } }
    Behavior on width { NumberAnimation { duration: 600 } }
    Behavior on height { NumberAnimation { duration: 600 } }

    Rectangle {
        id: filtersRectangle
        anchors.fill: parent
        color: Palette.white()
        opacity: 0.9

        Text {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 15
            font.family: localFont.name
            font.pointSize: 20
            verticalAlignment: Text.AlignLeft
            horizontalAlignment: Text.AlignHCenter
            color: Palette.greenSea()
            text: "  Filtrer les caches par :"
        }

        Rectangle {
            id: rectangleImage
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 12
            height: filtersRectangle.width * 0.09
            width: height
            radius: 10
            color: Palette.turquoise()

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: "../Image/update-arrows.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Functions.reloadCachesBBox()
                    Functions.reloadCachesNear()
                    cacheFilter.opacity = 0
                }
            }
        }

        Filters {
            id: filters
            anchors.top: rectangleImage.bottom
            anchors.topMargin: 5
        }
    }    
    onVisibleChanged: recordCacheFiltersInSettings()

    function recordCacheFiltersInSettings() {
        filters.recordFiltersInSettings()
    }
}
