import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Item {
    id: pocketsqueries

    Column {

        Button {
            id: buttonGoback
            icon.source: "qrc:/Image/goback.png"
            icon.width: 50
            icon.height: 50
            leftPadding: 20
            anchors.top: nearButtonMenu.bottom
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
            height: 50
            color: "transparent"

            Text {
                text: "Pockets queries enregistrées : " + getPocketsqueriesList.names.length
                font.family: localFont.name
                font.bold: true
                font.pointSize: 17
                color: Palette.greenSea()
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter:  parent.horizontalCenter
            }
        }
    }

    ScrollView {
        y: buttonGoback.height + title.height + 10
        clip: true
        height: Math.min(parent.height*0.7 , rectangles.height)

        Column {
            id: rectangles
            spacing: 10

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
                            hideMenu()
                            pocketsqueries.x  = -parent.width
                            fastMenuLevel1.x = 0
                            main.state = "pocketQuery"
                            cachesPocketqueries.indexMoreCaches = 0
                            cachesPocketqueries.sendRequest(connector.tokenKey , getPocketsqueriesList.referenceCodes[index])
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

