import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

TabBar {
    id: bar
    width: parent.width
    x:3
    y: parent.height * 0.07

    Repeater {
        model: sqliteStorage.countLists
        TabButton {
            id: tabButton
            onClicked: {
                fastMap.clearMap()
                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[bar.currentIndex])
                // center and zoom level
                centerMapCaches(cachesRecorded.caches)
            }
            width: Math.max(100, bar.width / sqliteStorage.countLists)
            contentItem: Text {
                text: sqliteStorage.readAllStringsFromTable("lists")[index]
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
}

