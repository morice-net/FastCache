import QtPositioning
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import com.mycompany.connecting 1.0

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Rectangle {
    id: page
    border.color: Palette.greenSea()
    border.width: 2
    visible: true

    property color inUseColor: "#7FFF0000"
    property color inViewColor: "#7F0000FF"

    property var posData: currentPosition.position.coordinate
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
        currentPosition.active = state
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
            currentPosition.position.coordinate.latitude = bluetoothGps.position.latitude
            currentPosition.position.coordinate.longitude = bluetoothGps.position.longitude
        }
        onSpeedChanged: {
            positionAndStatus.speedString = bluetoothGps.speed.toFixed(0) + " km/h"
        }
        onPrecisionChanged: {
            positionAndStatus.precisionString = bluetoothGps.precision.toFixed(3)
        }        
        onGpsNameChanged: positionAndStatus.statusString = bluetoothGps.gpsName
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

    StackLayout {
        id: viewsLayout
        width: parent.width * 0.98
        anchors {
            top: switchButtons.bottom
            bottom: positionAndStatus.top
            horizontalCenter: parent.horizontalCenter
        }

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

    SatPositionStatus {
        id: positionAndStatus
        width: parent.width * 0.98
        anchors {
            bottom: modeButton.top
            horizontalCenter: parent.horizontalCenter
        }
    }

    FastButton {
        id: modeButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        onClicked: page.toggleState()
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
                    text: qsTr("Commencer")
                }
                PropertyChanges {
                    target: positionAndStatus
                    statusString: qsTr("Arrêté")
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
                    statusString: qsTr("En cours")
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
}


