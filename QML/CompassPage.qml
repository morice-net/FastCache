import QtQuick
import QtPositioning

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {
    id: compassPage

    property string ifFullCache: compassPageFullCache()

    Location {
        id: goalLocation
        coordinate {
            latitude: fastCache.goalLat
            longitude: fastCache.goalLon
        }
    }

    Column {
        spacing: 8
        anchors.fill: parent
        anchors.topMargin: fastMenuHeader.menuIconHeight() + 5

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 20
            text: "Distance  " + Helper.formatDistance(Math.round(locationSource.distanceTo(goalLocation.coordinate)))
            color: Palette.white()
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 20
            text: "Azimut  " + locationSource.azimuthTo(goalLocation.coordinate).toFixed(0)+"°"
            color: Palette.white()
        }
    }

    Rectangle { // the compass view background
        id: compassBackground
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 110
        width: main.width * 0.8
        height: width
        radius: width / 2
        color: Palette.greenSea()

        Image {
            id: compassUnderlay
            source: "../Image/Compass/compass_underlay.png"
            anchors.centerIn: parent
            scale: 0.9

            Image {
                id: compassRose
                anchors.centerIn: parent
                source: "../Image/Compass/compass_rose.png"
                scale: 0.72

                Behavior on rotation { NumberAnimation { duration: 2000 } }
            }

            Image {
                id: compassArrow
                anchors.centerIn: parent
                source: "../Image/Compass/compass_arrow.png"
                scale: 0.72

                Behavior on rotation { NumberAnimation { duration: 2000 } }
            }
        }
    }

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: compassBackground.bottom
        anchors.topMargin: 20
        visible: fastCache.wptName.length !== 0
        font.family: localFont.name
        font.pointSize: 19
        text: fastCache.wptName.length >= 50 ? fastCache.wptName.substring(0,50) + "..." : fastCache.wptName
        color: Palette.white()

        MouseArea {
            anchors.fill: parent
            onClicked: compassPageFullCache()
        }
    }

    Text {
        id: titleCoord
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        font.family: localFont.name
        font.pointSize: 19
        text: "Lat  " + Functions.formatLat(goalLocation.coordinate.latitude) + "   Lon  " + Functions.formatLon(goalLocation.coordinate.longitude)
        color: Palette.white()
    }

    Text {
        id: title1
        anchors.horizontalCenter: parent.horizontalCenter
       anchors.top: titleCoord.bottom
        font.family: localFont.name
        font.pointSize: 19
        text:"Position actuelle"
        color: Palette.silver()
    }

    Text {
        id: title1Coord
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title1.bottom
        font.family: localFont.name
        font.pointSize: 19
        text: "Lat  " + Functions.formatLat(locationSource.latitude) + "   Lon  " +
              Functions.formatLon(locationSource.longitude)
        color: Palette.silver()
    }

    function updateRotation() {
        compassRose.rotation =  - azimutDevice
        compassArrow.rotation = compassRose.rotation + locationSource.azimuthTo(goalLocation.coordinate)
    }

    function compassPageFullCache() {
        wptName = compassPageTitleFullCache()
        goalLat = fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat
        goalLon = fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon
        return fullCache.geocode
    }
    Component.onCompleted: {
        main.positionUpdated.connect(updateRotation)
    }
}
