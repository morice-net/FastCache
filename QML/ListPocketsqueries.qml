import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: pocketsqueries

    Column {

        Button {
            id: buttonGoback
            icon.source: "../Image/goback.png"
            icon.width: 40
            icon.height: 30
            leftPadding: 20
            onClicked:{
                openMenu = 3
                pocketsqueries.x  = -parent.width
            }
            background: Rectangle {
                color: "transparent"
            }
        }

        Rectangle {
            id: title
            width: pocketsqueries.width
            height: 40
            color: "transparent"

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter:  parent.horizontalCenter
                text: "Pockets queries enregistrées : " + getPocketsqueriesList.names.length
                font.family: localFont.name
                font.bold: true
                font.pointSize: 17
                color: Palette.greenSea()
            }
        }
    }

    ScrollView {
        y: buttonGoback.height + title.height + 5
        clip: true
        height: Math.min(parent.height * 0.7 , rectangles.height)

        Column {
            id: rectangles
            spacing: 10

            Repeater {
                id: pqList
                model: getPocketsqueriesList.names.length

                Rectangle{
                    width: pocketsqueries.width
                    height: texts.height + 5
                    border.width: 3
                    border.color: Palette.silver()
                    radius: 8
                    color: Palette.turquoise()

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            pocketsqueries.x  = -parent.width
                            fastMenuLevel1.x = 0
                            main.listState = "pocketQuery"
                            cachesPocketqueries.indexMoreCaches = 0
                            cachesPocketqueries.sendRequest(connector.tokenKey , getPocketsqueriesList.referenceCodes[index])
                        }
                    }

                    Column {
                        id: texts
                        topPadding: 10
                        leftPadding: 20

                        Text {
                            clip: true
                            width: pocketsqueries.width
                            text: getPocketsqueriesList.names[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.bold: true
                            font.pointSize: 16
                            color: Palette.white()
                            wrapMode: Text.Wrap
                        }

                        Text {
                            width: pocketsqueries.width
                            text: new Date(getPocketsqueriesList.dates[index]).toLocaleDateString(Qt.locale("fr_FR"))
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.silver()
                        }

                        Text {
                            width: pocketsqueries.width
                            text: "Nombre de caches: " + getPocketsqueriesList.counts[index]
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.silver()
                        }

                        Text {
                            width: pocketsqueries.width
                            text: "Nombre de caches trouvées: " + getPocketsqueriesList.findCounts[index]
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.silver()
                        }
                    }
                }
            }
        }
    }
}

