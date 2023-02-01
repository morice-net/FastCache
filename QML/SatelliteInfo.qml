import QtQuick

import com.mycompany.connecting 1.0
import "JavaScript/Palette.js" as Palette

Rectangle {
    id: page
    border.color: Palette.greenSea()
    border.width: 2

    SatelliteModel {
        id: satelliteModel
        running: true
        onErrorFound: function(code) {errorLabel.text = qsTr("Dernière Erreur: %1", "%1=error number").arg(code)}
    }

    Item {
        id: header
        anchors.top: parent.top
        height: column.height + 30
        width: parent.width
        state: "Arrêté"

        function toggle()
        {
            switch (header.state) {
            case "Unique": header.state = "Fonctionnement"; break;
            default:
            case "Fonctionnement": header.state = "Arrêté"; break;
            case "Arrêté": header.state = "Unique"; break;
            }
        }

        function enterSingle()
        {
            satelliteModel.singleRequestMode = true;
            satelliteModel.running = true;
        }

        function enterRunning()
        {
            satelliteModel.running = false;
            satelliteModel.singleRequestMode = false;
            satelliteModel.running = true;
        }

        states: [
            State {
                name: "Arrêté"
                PropertyChanges { target: startStop; bText: qsTr("Unique") }
                PropertyChanges {
                    target: modeLabel; text: qsTr("Mode Actuel: Arrêté")
                }
                PropertyChanges { target: satelliteModel; running: false; }
            },
            State {
                name: "Unique"
                PropertyChanges { target: startStop; bText: qsTr("Début") }
                PropertyChanges {
                    target: modeLabel; text: qsTr("Mode Actuel: Unique")
                }
                StateChangeScript { script: header.enterSingle(); }
            },
            State {
                name: "Fonctionnement"
                PropertyChanges { target: startStop; bText: qsTr("Stop") }
                PropertyChanges {
                    target: modeLabel; text: qsTr("Mode Actuel: Fonctionnement")
                }
                StateChangeScript { script: header.enterRunning(); }
            }
        ]

        Column {
            id: column
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: 7

            Text {
                id:  overview
                text: satelliteModel.satelliteInfoAvailable
                      ? qsTr("Satellites Connus")
                      : qsTr("Satellites Connus (Demo Mode)")
                font.pointSize: 12
                color: Palette.greenSea()
            }

            Text {
                id: modeLabel
                font.pointSize: 12
                color: Palette.greenSea()
            }

            Text {
                id: errorLabel
                text: qsTr("Dernière Erreur: Aucune")
                font.pointSize: 12
                color: Palette.greenSea()
            }
        }

        Rectangle {
            id: startStop
            border.color: Palette.greenSea()
            border.width: 2
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 7
            radius: 10
            height: maxField.height*1.4
            width: maxField.width*1.4

            property string bText: qsTr("Stop");

            Text { //need this for sizing
                id: maxField
                text: qsTr("Unique")
                font.pointSize: 13
                opacity: 0
            }

            Text {
                id: buttonText
                anchors.centerIn: parent
                text: startStop.bText
                font.pointSize: 13
                color: Palette.greenSea()
            }

            MouseArea {
                anchors.fill: parent
                onPressed: { startStop.color = Palette.silver() }
                onClicked: { header.toggle() }
                onReleased: { startStop.color = Palette.white() }
            }
        }
    }

    Rectangle {
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: rect.myMargin
        border.width: 2
        radius: 8
        border.color: Palette.greenSea()

        Item {
            id: rect
            anchors.fill: parent
            anchors.margins: myMargin
            property int myMargin: 7

            Row {
                id: view
                property int rows: repeater.model.entryCount
                property int singleWidth: ((rect.width - scale.width)/rows )-rect.myMargin
                spacing: rect.myMargin

                Rectangle {
                    id: scale
                    width: strengthLabel.width+10
                    height: rect.height
                    color: "#32cd32"
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: lawngreenRect.top
                        font.pointSize: 11
                        color: Palette.greenSea()
                        text: "50"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        font.pointSize: 11
                        color: Palette.greenSea()
                        text: "100"
                    }

                    Rectangle {
                        id: redRect
                        width: parent.width
                        color: "red"
                        height: parent.height*10/100
                        anchors.bottom: parent.bottom
                        Text {
                            id: strengthLabel
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            font.pointSize: 11
                            color: Palette.greenSea()
                            text: "00"
                        }
                    }

                    Rectangle {
                        id: orangeRect
                        height: parent.height*10/100
                        anchors.bottom: redRect.top
                        width: parent.width
                        color: "#ffa500"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            font.pointSize: 11
                            color: Palette.greenSea()
                            text: "10"
                        }
                    }

                    Rectangle {
                        id: goldRect
                        height: parent.height*10/100
                        anchors.bottom: orangeRect.top
                        width: parent.width
                        color: "#ffd700"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            font.pointSize: 11
                            color: Palette.greenSea()
                            text: "20"
                        }
                    }

                    Rectangle {
                        id: yellowRect
                        height: parent.height*10/100
                        anchors.bottom: goldRect.top
                        width: parent.width
                        color: "yellow"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            font.pointSize: 11
                            color: Palette.greenSea()
                            text: "30"
                        }
                    }

                    Rectangle {
                        id: lawngreenRect
                        height: parent.height*10/100
                        anchors.bottom: yellowRect.top
                        width: parent.width
                        color: "#7cFc00"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            color: Palette.greenSea()
                            font.pointSize: 11
                            text: "40"
                        }
                    }
                }

                Repeater {
                    id: repeater
                    model: satelliteModel
                    delegate: Rectangle {
                        height: rect.height
                        width: view.singleWidth

                        Rectangle {
                            id: rectangle
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: parent.height*signalStrength/100
                            color: isInUse ? "#7FFF0000" : "#7F0000FF"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: rectangle.top
                            text: satelliteIdentifier
                            font.pointSize: 6
                            color: Palette.greenSea()
                        }
                    }
                }
            }
        }
    }
}
