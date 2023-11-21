import QtQuick
import QtQuick.Controls
import QtPositioning
import QtLocation

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

import com.mycompany.connecting 1.0

FastPopup {
    id: userWaypoint
    backgroundColor: Palette.greenSea()

    property string textLog: ""
    property double userWptLat: wptLat()
    property double userWptLon: wptLon()
    property string addLog: ""

    onTextLogChanged: description.text = description.text + textLog
    onAddLogChanged: {
        console.log("addLog: " + addLog)
        if(addLog !== "") {
            description.insert(description.cursorPosition , addLog)
            addLog = ""
        }
    }
    onUserWptLatChanged: lat.text = "Latitude :  " +  Functions.formatLat(userWptLat.toFixed(5))
    onUserWptLonChanged: lon.text = "Longitude :  " + Functions.formatLon(userWptLon.toFixed(5))

    AddTextLog {
        id:addText
    }

    Column {
        y: 10
        spacing: 10
        width: parent.width

        FastButton {
            id:coordinates
            anchors.horizontalCenter: parent.horizontalCenter
            y: 10
            text: "Coordonnées"
            font.pointSize: 18
            onClicked: {
                coordinatesBox.backgroundOpacity = 1
                coordinatesBox.open()
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 14
            text: "Relèvement en degrés"
            color: Palette.white()
        }

        TextField {
            id: bearing
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            implicitWidth: userWaypoint.width/4
            font.family: localFont.name
            font.pointSize: 17
            color: Palette.greenSea()
            validator: DoubleValidator {bottom: 0.0; top: 360.0;  decimals: 3; notation: DoubleValidator.StandardNotation}
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 14
            text: "Distance en mètres"
            color: Palette.white()
        }

        TextField {
            id: distance
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            implicitWidth: userWaypoint.width/4
            font.family: localFont.name
            font.pointSize: 17
            color: Palette.greenSea()
            validator: DoubleValidator {bottom: 0.0; top: 100000.0;  decimals: 3; notation: DoubleValidator.StandardNotation}
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        GroupBox {
            width: userWaypoint.width * 0.6
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: lat
                    text: "Latitude :  " + Functions.formatLat(0.0)
                    font.family: localFont.name
                    font.pointSize: 15
                    color: Palette.white()
                }

                Text {
                    id: lon
                    text: "Longitude :  " + Functions.formatLon(0.0)
                    font.family: localFont.name
                    font.pointSize: 15
                    color: Palette.white()
                }
            }
        }

        CheckBox {
            id: corrected
            anchors.horizontalCenter: parent.horizontalCenter
            visible: (fastCache.userWptAdd === true && !fullCache.isCorrectedCoordinates)
            text: qsTr("Utiliser comme coordonnées de la cache")
            font.pointSize: 15
            checked: false
            indicator: Rectangle {
                implicitWidth: 20
                implicitHeight: 20
                y: parent.height / 2 - height / 2
                radius: 2
                border.color: corrected.down ? Palette.turquoise() : Palette.greenSea()

                Rectangle {
                    width: 14
                    height: 14
                    anchors.centerIn: parent
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

        Item {
            anchors.margins: 20
            anchors.left: parent.left
            anchors.right: parent.right
            height: childrenRect.height

            Text {
                id: descriptionTitle
                visible: visibleDescription()
                font.family: localFont.name
                font.pointSize: 17
                text: "Description de l'étape"
                color: Palette.white()
            }

            FastButtonIcon {
                id: buttonAdd
                visible: visibleDescription()
                y: descriptionTitle.y - buttonAdd.height / 4
                source: "qrc:/Image/" + "icon_edit.png"
                anchors.right: buttonDelete.left
                anchors.margins: 10
                height: 40
                width: 30
                onClicked:{
                    addText.open();
                    textLog = "" ;
                }
            }

            FastButtonIcon {
                id: buttonDelete
                visible: visibleDescription()
                y: descriptionTitle.y - buttonDelete.height / 4
                anchors.right: parent.right
                source: "qrc:/Image/" + "icon_erase.png"
                height: 40
                width: 30
                onClicked:{
                    description.text = ""
                }
            }
        }

        TextArea {
            id: description
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            visible: visibleDescription()
            font.family: localFont.name
            font.pointSize: 14
            color: Palette.turquoise()
            wrapMode: Text.Wrap
            background: Rectangle {
                radius: 5
                implicitHeight: userWaypoint.height * 0.2
            }
        }

        FastButton {
            id:send
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Envoyer"
            font.pointSize: 18
            onClicked:{
                // Update the compass page
                if(correctCoordinates()) {
                    fastCache.compassPageInit("Correction de coordonnées" , userWptLat , userWptLon)
                } else {
                    fastCache.compassPageInit("Etape personnelle" , userWptLat , userWptLon)
                }

                if(fastCache.userWptAdd === true){
                    // Add userWaypoint or create modification of coordinates
                    sendUserWaypoint.sendRequest(connector.tokenKey , fullCache.geocode , userWptLat , userWptLon , correctCoordinates() ,
                                                 description.text , true);
                    userWaypoint.visible = false;
                } else if(fastCache.userWptAdd === false && fastCache.userCorrectedCoordinates === false){
                    // Modifie userWaypoint
                    sendUserWaypoint.sendRequest(connector.tokenKey , fastCache.userWptCode , userWptLat , userWptLon , corrected.checked ,
                                                 description.text , false);
                    userWaypoint.visible = false;
                } else if(fastCache.userWptAdd === false && fastCache.userCorrectedCoordinates === true){
                    // Modifie corrected coordinates
                    sendUserWaypoint.sendRequest(connector.tokenKey , fullCache.geocode , userWptLat , userWptLon , true , "" , false);
                    userWaypoint.visible = false;
                }
            }
        }
    }

    function  wptLat() {
        if(bearing.text.length !==0 && distance.text.length !== 0){
            return QtPositioning.coordinate(coordinatesBox.resultLat , coordinatesBox.resultLon).
            atDistanceAndAzimuth(parseFloat(distance.text.replace(',', '.')) , parseFloat(bearing.text.replace(',', '.'))).latitude
        } else {
            return coordinatesBox.resultLat
        }
    }

    function  wptLon() {
        if(bearing.text.length !==0 && distance.text.length !== 0){
            return QtPositioning.coordinate(coordinatesBox.resultLat , coordinatesBox.resultLon)
            .atDistanceAndAzimuth(parseFloat(distance.text.replace(',', '.')) , parseFloat(bearing.text.replace(',', '.'))).longitude
        } else {
            return coordinatesBox.resultLon
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }

    function correctCoordinates() {
        if (!corrected.visible)
            return false
        return corrected.checked
    }

    function visibleDescription() {
        if (!corrected.visible && fastCache.userWptAdd === false && fastCache.userCorrectedCoordinates === true )
            return false
        if(!corrected.visible){
            return true
        } else {
            return !corrected.checked
        }
    }
}







