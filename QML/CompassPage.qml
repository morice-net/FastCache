import QtQuick 2.6
import QtSensors 5.2 // to use Compass

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette

Item {
    id: compassPage

    Column {
        spacing: 10
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.05

        Row {
            width: parent.width
            spacing: 15
            Text {
                font.family: localFont.name
                width: fastCache.width * 0.25
                horizontalAlignment: Text.AlignRight
                font.pointSize: 20
                text: "Distance"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 20
                text: Helper.formatDistance(Math.round(currentPosition.position.coordinate
                                                       .distanceTo(fullCacheLocation.coordinate)))
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                font.family: localFont.name
                width: fastCache.width * 0.25
                horizontalAlignment: Text.AlignRight
                font.pointSize: 18
                text: "Azimut"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 18
                text: currentPosition.position.coordinate.azimuthTo(fullCacheLocation.coordinate).toFixed(0)+"°"
                color: Palette.white()
            }
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

                Image {
                    id: compassArrow
                    anchors.centerIn: parent
                    source: "qrc:/Image/Compass/compass_arrow.png"
                }
            }
        }
    }

    Row {
        y:compassBackground.y + compassBackground.height + 20
        width: parent.width
        spacing: 10

        Text {
            font.family: localFont.name
            width: fastCache.width * 0.1
            horizontalAlignment: Text.AlignRight
            font.pointSize: 16
            text: "Lat "
            color: Palette.silver()
        }

        Text {
            font.family: localFont.name
            font.pointSize: 16
            text: main.formatLat(currentPosition.position.coordinate.latitude)
            color: Palette.white()
        }

        Text {
            font.family: localFont.name
            horizontalAlignment: Text.AlignRight
            font.pointSize: 16
            text: "Lon "
            color: Palette.silver()
        }

        Text {
            font.family: localFont.name
            font.pointSize: 16
            text: main.formatLon(currentPosition.position.coordinate.longitude)
            color: Palette.white()
        }
    }

    function updateRotation() {
        console.log("Updating BIG compass...")
        compassArrow.rotation = currentPosition.position.coordinate.azimuthTo(fullCacheLocation.coordinate)
    }

    Component.onCompleted: {
        main.positionUpdated.connect(updateRotation)
    }
}
