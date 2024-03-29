import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

TabBar {
    id: bar
    width: parent.width * 0.98
    anchors.horizontalCenter: parent.horizontalCenter
    y: parent.height * 0.07
    Material.accent: Palette.black()

    Repeater {
        model: modelList()

        TabButton {
            id: tabButton
            onClicked: {
                fastMap.clearMap()
                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[bar.currentIndex])
                // center and zoom level
                Functions.centerMapCaches(cachesSingleList.caches)
            }
            width: Math.max(100, bar.width / sqliteStorage.countLists)
            contentItem: Text {
                text: modelData
                font.family: localFont.name
                font.pointSize: 18
                color: tabButton.checked ? Palette.white() : Palette.silver()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                color: tabButton.checked ? Palette.turquoise() : Palette.greenSea()
                radius: 4
            }
        }
    }

    function modelList() {
        var list = sqliteStorage.readAllStringsFromTable("lists")
        var createList = []
        for (var i = 0; i < sqliteStorage.countLists; i++) {
            createList.push(list[i])
        }
        return createList
    }
}

