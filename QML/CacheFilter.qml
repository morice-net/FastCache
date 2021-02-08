import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: cacheFilter
    anchors.fill: parent
    anchors.topMargin: 40
    anchors.bottomMargin: anchors.topMargin/2
    anchors.rightMargin: anchors.topMargin/3
    anchors.leftMargin: anchors.topMargin/3
    opacity: 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 300 } }
    Behavior on width { NumberAnimation { duration: 300 } }
    Behavior on height { NumberAnimation { duration: 300 } }

    Rectangle {
        id: filtersRectangle
        anchors.fill: parent
        color: Palette.white().replace("#","#99")
        radius: parent.width/20
        border.width: 2
        border.color: Palette.greenSea()
        anchors.top: filterHeadArrow.bottom

        Row {

            Text {
                y: 10
                font.family: localFont.name
                font.pointSize: 24
                verticalAlignment: Text.AlignLeft
                horizontalAlignment: Text.AlignLeft
                color: Palette.greenSea()
                text: "  Filtrer les caches par :     "
            }

            Rectangle {
                id: rectangleImage
                y: 13
                height: filtersRectangle.width * 0.1
                width: height
                radius: 10
                color: Palette.turquoise()

                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "qrc:/Image/update-arrows.png"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        reloadCaches()
                        cacheFilter.opacity = 0
                    }
                }
            }
        }

        Filters {
            id: filters
            y: rectangleImage.y + rectangleImage.height/3

            Behavior on width { NumberAnimation { duration: 300 } }
            Behavior on height { NumberAnimation { duration: 300 } }
        }
    }

    Image {
        id: filterHeadArrow
        source: "qrc:/Image/filterHeadArrow.png"
        anchors.right: parent.right
        anchors.bottom: parent.top
    }
    onVisibleChanged: recordCacheFiltersInSettings()

    function recordCacheFiltersInSettings() {
        filters.recordFiltersInSettings()
    }
}
