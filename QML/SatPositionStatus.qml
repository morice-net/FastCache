import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtPositioning

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: root

    BluetoothGps {
        id: bluetoothGps
        onSatellitesInViewChanged: {
            let intermediateModel = []
            intermediateModel.length = satellitesInView.length
            for (var i = 0; i < satellitesInView.length; ++i) {
                let sat = satellitesInView[i]
                intermediateModel[i] = {
                    "id": sat.satelliteIdentifier,
                    "rssi": sat.signalStrength,
                    "azimuth": sat.attribute(GeoSatelliteInfo.Azimuth),
                    "elevation": sat.attribute(GeoSatelliteInfo.Elevation),
                    "inUse": true
                }
            }
            satellitesModel = intermediateModel
        }
        onSatellitesInUseChanged: {

        }
    }

    property alias latitudeString: latValue.text
    property alias longitudeString: lonValue.text
    property alias statusString: statusValue.text

    height: rootLayout.implicitHeight + rootLayout.anchors.bottomMargin

    RowLayout {
        id: rootLayout
        anchors {
            fill: parent
            leftMargin: 5
            rightMargin: 5
            bottomMargin: 5
        }
        spacing: 5

        Rectangle {
            implicitWidth: (parent.width - parent.spacing) / 2
            implicitHeight: Math.max(statusLayout.actualHeight, posLayout.actualHeight)
            border {
                color: Palette.greenSea()
                width: 1
            }
            radius: 5

            GridLayout {
                id: posLayout

                property real actualHeight: implicitHeight

                anchors.fill: parent
                columns: 2

                Text {
                    text: qsTr("Position courante")
                    font.family: localFont.name
                    font.pointSize: 15
                    color: Palette.greenSea()
                    Layout.alignment: Qt.AlignHCenter
                    Layout.columnSpan: 2
                }

                Text {
                    text: qsTr("lat:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: latValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }

                Text {
                    text: qsTr("lon:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: lonValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }
            }
        }

        Rectangle {
            implicitWidth: (parent.width - parent.spacing) / 2
            implicitHeight: Math.max(statusLayout.actualHeight, posLayout.actualHeight)
            border {
                color: Palette.greenSea()
                width: 1
            }
            radius: 5

            ColumnLayout {
                id: statusLayout
                property real actualHeight: implicitHeight + anchors.margins * 2
                anchors {
                    fill: parent
                    margins: 5
                }

                Text {
                    text: qsTr("Statut")
                    font.family: localFont.name
                    font.pointSize: 15
                    color: Palette.greenSea()
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    id: statusValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                    wrapMode: Text.WordWrap
                    Layout.alignment: Qt.AlignHCenter
                }

                CheckBox {
                    id: external
                    checked: externalSource
                    onCheckedChanged:{
                        externalSource = external.checked
                        externalGps(externalSource)
                    }
                    contentItem: Text {
                        text: "Gps externe"
                        font.family: localFont.name
                        font.pointSize: 13
                        color: external.checked ? Palette.greenSea() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: external.indicator.width + external.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 12
                        implicitHeight: 12
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
            }
        }
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
