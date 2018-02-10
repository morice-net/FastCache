import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3



import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastMap
    anchors.fill: parent

    property alias mapItem: map
    property var component

    // Map properties
    property real zoomlevelRecord: 14.5
    property real currentZoomlevel: 14.5
    Plugin {
        id: mapPlugin
        name: "mapbox"
        // configure your own map_id and access_token here
        parameters: [  PluginParameter {
                name: "mapbox.mapping.map_id"
                value: "mapbox.streets"
            },
            PluginParameter {
                name: "mapbox.access_token"
                value: "pk.eyJ1IjoiZ3R2cGxheSIsImEiOiJjaWZ0Y2pkM2cwMXZqdWVsenJhcGZ3ZDl5In0.6xMVtyc0CkYNYup76iMVNQ"
            },
            PluginParameter {
                name: "mapbox.mapping.highdpi_tiles"
                value: true
            }]
    }
    Map {
        id: map
        plugin: mapPlugin

        anchors.fill: parent
        zoomLevel: currentZoomlevel

        gesture.enabled: true
        gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture

        minimumZoomLevel: 8.
        maximumZoomLevel: 18.

        Behavior on zoomLevel { NumberAnimation { duration: 300 } }

        onZoomLevelChanged: {
            console.log(zoomLevel)
            if ((zoomlevelRecord > (zoomLevel + 0.7)) || (zoomlevelRecord < (zoomLevel - 0.7))) {
                zoomlevelRecord = zoomLevel
                map.clearMapItems()
                userInfo.sendRequest(connector.tokenKey)
            }
        }
        onCenterChanged: {
            map.clearMapItems()
            userInfo.sendRequest(connector.tokenKey)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: mapControls.show()
        }

        function updateCachesOnMap() {
            for (var i = 0; i < cachesBBox.caches.length; i++) {
                var itemMap = Qt.createQmlObject('FastMapItem {}', map)
                itemMap.index = i
                addMapItem(itemMap)
            }

        }

        Component.onCompleted: map.center = currentPosition.position.coordinate
    }

    Column {
        id: mapControls
        visible: opacity > 0
        opacity: 0
        width: parent.height * 0.05
        anchors.margins: 20
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10

        Behavior on opacity { NumberAnimation { duration: 300 } }

        // Centers
        Rectangle {
            height: parent.width
            width: height
            color: Palette.turquoise().replace("#","#99")
            radius: 10

            Image {
                source: "qrc:/Image/tracker.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                anchors.margins: 5
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Tracker clicked")
                    map.center = currentPosition.position.coordinate
                }
            }
        }

        // Zoom plus
        Rectangle {
            height: parent.width
            width: height
            color: Palette.turquoise().replace("#","#99")
            radius: 10

            Image {
                source: "qrc:/Image/add.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                anchors.margins: 8
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Plus clicked")
                    currentZoomlevel += 0.5
                }
            }
        }

        // Zoom minus
        Rectangle {
            height: parent.width
            width: height
            color: Palette.turquoise().replace("#","#99")
            radius: 10

            Image {
                source: "qrc:/Image/remove.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                anchors.margins: 8
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Minus clicked")
                    currentZoomlevel -= 0.5
                }
            }
        }

        Timer {
            id: timer
            interval: 12000
            running: false
            onTriggered: mapControls.hide()
        }

        function show() {
            opacity = 1
            timer.start()
        }
        function hide() {
            opacity = 0
            timer.stop()
        }
    }
}
