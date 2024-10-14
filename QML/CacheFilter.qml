import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {
    id: cacheFilter
    anchors.fill: parent
    anchors.topMargin: 40
    anchors.bottomMargin: anchors.topMargin/2
    anchors.rightMargin: anchors.topMargin/3
    anchors.leftMargin: anchors.topMargin/3
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
        radius: parent.width/20
        border.width: 2
        border.color: Palette.greenSea()
        anchors.top: filterHeadArrow.bottom

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

    Image {
        id: filterHeadArrow
        source: "../Image/filterHeadArrow.png"
        anchors.right: parent.right
        anchors.bottom: parent.top
    }
    onVisibleChanged: recordCacheFiltersInSettings()

    function recordCacheFiltersInSettings() {
        filters.recordFiltersInSettings()
    }
}
