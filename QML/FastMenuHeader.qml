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

    Rectangle {
        id: settingsMenu
        visible: !fastMap.compassMapButton
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.top: parent.top
        anchors.left: menu.right

        Image {
            id: settingsIcon
            source: "../Image/settings.png"
            y: parent.height * 0.1
            x: y
            height: parent.height * 0.8
            width: height

            MouseArea {
                anchors.fill: parent
                onClicked: userSettings.showMenu()
            }
        }
    }

    Rectangle {
        visible: !fastMap.compassMapButton
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.top: parent.top
        anchors.left: settingsMenu.right

        Image {
            id: satelliteIcon
            source: "../Image/satellite.png"
            y: parent.height * 0.1
            x: y
            height: parent.height * 0.8
            width: height

            MouseArea {
                anchors.fill: parent
                onClicked: satelliteInfo.showMenu()
            }
        }
    }

    // Filters
    Rectangle {
        id: filter
        visible:(!fastMap.compassMapButton) && ((main.viewState === "map" || main.viewState === "list") && fastList.state === "") ||
                (main.viewState === "map" && fastList.state === "selectedInList")
        color: cacheFilter.opacity > 0 ? Palette.turquoise() : Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top

        Image {
            source: "../Image/filter.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: changeFiltersVisibility()
        }
    }

    // list sort
    BoxSorting {
        id: groupBoxSorting
        visible: false
    }

    Rectangle {
        visible: main.viewState !== "fullcache" && viewState === "list"
        color: cacheFilter.opacity > 0 ? Palette.turquoise() : Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.right:  filter.left
        anchors.top: parent.top

        Image {
            source: "../Image/sort_alphabetically.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
            scale:1.4
        }

        MouseArea {
            anchors.fill: parent
            onClicked: groupBoxSorting.visible = !groupBoxSorting.visible
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

    // Storage
    Rectangle {
        id: storageHeartButton
        visible: main.viewState === "fullcache" && fullCacheRetriever.state !== "loading"
        color: cacheFilter.opacity > 0 ? Palette.turquoise() : Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top

        Image {
            anchors.fill: parent
            source: "../Image/saved-on.png"
            scale: 0.7
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter

            Image {
                anchors.fill: parent
                visible: !fullCache.registered
                source: "../Image/saved-off.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                cachesRecordedLists.x = (main.width - cachesRecordedLists.width) /2
                cachesRecordedLists.y = storageHeartButton.height + 10
                cachesRecordedLists.open()
            }
        }
    }

    CacheFilter { id: cacheFilter }

    function isFiltersVisible() {
        return cacheFilter.visible
    }

    function changeFiltersVisibility() {
        cacheFilter.opacity = 1 - cacheFilter.opacity
    }

    function recordInSettings() {
        cacheFilter.recordCacheFiltersInSettings()
    }

    function clearBoxSorting() {
        groupBoxSorting.visible = false
    }
}
