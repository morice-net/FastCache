import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMenuHeader
    color: Palette.greenSea()
    width: parent.width
    height: parent.height * 0.08

    Image {
        id: menuIcon
        source: "qrc:/Image/menuIcon.png"
        y: parent.height*0.1
        x: y
        height: parent.height*0.8
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: fastMenu.showMenu()
        }
    }

    Rectangle {
        id: searchRectangle
        color: Palette.white().replace("#","#AA")
        radius: 3

        property int destWidth: parent.width * 0.75
        width: 0
        height: parent.height * 0.8
        y: parent.height * 0.1

        anchors.right: searchIcon.left
        anchors.margins: parent.width * 0.03

        TextInput {
            id: searchInput
            anchors.fill: parent
            font.pixelSize: height * 0.8
            font.family: localFont.name
            color: Palette.black()

            onAccepted: search(text)

        }

        Rectangle {
            color: Palette.turquoise()
            radius: 10
            height: searchInput.height * 0.8
            width: height
            visible: searchInput.width > 0
            anchors.margins: 5
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Image {
                source: "qrc:/Image/filter.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                anchors.margins: 5
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Filter clicked")
                    cacheFilter.activate()
                }
            }
        }

        Behavior on width { NumberAnimation { duration: 500 } }

    }

    Image {
        id: searchIcon
        source: "qrc:/Image/magnifying-glass.png"
        y: parent.height * 0.3
        x: parent.width - width - y
        height: parent.height*0.4
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: activateSearch()
        }
    }

    CacheFilter {
        id: cacheFilter
    }

    function search(searchText) {

    }

    function activateSearch() {
        searchRectangle.width = searchRectangle.destWidth
        searchRectangle.forceActiveFocus()
    }

    function unactivateSearch() {
        searchRectangle.width = 0
    }
}
