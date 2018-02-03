import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: cacheFilter
    anchors.fill: parent
    anchors.topMargin: 80
    anchors.bottomMargin: 20
    anchors.rightMargin: 20
    anchors.leftMargin: 20

    opacity: 0
    visible: opacity > 0

    Behavior on opacity { NumberAnimation { duration: 400 } }
    Behavior on width { NumberAnimation { duration: 400 } }
    Behavior on height { NumberAnimation { duration: 400 } }

    Rectangle {
        id: filtersRectangle
        anchors.fill: parent
        color: Palette.white().replace("#","#99")
        radius: 3
        border.width: 2
        border.color: Palette.greenSea()

        property int destWidth: parent.width * 0.75
        width: parent.width
        height: filterColumn.height//main.height * 0.4
        anchors.top: filterHeadArrow.bottom
        anchors.margins: -2

        Column {
            id: filterColumn
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
                Behavior on width { NumberAnimation { duration: 400 } }
                Behavior on height { NumberAnimation { duration: 400 } }
            }
        }
    }

    Image {
        id: filterHeadArrow
        source: "qrc:/Image/filterHeadArrow.png"
        anchors.right: parent.right
        anchors.bottom: parent.top
    }

}
