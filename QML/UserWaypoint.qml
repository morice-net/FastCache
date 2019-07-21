import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

FastPopup {
    id:userwaypoint

    property string textLog: ""

    onTextLogChanged: description.text = description.text + textLog ;

    AddTextLog{
        id:addText
    }

    x: 10
    y: 10
    background: Rectangle {
        anchors.fill: parent
        implicitWidth: main.width*0.9
        implicitHeight:main.height*0.9
        color: Palette.turquoise()
        radius: 10
    }

    Column{
        spacing: 10

        Button {
            y: 10
            contentItem: Text {
                id:coordinates
                text:"Coordonnées"
                font.family: localFont.name
                font.pointSize: 20
                color: Palette.turquoise()
            }
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
            onClicked: {
                coordinatesBox.open()
            }
        }

        Text {
            id: lat
            text:"Latitude"
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.white()
        }

        Text {
            id: lon
            text:"Longitude"
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.white()
        }

        TextField {
            id: bearing
            placeholderText: qsTr("Relèvement en degrés")
            font.family: localFont.name
            font.pointSize: 20
            color: Palette.greenSea()
            validator: DoubleValidator {bottom: 0; top: 360.0;}
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }

        }

        TextField {
            id: distance
            placeholderText: qsTr("distance en mètres")
            font.family: localFont.name
            font.pointSize: 20
            color: Palette.greenSea()
            validator: DoubleValidator {bottom: 0}
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        CheckBox {
            id: corrected
            text: qsTr("Utiliser comme coordonnées de la cache")
            font.pointSize: 15
            checked: false
            indicator: Rectangle {
                implicitWidth: 26
                implicitHeight: 26
                x: corrected.leftPadding
                y: parent.height / 2 - height / 2
                radius: 3
                border.color: corrected.down ? Palette.turquoise() : Palette.greenSea()

                Rectangle {
                    width: 14
                    height: 14
                    x: 6
                    y: 6
                    radius: 5
                    color: Palette.turquoise()
                    visible: corrected.checked
                }
            }
            contentItem: Text {
                text: corrected.text
                font: corrected.font
                opacity: enabled ? 1.0 : 0.3
                color: Palette.white()
                verticalAlignment: Text.AlignVCenter
                leftPadding: corrected.indicator.width + corrected.spacing
            }
        }

        Row {
            spacing: 40

            Button {
                y: 10
                contentItem: Text {
                    text:"Effacer"
                    font.family: localFont.name
                    font.pointSize: 16
                    color: Palette.turquoise()
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.turquoise()
                    border.width: 1
                    radius: 5
                }
                onClicked: {
                    description.text = ""
                }
            }

            Button {
                y: 10
                contentItem: Text {
                    text:"Ajout de texte"
                    font.family: localFont.name
                    font.pointSize: 16
                    color: Palette.turquoise()
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.turquoise()
                    border.width: 1
                    radius: 5
                }
                onClicked: {
                    addText.open();
                    textLog = "" ;
                }
            }

            Button {
                y: 10
                contentItem: Text {
                    text:"Envoyer"
                    font.family: localFont.name
                    font.pointSize: 16
                    color: Palette.turquoise()
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.turquoise()
                    border.width: 1
                    radius: 5
                }
                onClicked: {

                }
            }
        }

        Text {
            width: parent.width
            font.family: localFont.name
            font.pointSize: 16
            text: "Description de l'étape"
            color: Palette.white()
        }

        TextArea {
            id: description
            width: parent.width - 20
            font.family: localFont.name
            leftPadding: 15
            font.pointSize: 14
            color: Palette.greenSea()
            textFormat: Qt.RichText
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.white()
                border.width: 1
                radius: 5
            }
        }
    }
}

