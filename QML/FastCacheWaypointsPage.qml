import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: waypointsPage

    property bool formatCoordinatesWaypoint: true
    property bool formatCoordinatesCorrectedCoordinates: true
    property bool formatCoordinatesUserWaypoint: true

    Flickable {
        id: waypoints
        anchors.fill: parent
        anchors.topMargin: fastCacheHeaderIcon.height * 1.3
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column {
            spacing:10
            width: waypointsPage.width
            clip:true

            FastButton {
                id:buttonAddWpt
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 18
                text:"Ajouter une étape personnelle"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        userWptAdd = true;
                        userWaypoint.open();
                    }
                }
            }

            // list of waypoints
            Text {
                visible: fullCache.wptsComment.length !== 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 15
                text: "ÉTAPES"
                color: Palette.black()
            }

            Repeater {
                model:fullCache.wptsComment.length

                Column {
                    spacing: 5

                    Row {
                        leftPadding: 15

                        Image {

                            Binding on source {
                                when: true
                                value: fullCache.wptsIcon[index]
                            }
                            scale: 1.5
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
                        text: formatLatText(formatCoordinatesWaypoint , fullCache.wptsLat[index]) + "  ,   " +
                              formatLonText(formatCoordinatesWaypoint , fullCache.wptsLon[index])
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.leftMargin: 10

                        MouseArea {
                            anchors.fill: parent
                            onClicked: formatCoordinatesWaypoint = !formatCoordinatesWaypoint
                        }
                    }

                    Row {

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: fullCache.wptsLat[index] >180  ? false : true
                            source: "qrc:/Image/Compass/compassIcon.png"
                            scale: 0.6

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
                            scale: 0.5

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

            // correction of coordinates
            Text {
                visible: fullCache.isCorrectedCoordinates
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 15
                text: "COORDONNÉES MODIFIÉES"
                color: Palette.black()
            }

            Text {
                visible: fullCache.isCorrectedCoordinates
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 13
                text: formatLatText(formatCoordinatesCorrectedCoordinates , fullCache.correctedLat) + "  ,   " +
                      formatLonText(formatCoordinatesCorrectedCoordinates , fullCache.correctedLon)
                color: Palette.silver()

                MouseArea {
                    anchors.fill: parent
                    onClicked: formatCoordinatesCorrectedCoordinates = !formatCoordinatesCorrectedCoordinates
                }
            }

            Row {

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: fullCache.isCorrectedCoordinates
                    source: "qrc:/Image/Compass/compassIcon.png"
                    scale: 0.6

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
                    scale: 0.5

                    MouseArea {
                        anchors.fill: parent
                        onClicked: fullCache.launchMaps(fullCache.correctedLat , fullCache.correctedLon )
                    }
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 40

                FastButton {
                    id: correctedDelete
                    visible: fullCache.isCorrectedCoordinates
                    font.pointSize: 18
                    text: "Annuler"
                    onClicked:{
                        //Delete modifications of coordinates
                        fastCache.deleteUserWpt = false
                        sendUserWaypoint.sendRequest(connector.tokenKey, fullCache.geocode)
                    }
                }

                FastButton {
                    id: correctedUpdate
                    visible: fullCache.isCorrectedCoordinates
                    text: "Modifier"
                    font.family: localFont.name
                    font.pointSize: 18
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

            // list of user waypoints
            Text {
                visible: fullCache.userWptsCode.length !== 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 15
                text: "ÉTAPES PERSONNELLES"
                color: Palette.black()
            }

            Repeater{
                model:fullCache.userWptsCode.length

                Column{
                    spacing: 5

                    Row {
                        leftPadding: 15

                        Image {
                            id: iconUserwaypoint
                            source: "qrc:/Image/Waypoints/waypoint_user.png"
                            anchors.top: textCode.top
                        }

                        Text {
                            id: textCode
                            //   anchors.bottom: iconUserwaypoint.bottom
                            leftPadding: 15
                            text: fullCache.userWptsCode[index]
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 13
                            color: Palette.white()
                        }
                    }

                    Text {
                        visible: fullCache.userWptsLat[index] >180  ? false : true
                        text: formatLatText(formatCoordinatesUserWaypoint , fullCache.userWptsLat[index]) + "  ,   " +
                              formatLonText(formatCoordinatesUserWaypoint , fullCache.userWptsLon[index])
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 15
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.leftMargin: 10

                        MouseArea {
                            anchors.fill: parent
                            onClicked: formatCoordinatesUserWaypoint = !formatCoordinatesUserWaypoint
                        }
                    }

                    Row {

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            visible: fullCache.userWptsLat[index] >180  ? false : true
                            source: "qrc:/Image/Compass/compassIcon.png"
                            scale: 0.6

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
                            scale: 0.5

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
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 40

                        FastButton {
                            id: uwDelete
                            text: "Supprimer"
                            font.pointSize: 18
                            onClicked:{
                                //Delete userWaypoint
                                fastCache.deleteUserWpt = true
                                sendUserWaypoint.sendRequest(connector.tokenKey, fullCache.userWptsCode[index])
                                userWptIndex = index
                            }
                        }

                        FastButton {
                            id: uwUpdate
                            text: "Modifier"
                            font.pointSize: 18
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
