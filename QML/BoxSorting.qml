import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: groupBoxSorting
    x: parent.width/3
    y:parent.height/8

    property list <string> textList: ["Tri par Géocode" , "Tri par Nom" , "Tri par Type", "Tri par Taille" , "Tri par Difficulté" ,"Tri par Terrain" ,
        "Tri par Distance"]
    property list <int> checkedList: [main.sortGeocode , main.sortName , main.sortType , main.sortSize , main.sortDifficulty , main.sortTerrain ,
        main.sortDistance]

    GroupBox {
        id:control
        background: Rectangle {
            y: control.topPadding - control.bottomPadding
            width: parent.width
            height: parent.height - control.topPadding + control.bottomPadding
            color: Palette.turquoise()
            radius: 10
        }

        Column {

            Repeater {
                model: textList.length

                RadioButton {
                    id:button
                    text: textList[index]
                    checked: main.sortingBy === checkedList[index]
                    onClicked: {
                        groupBoxSorting.visible = false
                        main.sortingBy = checkedList[index]
                    }
                    contentItem: Text {
                        text: button.text
                        font.family: localFont.name
                        font.pointSize: 16
                        color: button.checked ? Palette.white() : Palette.silver()
                        leftPadding: button.indicator.width + button.spacing
                        verticalAlignment: Text.AlignVCenter
                    }
                    indicator: Rectangle {
                        y: parent.height / 2 - height / 2
                        implicitWidth: 25
                        implicitHeight: 25
                        radius: 10
                        border.width: 1
                        Rectangle {
                            anchors.fill: parent
                            visible: button.checked
                            color: Palette.greenSea()
                            radius: 10
                            anchors.margins: 4
                        }
                    }
                }
            }
        }
    }
}
