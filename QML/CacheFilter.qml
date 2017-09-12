import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: cacheFilter
    anchors.top: parent.bottom
    x: parent.width * 0.1
    opacity: 0

    Behavior on opacity { NumberAnimation { duration: 500 } }
    Behavior on width { NumberAnimation { duration: 500 } }
    Behavior on height { NumberAnimation { duration: 500 } }

    property var favouriteCacheType: [9,8,7,2]
    property var otherCacheType: [0,1,3,4,5,6,10,11,12,13]

    Rectangle {
        id: filtersRectangle
        x: 5
        y: 5
        color: Palette.white().replace("#","#AA")
        radius: 3
        border.width: 2
        border.color: Palette.greenSea()

        property int destWidth: parent.width * 0.75
        width: parent.width
        height: main.height * 0.4
        anchors.top: filterHeadArrow.bottom
        anchors.margins: -2

        Column {

            Text {
                width: filtersRectangle.width
                font.family: localFont.name
                font.pointSize: 24
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Palette.greenSea()
                text: "Filtres"
            }


            Filters {
                id: typeFilter
            }
        }
    }

    Image {
        id: filterHeadArrow
        source: "qrc:/Image/filterHeadArrow.png"
        anchors.right: parent.right
    }


    onOpacityChanged: {
        visible = opacity > 0 ? true : false
    }

    function activate() {
        if (cacheFilter.width == 0) {
            show()
        } else {
            hide()
        }
    }

    function show() {
        cacheFilter.width = parent.width * 0.8
        cacheFilter.height = filtersRectangle.height + filterHeadArrow.height
        cacheFilter.opacity = 1
    }

    function hide() {
        cacheFilter.width = 0
        cacheFilter.height = 0
        cacheFilter.opacity = 0
    }

}
