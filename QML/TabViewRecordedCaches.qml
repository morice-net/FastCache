import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

TabBar {
    id: bar
    width: parent.width
    y: parent.height * 0.07
    onCurrentIndexChanged: {
        cachesRecorded.updateListCachesRecorded(bar.currentIndex + 1)
        centerMapCachesRecorded()
    }

    Repeater {
        model: sqliteStorage.countLists
        TabButton {
            id: tabButton
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

