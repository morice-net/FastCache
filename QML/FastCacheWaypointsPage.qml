import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: waypointsPage

    Flickable {
        id: waypoints
        anchors.fill: parent
        anchors.topMargin: 50
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column{
            spacing:10
            width: waypointsPage.width
            clip:true

            Button {
                id:buttonAddWpt
                x:parent.width/3.5
                contentItem: Text {
                    text:"Ajouter une étape"
                    font.family: localFont.name
                    font.pixelSize: 50
                    color: Palette.white()
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    color: Palette.greenSea()
                    border.color: Palette.white()
                    border.width: 1
                    radius: 5
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        userWaypoint.open();
                    }
                }
            }

            Repeater{
                model:fullCache.wptsComment.length

                Column{
                    spacing: 10

                    Row{
                        x:15

                        Image{
                            source: "qrc:/Image/" +  main.waypointMarker(fullCache.wptsName[index])
                            scale: 2
                        }

                        Text {
                            text: main.waypointNameFr(fullCache.wptsName[index])
                            leftPadding: 15
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                        }
                    }

                    Text {
                        text: fullCache.wptsDescription[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 15
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Text {
                        visible: fullCache.wptsLat[index] >180  ? false : true
                        text: main.formatLat(fullCache.wptsLat[index]) + " " + main.formatLon(fullCache.wptsLon[index])
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.leftMargin: 10
                    }

                    Text {
                        width: waypointsPage.width
                        font.family: localFont.name
                        font.pointSize: 15
                        horizontalAlignment: TextEdit.AlignJustify
                        color: Palette.white()
                        textFormat: Qt.RichText
                        wrapMode: Text.Wrap
                        leftPadding: 15
                        rightPadding: 15
                        onLinkActivated: Qt.openUrlExternally(link)
                        text: fullCache.wptsComment[index]
                    }

                    Rectangle {
                        height: 1
                        width: waypointsPage.width
                        color: Palette.silver()
                    }
                }
            }

            Text {
                visible: fullCache.userWptsCode.length !== 0
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 16
                text: "ETAPES PERSONNELLES"
                color: Palette.silver()
            }

            Repeater{
                model:fullCache.userWptsCode.length

                Column{
                    spacing: 10

                    Text {
                        text: fullCache.userWptsCode[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 13
                        color: Palette.white()
                    }

                    Text {
                        visible: fullCache.userWptsLat[index] >180  ? false : true
                        text: main.formatLat(fullCache.userWptsLat[index]) + " " + main.formatLon(fullCache.userWptsLon[index])
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.leftMargin: 10
                    }

                    Text {
                        width: waypointsPage.width
                        visible: fullCache.userWptsDescription[index] === "" ? false : true
                        font.family: localFont.name
                        font.pointSize: 15
                        horizontalAlignment: TextEdit.AlignJustify
                        color: Palette.white()
                        textFormat: Qt.RichText
                        wrapMode: Text.Wrap
                        leftPadding: 15
                        rightPadding: 15
                        onLinkActivated: Qt.openUrlExternally(link)
                        text: fullCache.userWptsDescription[index]
                    }

                    Row {
                        x:waypointsPage.width/3
                        spacing: 40

                        Button {
                            id: uwDelete
                            contentItem : Text {
                                text: "Supprimer"
                                font.family: localFont.name
                                font.pointSize: 12
                                color: Palette.greenSea()
                            }
                            background: Rectangle {
                                border.width: uwDelete.activeFocus ? 2 : 1
                                border.color: Palette.silver()
                                radius: 4
                            }
                            onClicked:{
                                sendUserWaypoint.sendRequest(connector.tokenKey, fullCache.userWptsCode[index])
                                userWptIndex = index
                            }
                        }

                        Button {
                            id: uwUpdate
                            contentItem : Text {
                                text: "Modifier"
                                font.family: localFont.name
                                font.pointSize: 12
                                color: Palette.greenSea()
                            }
                            background: Rectangle {
                                border.width: uwUpdate.activeFocus ? 2 : 1
                                border.color: Palette.silver()
                                radius: 4
                            }

                            onClicked:{

                            }
                        }
                    }

                    Rectangle {
                        height: 1
                        width: waypointsPage.width
                        color: Palette.silver()
                    }
                }
            }
        }
    }
}
