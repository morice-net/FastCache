import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: fastMenuHeader
    anchors.fill: parent
    // Menu caller

    Rectangle {
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.left: parent.left
        anchors.top: parent.top

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
    }

    // Filters
    Rectangle {
        visible: main.viewState !== "fullcache"
        color: cacheFilter.opacity > 0 ? Palette.turquoise() : Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.05
        width: height
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top

        Image {
            source: "qrc:/Image/filter.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: changeFiltersVisibility()
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
            source: fullCache.registered ? "qrc:/Image/heart-on.png" : "qrc:/Image/heart-off.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                cachesRecordedLists.x = main.width - cachesRecordedLists.width - storageHeartButton.width
                cachesRecordedLists.y = storageHeartButton.height
                cachesRecordedLists.open()
            }
        }
    }

    CachesRecordedLists {
        id: cachesRecordedLists
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
}
