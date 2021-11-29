import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions
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

        Column {
            spacing:10
            width: waypointsPage.width
            clip:true

            Button {
                id:buttonAddWpt
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text:"Ajouter une étape personnelle"
                    font.family: localFont.name
                    font.pixelSize: 35
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
                        userWptAdd = true;
                        userWaypoint.open();
                    }
                }
            }

            Repeater {
                model:fullCache.wptsComment.length

                Column {
                    spacing: 10

                    Row {
                        x:15

                        Image {

                            Binding on source {
                                when: true
                                value: fullCache.wptsIcon[index]
                            }
                            scale: 2
                        }

                        Text {

                            Binding on text {
                                when: true
                                value: fullCache.wptsName[index]
                            }
                            leftPadding: 15
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                        }
                    }

                    Text {

                        Binding on text {
                            when: true
                            value: fullCache.wptsDescription[index]
                        }
                        leftPadding: 15
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 15
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Text {
                        visible: fullCache.wptsLat[index] >180  ? false : true
                        text: Functions.formatLat(fullCache.wptsLat[index]) + " " + Functions.formatLon(fullCache.wptsLon[index])
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.leftMargin: 10
                    }

                    Row {

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: fullCache.wptsLat[index] >180  ? false : true
                            source: "qrc:/Image/Compass/compassIcon.png"
                            scale: 0.8

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    compassPageInit(fullCache.wptsName[index] , fullCache.wptsLat[index] , fullCache.wptsLon[index]);
                                    swipeToPage(compassPageIndex);
                                }
                            }
                        }

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: fullCache.wptsLat[index] >180  ? false : true
                            source: "qrc:/Image/mapsIcon.png"
                            scale: 0.7

                            MouseArea {
                                anchors.fill: parent
                                onClicked: fullCache.launchMaps(fullCache.wptsLat[index] , fullCache.wptsLon[index] )
                            }
                        }

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
                visible: fullCache.isCorrectedCoordinates
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 15
                text: "Coordonnées de la cache modifiées \n" + Functions.formatLat(fullCache.correctedLat) + "   " + Functions.formatLon(fullCache.correctedLon)
                color: Palette.silver()
            }

            Row {

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: fullCache.isCorrectedCoordinates
                    source: "qrc:/Image/Compass/compassIcon.png"
                    scale: 0.8

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            compassPageInit("Correction de coordonnées" , fullCache.correctedLat , fullCache.correctedLon);
                            swipeToPage(compassPageIndex);
                        }
                    }
                }

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: fullCache.isCorrectedCoordinates
                    source: "qrc:/Image/mapsIcon.png"
                    scale: 0.7

                    MouseArea {
                        anchors.fill: parent
                        onClicked: fullCache.launchMaps(fullCache.correctedLat , fullCache.correctedLon )
                    }
                }
            }

            Row {
                x:waypointsPage.width/3
                spacing: 40

                Button {
                    id: correctedDelete
                    visible: fullCache.isCorrectedCoordinates
                    contentItem : Text {
                        text: "Annuler"
                        font.family: localFont.name
                        font.pointSize: 12
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.width: correctedDelete.activeFocus ? 2 : 1
                        border.color: Palette.silver()
                        radius: 4
                    }
                    onClicked:{
                        //Delete modifications of coordinates
                        fastCache.deleteUserWpt = false
                        sendUserWaypoint.sendRequest(connector.tokenKey, fullCache.geocode)
                    }
                }

                Button {
                    id: correctedUpdate
                    visible: fullCache.isCorrectedCoordinates
                    contentItem : Text {
                        text: "Modifier"
                        font.family: localFont.name
                        font.pointSize: 12
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.width: correctedUpdate.activeFocus ? 2 : 1
                        border.color: Palette.silver()
                        radius: 4
                    }

                    onClicked: {
                        userWptAdd = false;
                        userCorrectedCoordinates = true;
                        userWaypoint.open();
                    }
                }
            }

            Rectangle {
                visible: fullCache.isCorrectedCoordinates
                height: 2
                width: waypointsPage.width
                color: Palette.silver()
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
                        text: Functions.formatLat(fullCache.userWptsLat[index]) + "   " + Functions.formatLon(fullCache.userWptsLon[index])
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 15
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.leftMargin: 10
                    }

                    Row {

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: fullCache.userWptsLat[index] >180  ? false : true
                            source: "qrc:/Image/Compass/compassIcon.png"
                            scale: 0.8

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    compassPageInit("Etape personnelle" , fullCache.userWptsLat[index] , fullCache.userWptsLon[index]);
                                    swipeToPage(compassPageIndex);
                                }
                            }
                        }

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: fullCache.userWptsLat[index] >180  ? false : true
                            source: "qrc:/Image/mapsIcon.png"
                            scale: 0.7

                            MouseArea {
                                anchors.fill: parent
                                onClicked: fullCache.launchMaps(fullCache.userWptsLat[index] , fullCache.userWptsLon[index])
                            }
                        }
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
                                //Delete userWaypoint
                                fastCache.deleteUserWpt = true
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

                            onClicked: {
                                userWptAdd = false;
                                userCorrectedCoordinates = false
                                userWptCode = fullCache.userWptsCode[index]
                                userWaypoint.open();
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
