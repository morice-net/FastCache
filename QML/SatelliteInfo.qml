import QtPositioning
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FastCache

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Rectangle {
    id: page
    height: parent.height * 0.93
    width: parent.width * 0.9
    x: -parent.width
    y: -parent.height
    radius: 5
    border.color: Palette.greenSea()
    border.width: 2

    Behavior on x { NumberAnimation { duration: 600 } }
    Behavior on y { NumberAnimation { duration: 600 } }

    property color inUseColor: "#7FFF0000"
    property color inViewColor: "#7F0000FF"

    property var posData: locationSource
    onPosDataChanged: {
        if(posData.latitude.toString() !== "NaN")
            positionAndStatus.latitudeString = Functions.formatLat(posData.latitude)
        if(posData.longitude.toString() !== "NaN")
            positionAndStatus.longitudeString = Functions.formatLon(posData.longitude)
    }

    // The model structure is:
    // { "id": 1, "rssi": 10, "azimuth": 150, "elevation": 25, "inUse": false }
    property var satellitesModel: []
    property var inUseIds: new Set()

    function updateModel(external) {
        let intermediateModel = []
        if(!external) {
            intermediateModel.length = satelliteSource.satellitesInView.length
            for (var i = 0; i < satelliteSource.satellitesInView.length; ++i) {
                let sat = satelliteSource.satellitesInView[i]
                intermediateModel[i] = {
                    "id": sat.satelliteIdentifier,
                    "rssi": sat.signalStrength,
                    "azimuth": sat.attribute(GeoSatelliteInfo.Azimuth),
                    "elevation": sat.attribute(GeoSatelliteInfo.Elevation),
                    "inUse": inUseIds.has(sat.satelliteIdentifier)
                }
            }
        } else {
            intermediateModel.length = bluetoothGps.satellitesInView.length
            for (var j = 0; j < bluetoothGps.satellitesInView.length; ++j) {
                let sat = bluetoothGps.satellitesInView[j]
                intermediateModel[j] = {
                    "id": sat.satelliteIdentifier,
                    "rssi": sat.signalStrength,
                    "azimuth": sat.attribute(GeoSatelliteInfo.Azimuth),
                    "elevation": sat.attribute(GeoSatelliteInfo.Elevation),
                    "inUse": inUseIds.has(sat.satelliteIdentifier)
                }
            }
        }
        satellitesModel = intermediateModel
    }

    function toggleState() {
        switch (statesItem.state) {
        case "stopped":
            statesItem.state = "running"
            break
        case "running":
            statesItem.state = "stopped"
            break
        }
    }

    function updateActive(state) {
        satelliteSource.active = state
    }

    BluetoothGps {
        id: bluetoothGps
        onSatellitesInViewChanged: {
            if(statesItem.state !== "stopped")
                page.updateModel(true)
        }
        onSatellitesInUseChanged: {
            if(statesItem.state !== "stopped") {
                page.inUseIds.clear()
                for (var i = 0; i < bluetoothGps.satellitesInUse.length; ++i)
                    page.inUseIds.add(bluetoothGps.satellitesInUse[i].satelliteIdentifier)
                page.updateModel(true)
            }
        }
        onPositionChanged: {
            positionAndStatus.altString = bluetoothGps.position.altitude.toFixed(0) + " m"
            externalLatitude = bluetoothGps.position.latitude
            externalLongitude = bluetoothGps.position.longitude
        }
        onSpeedChanged: {
            positionAndStatus.speedString = bluetoothGps.speed.toFixed(0) + " km/h"
        }
        onPrecisionChanged: {
            positionAndStatus.precisionString = bluetoothGps.precision.toFixed(3)
        }
        onGpsNameChanged: positionAndStatus.statusString = statusStringGps(externalSource)
    }

    SatelliteSource {
        id: satelliteSource
        updateInterval: 1000
        onSatellitesInViewChanged: page.updateModel(false)
        onSatellitesInUseChanged: {
            page.inUseIds.clear()
            for (var i = 0; i < satellitesInUse.length; ++i)
                page.inUseIds.add(satellitesInUse[i].satelliteIdentifier)

            page.updateModel(false)
        }
    }

    // display
    Column {
        spacing: 1
        leftPadding: 5
        rightPadding: 5
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox {
            id: external
            anchors.horizontalCenter: parent.horizontalCenter
            checked: externalSource
            onCheckedChanged:{
                externalSource = external.checked
                externalGps(externalSource)
            }
            contentItem: Text {
                text: "Gps externe"
                font.family: localFont.name
                font.pointSize: 16
                color: Palette.greenSea()
                verticalAlignment: Text.AlignVCenter
                leftPadding: external.indicator.width + external.spacing
            }
            indicator: Rectangle {
                implicitWidth: 15
                implicitHeight: 15
                radius: 3
                border.width: 1
                border.color: Palette.greenSea()
                y: parent.height / 2 - height / 2

                Rectangle {
                    anchors.fill: parent
                    visible: external.checked
                    color: Palette.greenSea()
                    radius: 3
                    anchors.margins: 2
                }
            }
        }

        StackLayout {
            id: viewsLayout
            width: parent.width * 0.95
            height: main.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter

            SatSkyView {
                satellitesModel: page.satellitesModel
                inViewColor: page.inViewColor
                inUseColor: page.inUseColor
            }

            SatRssiView {
                satellitesModel: page.satellitesModel
                inViewColor: page.inViewColor
                inUseColor: page.inUseColor
            }
        }

        Row {
            id: switchButtons
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            FastButton {
                id: skyView
                text: "Vue du ciel"
                font.pointSize: 15
                onClicked: viewsLayout.currentIndex = 0 // sky view
            }

            FastButton {
                id: rssiView
                text: "Vue RSSI"
                font.pointSize: 15
                onClicked: viewsLayout.currentIndex = 1  // RSSI view
            }
        }

        FastButton {
            id: modeButton
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 15
            onClicked: page.toggleState()
        }

        SatPositionStatus {
            id: positionAndStatus
            width: parent.width * 0.95
        }
    }

    Item {
        id: statesItem
        visible: false
        state: "stopped"
        states: [
            State {
                name: "stopped"
                PropertyChanges {
                    target: modeButton
                    text: qsTr("Activer")
                }
                PropertyChanges {
                    target: positionAndStatus
                    statusString: externalSource ? bluetoothGps.gpsName + "\n" + qsTr("Arrêté") : "Gps interne\n" + qsTr("Arrêté")
                }
                StateChangeScript {
                    script: page.updateActive(false)
                }
            },
            State {
                name: "running"
                PropertyChanges {
                    target: modeButton
                    text: qsTr("Stop")
                }
                PropertyChanges {
                    target: positionAndStatus
                    statusString: externalSource ? bluetoothGps.gpsName + "\n" +  qsTr("En cours") : "Gps interne\n" + qsTr("En cours")
                }
                StateChangeScript {
                    script: page.updateActive(true)
                }
            }
        ]
    }

    function externalGps(external) {
        if(external) {
            bluetoothGps.searchBluetooth()
        } else {
            bluetoothGps.quitBluetooth()
            currentPosition.active = true
        }
    }

    function statusStringGps(external) {
        if(statesItem.state === "stopped" && external) {
            return  bluetoothGps.gpsName + "\n" + qsTr("Arrêté")
        } else if(statesItem.state === "stopped" && !external) {
            return "Gps interne\n" + qsTr("Arrêté")
        } else if(statesItem.state === "running" && external) {
            return bluetoothGps.gpsName + "\n" +  qsTr("En cours")
        } else if(statesItem.state === "running" && !external) {
            return "Gps interne\n" + qsTr("En cours")
        }
    }

    function closeIfMenu() {
    }

    function showMenu() {
        console.log("Show menu...")
        page.x = 10
        page.y = 30
    }

    function hideMenu() {
        console.log("Hide menu...")
        page.x = page.width * -1
        page.y = page.height * -1
    }

    function isMenuVisible() {
        return (page.x >= 0)
    }
}


