import QtQuick 2.6
import QtQuick.Controls 2.2
import QtPositioning 5.6
import QtLocation 5.9

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

FastPopup {
    id:userWaypoint

    property string textLog: ""
    property double userWptLat: wptLat()
    property double userWptLon: wptLon()

    onTextLogChanged: description.text = description.text + textLog ;

    onUserWptLatChanged: lat.text = "Latitude  " + userWptLat.toFixed(5)
    onUserWptLonChanged: lon.text = "Longitude  " + userWptLon.toFixed(5)

    AddTextLog {
        id:addText
    }

    background: Rectangle {
        anchors.fill: parent
        implicitWidth: main.width
        implicitHeight:main.height
        color: Palette.turquoise()
        radius: 10
    }

    Column {
        x: 20
        y:20
        spacing: 30

        Button {
            y: 10
            contentItem: Text {
                id:coordinates
                text:"Coordonnées"
                font.family: localFont.name
                font.pointSize: 17
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

        TextField {
            id: bearing
            placeholderText: qsTr("Relèvement en degrés")
            font.family: localFont.name
            font.pointSize: 17
            color: Palette.greenSea()
            validator: DoubleValidator {bottom: 0.0; top: 360.0}
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
            font.pointSize: 17
            color: Palette.greenSea()
            validator: DoubleValidator {bottom: 0.0}
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        Text {
            id: lat
            text:"Latitude  "
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.white()
        }

        Text {
            id: lon
            text:"Longitude  "
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.white()
        }

        CheckBox {
            id: corrected
            text: qsTr("Utiliser comme coordonnées de la cache")
            font.pointSize: 15
            checked: false
            indicator: Rectangle {
                implicitWidth: 25
                implicitHeight: 25
                x: corrected.leftPadding
                y: parent.height / 2 - height / 2
                radius: 2
                border.color: corrected.down ? Palette.turquoise() : Palette.greenSea()

                Rectangle {
                    width: 14
                    height: 14
                    x: 6
                    y: 6
                    radius: 2
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
            spacing: 30

            Button {
                visible: corrected.checked === false
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
                visible: corrected.checked === false
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
                id:send
                contentItem: Text {
                    text: "Envoyer"
                    font.family: localFont.name
                    font.pointSize: 16
                    color: Palette.turquoise()
                }
                background: Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: Palette.turquoise()
                    radius: 5
                }
                onClicked:{
                    sendUserWaypoint.sendRequest(connector.tokenKey , fullCache.geocode , userWptLat , userWptLon , corrected.checked , description.text , true)
                    userWaypoint.visible = false
                }
            }
        }

        Text {
            width: parent.width
            visible:corrected.checked === false
            font.family: localFont.name
            font.pointSize: 17
            text: "Description de l'étape"
            color: Palette.white()
        }

        TextArea {
            id: description
            visible:corrected.checked === false
            font.family: localFont.name
            font.pointSize: 14
            color: Palette.turquoise()
            background: Rectangle {
                radius: 5
                implicitWidth: userWaypoint.width*0.9
                implicitHeight: userWaypoint.height*0.2
            }
        }
    }

    function  wptLat() {
        if(bearing.text.length !==0 && distance.text.length !== 0){
            return QtPositioning.coordinate(coordinatesBox.resultLat , coordinatesBox.resultLon).atDistanceAndAzimuth(distance.text , bearing.text).latitude
        } else {
            return coordinatesBox.resultLat
        }
    }

    function  wptLon() {
        if(bearing.text.length !==0 && distance.text.length !== 0){
            return QtPositioning.coordinate(coordinatesBox.resultLat , coordinatesBox.resultLon).atDistanceAndAzimuth(distance.text , bearing.text).longitude
        } else {
            return coordinatesBox.resultLon
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}







