import QtPositioning
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import com.mycompany.connecting 1.0
import "JavaScript/Palette.js" as Palette

Rectangle {
    id: page
    border.color: Palette.greenSea()
    border.width: 2
    visible: true

    property color inUseColor: "#7FFF0000"
    property color inViewColor: "#7F0000FF"

    property bool externalSource: false

    // The model structure is:
    // { "id": 1, "rssi": 10, "azimuth": 150, "elevation": 25, "inUse": false }
    property var satellitesModel: []
    property var inUseIds: new Set()

    function updateModel() {
        let intermediateModel = []
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
        satellitesModel = intermediateModel
    }

    function toggleState() {
        switch (statesItem.state) {
        case "stopped":
            statesItem.state = "single"
            break
        case "single":
            statesItem.state = "running"
            break
        case "running":
            statesItem.state = "stopped"
            break
        }
    }

    function updateActive(state) {
        satelliteSource.active = state
        positionSource.active = state
    }

    function enterSingle() {
        updateActive(false)
        satelliteSource.update()
        positionSource.update()
    }

    SatelliteSource {
        id: satelliteSource
        name: page.externalSource ? "nmea" : ""

        PluginParameter {
            name: "nmea.source"
            value: "socket://Bluetooth:1"
        }
        onSatellitesInViewChanged: page.updateModel()
        onSatellitesInUseChanged: {
            page.inUseIds.clear()
            for (var i = 0; i < satellitesInUse.length; ++i)
                page.inUseIds.add(satellitesInUse[i].satelliteIdentifier)

            page.updateModel()
        }
        onSourceErrorChanged: {
            if (sourceError != SatelliteSource.NoError)
                positionAndStatus.statusString = qsTr("SatelliteSource Error: %1").arg(sourceError)
        }
    }

    PositionSource {
        id: positionSource
        name: page.externalSource ? "nmea" : ""

        PluginParameter {
            name: "nmea.source"
            value: "socket://Bluetooth:1"
        }
        onPositionChanged: {
            let posData = position.coordinate.toString().split(", ")
            positionAndStatus.latitudeString = posData[0]
            positionAndStatus.longitudeString = posData[1]
        }
        onSourceErrorChanged: {
            if (sourceError != PositionSource.NoError)
                positionAndStatus.statusString = qsTr("PositionSource Error: %1").arg(sourceError)
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
                    text: qsTr("Unique")
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
                name: "single"
                PropertyChanges {
                    target: modeButton
                    text: qsTr("Commencer")
                }
                PropertyChanges {
                    target: positionAndStatus
                    statusString: qsTr("Requête unique")
                }
                StateChangeScript {
                    script: page.enterSingle()
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
}
