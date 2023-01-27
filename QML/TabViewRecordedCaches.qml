import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

TabBar {
    id: bar
    width: parent.width
    x:3
    y: parent.height * 0.07

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
                font.pointSize: 20
                color: tabButton.checked ? Palette.white() : Palette.silver()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                color: tabButton.checked ? Palette.turquoise() : Palette.greenSea()
                border.color:  Palette.turquoise()
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

