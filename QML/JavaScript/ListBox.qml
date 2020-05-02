import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Item {

    CheckBox {
        x:10
        checked:listCheckedBool(fullCache.geocode)[index]
        onClicked: {
            listChecked[index] = !listChecked[index]
        }
        contentItem: Text {
            text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
            font.family: localFont.name
            font.pointSize: 16
            color: checked ? Palette.white() : Palette.silver()
            verticalAlignment: Text.AlignVCenter
            leftPadding: indicator.width + spacing
        }
        indicator: Rectangle {
            implicitWidth: 25
            implicitHeight: 25
            radius: 3
            border.width: 1
            y: parent.height / 2 - height / 2
            Rectangle {
                anchors.fill: parent
                visible: checked
                color: Palette.greenSea()
                radius: 3
                anchors.margins: 4
            }
        }
    }
}
