import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

TabBar {
    id: bar
    width: parent.width
    y: parent.height * 0.07

    Repeater {
        model: sqliteStorage.countLists

        TabButton {
            id: tabButton
            text: sqliteStorage.readAllStringsFromTable("lists")[index]
            width: Math.max(100, bar.width / sqliteStorage.countLists)
            background: Rectangle {
                color: tabButton.checked ? Palette.turquoise() : Palette.greenSea()
                border.color:  Palette.turquoise()
                radius: 4
                Text {
                    id: text
                    anchors.centerIn: parent
                    color: tabButton.checked ? Palette.white()  : Palette.silver()
                }
            }
        }
    }
}

