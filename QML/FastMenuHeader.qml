import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: fastMenuHeader
    anchors.fill: parent

    // Menu caller
    Rectangle {
        id: menu
        visible: !fastMap.compassMapButton
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.left: parent.left
        anchors.top: parent.top

        Image {
            id: menuIcon
            source: "../Image/menuIcon.png"
            y: parent.height * 0.1
            x: y
            height: parent.height * 0.8
            width: height

            MouseArea {
                anchors.fill: parent
                onClicked: fastMenu.showMenu()
            }
        }
    }

    // Recorded list icon selected
    Rectangle {
        visible: fastList.state === "selectedInList" && viewState === "list"
        color: cacheFilter.opacity > 0 ? Palette.turquoise() : Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top

        Image {
            source: "../Image/marker_save.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
            scale:1.4
        }

        MouseArea {
            anchors.fill: parent
            onClicked: cachesRecordedLists.open()
        }
    }


    CacheFilter { id: cacheFilter }

    function isFiltersVisible() {
        return cacheFilter.visible
    }

    function recordInSettings() {
        cacheFilter.recordCacheFiltersInSettings()
    }

    function changeFiltersVisibility() {
        cacheFilter.opacity = 1 - cacheFilter.opacity
    }

    function menuIconHeight() {
        return menuIcon.height / 2
    }
}
