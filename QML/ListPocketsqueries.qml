import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: pocketsqueries

        Column {
            id: rectangles
            spacing: 10

            Repeater {
                id: pqList
                model: getPocketsqueriesList.names.length

                Rectangle{
                    width: pocketsqueries.width
                    height: texts.height + 5
                    border.width: 2
                    border.color: Palette.greenSea()
                    radius: 8
                    color: Palette.white()

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pocketsqueries.visible = false
                            hideMenu()
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
                            font.pointSize: 15
                            color: Palette.greenSea()
                            wrapMode: Text.Wrap
                        }

                        Text {
                            width: pocketsqueries.width
                            text: new Date(getPocketsqueriesList.dates[index]).toLocaleDateString(Qt.locale("fr_FR"))
                            font.family: localFont.name
                            font.pointSize: 15
                            color: Palette.greenSea()
                        }

                        Text {
                            width: pocketsqueries.width
                            text: "Caches: " + getPocketsqueriesList.counts[index]
                            font.family: localFont.name
                            font.pointSize: 15
                            color: Palette.greenSea()
                        }

                        Text {
                            width: pocketsqueries.width
                            text: "Caches trouvées: " + getPocketsqueriesList.findCounts[index]
                            font.family: localFont.name
                            font.pointSize: 15
                            color: Palette.greenSea()
                        }
                    }
                }
            }
        }
    }


