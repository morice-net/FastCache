import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: selectableFilter
    width: parent.width
    height: 60
    property bool filterSelected: false
    property string filterText: ""

    Row {
        spacing: selectableFilter.width / 2 - 100
        width: searchRectangle.width

        Text {
            text: " " + selectableFilter.filterText
            font.family: localFont.name
            font.pointSize: 22
            color: filterSelected ? Palette.greenSea() : Palette.silver()
            width: selectableFilter.width/2

        }

        Rectangle {
            color: filterSelected ? Palette.greenSea() : Palette.silver()
            radius: height/2
            height: 20
            width: 80
            border.width: 1
            border.color: Palette.backgroundGrey()

            Rectangle {
                color: filterSelected ? Palette.greenSea() : Palette.silver()
                x: filterSelected ? parent.width/2 : 0
                radius: height/2
                height: 40
                width: 40
                border.width: 1
                border.color: Palette.backgroundGrey()
                anchors.verticalCenter: parent.verticalCenter

                Behavior on x { NumberAnimation { duration: 500 } }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: filterSelected = ! filterSelected
            }
        }
    }
}
