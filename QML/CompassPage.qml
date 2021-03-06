import QtQuick 2.6
import QtSensors 5.2 // to use Compass
import QtPositioning 5.3

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette

Item {
    id: compassPage

    Location {
        id: goalLocation
        coordinate {
            latitude: fastCache.goalLat
            longitude: fastCache.goalLon
        }
    }

    Column {
        spacing: 10
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.1

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 20
            text: "Distance  " + Helper.formatDistance(Math.round(currentPosition.position.coordinate
                                                                  .distanceTo(goalLocation.coordinate)))
            color: Palette.white()
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 18
            text: "Azimut  " + currentPosition.position.coordinate.azimuthTo(goalLocation.coordinate).toFixed(0)+"°"
            color: Palette.white()
        }
    }

    Rectangle { // the compass view background
        id: compassBackground
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) - 20
        height: width
        radius: width / 2
        color: Palette.greenSea()

        Image {
            id: compassUnderlay
            source: "qrc:/Image/Compass/compass_underlay.png"
            anchors.fill: parent

            Image {
                id: compassRose
                anchors.centerIn: parent
                source: "qrc:/Image/Compass/compass_rose.png"

                Behavior on rotation { NumberAnimation { duration: 2000 } }

                Image {
                    id: compassArrow
                    anchors.centerIn: parent
                    source: "qrc:/Image/Compass/compass_arrow.png"

                    Behavior on rotation { NumberAnimation { duration: 2000 } }
                }
            }
        }
    }

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: compassBackground.y + compassBackground.height
        visible: fastCache.wptName.length !== 0
        font.family: localFont.name
        font.pointSize: 20
        text: fastCache.wptName
        color: Palette.white()

        MouseArea {
            anchors.fill: parent
            onClicked: {
                compassPageInit("Cache   " + fullCache.geocode , fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
                swipeToPage(0);
            }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: title.y + title.height + 5
        font.family: localFont.name
        font.pointSize: 16
        text: "Lat  " + main.formatLat(goalLocation.coordinate.latitude) + "   Lon  " + main.formatLon(goalLocation.coordinate.longitude)
        color: Palette.white()
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: title.y + 2*title.height + 5
        font.family: localFont.name
        font.pointSize: 16
        text: "Lat  " + main.formatLat(currentPosition.position.coordinate.latitude) + "   Lon  " +
              main.formatLon(currentPosition.position.coordinate.longitude)
        color: Palette.white()
    }

    CompassMapSwipeButton {
        id: compassMapSwipeButton
        buttonText: "Voir la\ncarte"
        anchors.margins: 50
        anchors.top: parent.top
        anchors.right: parent.right

        function buttonClicked()
        {
            fastCache.z = -10
        }
    }

    function updateRotation() {
        compassRose.rotation = -1*beginLocation.coordinate.azimuthTo(currentPosition.position.coordinate)
        compassArrow.rotation = currentPosition.position.coordinate.azimuthTo(goalLocation.coordinate)
        main.beginLat = currentPosition.position.coordinate.latitude;
        main.beginLon = currentPosition.position.coordinate.longitude;
    }

    Component.onCompleted: {
        main.positionUpdated.connect(updateRotation)
    }
}
