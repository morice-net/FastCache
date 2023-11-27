import QtQuick
import QtSensors  // to use Compass
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
        anchors.topMargin: parent.height * 0.07

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
                scale: 0.72

                Behavior on rotation { NumberAnimation { duration: 2000 } }

                Image {
                    id: compassArrow
                    anchors.centerIn: parent
                    source: "qrc:/Image/Compass/compass_arrow.png"
                    scale: 0.72

                    Behavior on rotation { NumberAnimation { duration: 2000 } }
                }
            }
        }
    }

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        width: main.width * 0.5
        y: compassBackground.y + compassBackground.height
        visible: fastCache.wptName.length !== 0
        font.family: localFont.name
        font.pointSize: 20
        text: fastCache.wptName
        color: Palette.white()
        elide: Text.ElideRight
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: compassPageFullCache()
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: title.y + title.height + 3
        font.family: localFont.name
        font.pointSize: 16
        text: "Lat  " + Functions.formatLat(goalLocation.coordinate.latitude) + "   Lon  " + Functions.formatLon(goalLocation.coordinate.longitude)
        color: Palette.white()
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: title.y + 2 * title.height
        font.family: localFont.name
        font.pointSize: 14
        text:"position actuelle"
        color: Palette.silver()
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: title.y + 2.7 * title.height
        font.family: localFont.name
        font.pointSize: 14
        text: "Lat  " + Functions.formatLat(currentPosition.position.coordinate.latitude) + "   Lon  " +
              Functions.formatLon(currentPosition.position.coordinate.longitude)
        color: Palette.silver()
    }

    FastButton {
        id: compassMapSwipeButton
        opacity: 0.85
        font.pointSize: 17
        text: "Voir la\ncarte"
        y: main.height * 0.12
        anchors.right: parent.right
        anchors.rightMargin: 20
        onClicked: {
            viewState = "map"
            // memorizes the center and the zoom of the map
            fastMap.mapItem.latCenterMap = fastMap.mapItem.center.latitude
            fastMap.mapItem.lonCenterMap = fastMap.mapItem.center.longitude
            fastMap.mapItem.zoomMap = fastMap.mapItem.zoomLevel

            fastMap.compassMapButton = true
            fastMap.mapItem.oneCacheOnMap(fullCache.geocode , true) //makes one cache visible on map
            fastMap.mapItem.allCirclesOnMap(false) // makes all cache circles invisible on the map
            // center cache or waypoint on map
            fastMap.mapItem.center = QtPositioning.coordinate(goalLat , goalLon)

            fastMap.currentZoomlevel = 17
            // is cache in list of caches?
            if(!fastCache.geocodeInCachesList) {
                fastMap.mapItem.addCacheOnMap() // add full cache on map, not in list
                if(settings.circlesCaches)
                    fastMap.mapItem.createCircleSingleCache(fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                                            fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
            }
            // Add waypoints cache on map
            fastMap.mapItem.addWaypointsCacheOnMap()

            // Add user waypoints cache on map
            fastMap.mapItem.addUserWaypointsCacheOnMap()

            // Orient the map if necessary
            if(!fastMap.oldMapNorth)
                fastMap.mapItem.bearing = currentPosition.position.coordinate.azimuthTo(QtPositioning.coordinate(goalLat , goalLon))
        }
    }

    function updateRotation() {
        compassRose.rotation = -1 * beginLocation.coordinate.azimuthTo(currentPosition.position.coordinate)
        compassArrow.rotation = currentPosition.position.coordinate.azimuthTo(goalLocation.coordinate)
        main.beginLat = currentPosition.position.coordinate.latitude;
        main.beginLon = currentPosition.position.coordinate.longitude;
    }

    function compassPageFullCache() {
        var cachetype = "Cache: "
        var cacheGeocode = ""
        if(fullCache.geocode.substring(0,2) !== "GC" ) { // lab cache
            cachetype = "Lab Cache: "
            cacheGeocode = fullCache.geocode.substring(0,10) + "..."
        } else {
            cacheGeocode = fullCache.geocode // cache GC..
        }
        wptName = cachetype + cacheGeocode
        goalLat = fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat
        goalLon = fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon
        return fullCache.geocode
    }
    Component.onCompleted: {
        main.positionUpdated.connect(updateRotation)
    }
}
