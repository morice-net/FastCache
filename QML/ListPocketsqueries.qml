import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Item {
    id: pocketsqueries

    MouseArea {
        anchors.fill: parent
        onClicked: {
            fastMenuLevel2.x = 0
            pocketsqueries.x  = -parent.width
        }

        ScrollView {
            clip: true
            height: Math.min(parent.height*0.7 , rectangles.height)

            Column {
                id: rectangles
                spacing: 10

                Rectangle {
                    width: pocketsqueries.width
                    height: 50
                    radius: 8
                    color: Palette.turquoise()

                    Text {
                        text: "Pockets queries enregistrées : " + getPocketsqueriesList.names.length
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 17
                        color: Palette.white()
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter:  parent.horizontalCenter
                    }
                }

                Repeater {
                    id: pqList
                    model: getPocketsqueriesList.names.length

                    Rectangle{
                        width: pocketsqueries.width
                        height: texts.height
                        border.width: 1
                        border.color: Palette.silver()
                        radius: 8
                        color: Palette.turquoise()

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                main.cachesActive = false
                                main.state = "pocketQuery"
                                cachesPocketqueries.indexMoreCaches = 0
                                cachesPocketqueries.sendRequest(connector.tokenKey , getPocketsqueriesList.referenceCodes[index])
                                fastMenuLevel1.x = 0
                                pocketsqueries.x  = -parent.width
                                hideMenu()
                            }
                        }

                        Column {
                            id: texts
                            topPadding: 10
                            leftPadding: 10

                            Text {
                                clip: true
                                width: pocketsqueries.width
                                text: getPocketsqueriesList.names[index]
                                font.family: localFont.name
                                textFormat: Qt.RichText
                                font.bold: true
                                font.pointSize: 15
                                color: Palette.white()
                                wrapMode: Text.Wrap
                            }

                            Text {
                                width: pocketsqueries.width
                                text: new Date(getPocketsqueriesList.dates[index]).toLocaleDateString(Qt.locale("fr_FR"))
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 14
                                color: Palette.silver()
                            }

                            Text {
                                width: pocketsqueries.width
                                text: "Nombre de caches: " + getPocketsqueriesList.counts[index]
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 14
                                color: Palette.silver()
                            }

                            Text {
                                width: pocketsqueries.width
                                text: "Nombre de caches trouvées: " + getPocketsqueriesList.findCounts[index]
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 14
                                color: Palette.silver()
                            }
                        }
                    }
                }
            }
        }
    }
}
