import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions
import com.mycompany.connecting 1.0

FastPopup {
    id: userSettingsPopup
    backgroundOpacity: 0.9
    backgroundColor: Palette.black()
    closeButtonVisible: false

    property var listPlugins: ["osm", "googlemaps", "here"]

    Item {
        id: userInfoTopPopup
        height: parent.height * 0.3
        width: parent.width

        Column {
            anchors.fill: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "CHOIX DES CARTES  "
                color: Palette.white()
            }

            // Maps
            GroupBox {
                id: groupBoxMaps
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter

                Column {

                    RadioButton {
                        id:button1
                        visible: true
                        text: "Open Street Map"
                        checked: settings.namePlugin === listPlugins[0]
                        onClicked: {
                            settings.sat = false
                            if(settings.namePlugin !== listPlugins[0]) {
                                updateMap(0)
                            }
                        }
                        contentItem: Text {
                            text: button1.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button1.checked ? Palette.white() : Palette.silver()
                            leftPadding: button1.indicator.width + button1.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button1.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button2
                        visible: true
                        text: "Google Maps : plan"
                        checked: settings.namePlugin === listPlugins[1] && settings.sat === false
                        onClicked: {
                            settings.sat = false
                            if(settings.namePlugin !== listPlugins[1]) {
                                updateMap(1)
                            }
                        }
                        contentItem: Text {
                            text: button2.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button2.checked ? Palette.white() : Palette.silver()
                            leftPadding: button2.indicator.width + button2.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button2.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button3
                        visible: true
                        text: "Google Maps : satellite"
                        checked: settings.namePlugin === listPlugins[1] && settings.sat === true
                        onClicked: {
                            settings.sat = true
                            if(settings.namePlugin !== listPlugins[1]) {
                                updateMap(1)
                            }
                        }
                        contentItem: Text {
                            text: button3.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button3.checked ? Palette.white() : Palette.silver()
                            leftPadding: button3.indicator.width + button3.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button3.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button4
                        visible: true
                        text: "Here"
                        checked: settings.namePlugin === listPlugins[2]
                        onClicked: {
                            settings.sat = false
                            if(settings.namePlugin !== listPlugins[2]) {
                                updateMap(2)
                            }
                        }
                        contentItem: Text {
                            text: button4.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button4.checked ? Palette.white() : Palette.silver()
                            leftPadding: button4.indicator.width + button4.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button4.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "CERCLES SUR LES CARTES"
                color: Palette.white()
            }

            //Display Circles
            GroupBox {
                id: circlesCaches
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter

                Column {

                    Switch {
                        id:buttonCircles
                        visible: true
                        text: "Cerles autour des caches"
                        checked: settings.circlesCaches
                        onClicked: {
                            settings.circlesCaches = !settings.circlesCaches
                            fastMap.clearMap()
                            addCachesOnMap()
                        }
                        contentItem: Text {
                            text: buttonCircles.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: buttonCircles.checked ? Palette.white() : Palette.silver()
                            leftPadding: buttonCircles.indicator.width + buttonCircles.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: buttonCircles.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    Switch {
                        id:buttonCircle
                        visible: true
                        text: "Cercle (rayon en km) "
                        checked: settings.circleMap
                        onClicked: {
                            settings.circleMap = !settings.circleMap
                            fastMap.mapItem.deleteCircleRadius()
                            if(settings.circleMap && distance.text !== "")
                                fastMap.mapItem.createCircleRadius(settings.circleMapRadius)
                        }
                        contentItem: Text {
                            text: buttonCircle.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: buttonCircle.checked ? Palette.white() : Palette.silver()
                            leftPadding: buttonCircle.indicator.width + buttonCircle.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: buttonCircle.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    TextField {
                        id: distance
                        anchors.horizontalCenter: parent.horizontalCenter
                        validator: DoubleValidator {
                            bottom: 0.0;
                            top: 200.0;
                            decimals: 3;
                            notation: DoubleValidator.StandardNotation
                        }
                        text: settings.circleMapRadius.toLocaleString()
                        onTextChanged:
                        {
                            if(!acceptableInput) {
                                distance.text = ""
                            } else {
                                settings.circleMapRadius = distance.text.replace(',', '.')
                                if(settings.circleMap) {
                                    fastMap.mapItem.deleteCircleRadius()
                                    fastMap.mapItem.createCircleRadius(settings.circleMapRadius)
                                }
                            }
                        }
                        color: Palette.turquoise()
                        font.pointSize: 15
                        placeholderText: qsTr("rayon en km")
                        horizontalAlignment: TextInput.AlignLeft
                        background: Rectangle {
                            color: Palette.white()
                            radius: 10
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "LISTES"
                color: Palette.white()
            }

            //maximum number of caches in a list
            GroupBox {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.8

                Column {
                    spacing: 15
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text  {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Maximum de caches dans une liste"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.white()
                    }

                    SpinBox {
                        id: control
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 16
                        from: 50
                        to: 300
                        stepSize: 50
                        value: settings.maxCachesInList
                        onValueChanged: settings.maxCachesInList = control.value
                        background: Rectangle {
                            implicitWidth: userSettingsPopup.width/3.2
                            border.color: Palette.black()
                            radius: 10
                        }
                        contentItem: TextInput {
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            activeFocusOnPress: false
                            text: control.textFromValue(control.value, control.locale)
                            font: control.font
                            color: Palette.turquoise()
                        }
                        up.indicator: Image {
                            anchors.margins: 15
                            anchors.right: parent.right
                            anchors.verticalCenter:  parent.verticalCenter
                            source: "qrc:/Image/plus.png"
                            scale: 1.3
                        }
                        down.indicator: Image  {
                            anchors.margins: 15
                            anchors.left: parent.left
                            anchors.verticalCenter:  parent.verticalCenter
                            source: "qrc:/Image/minus.png"
                            scale: 1.3
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "MODIFIER MES LOGS DE CACHES"
                color: Palette.white()
            }

            //modifications to user logs
            GroupBox {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.8

                Column {
                    spacing: 15
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextField {
                        id: geocodeCache
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 20
                        color: Palette.turquoise()
                        font.capitalization: Font.AllUppercase
                        font.pointSize: 16
                        placeholderText: "GC               "
                        background: Rectangle {
                            color: Palette.white()
                            radius: 10
                        }
                        onPressAndHold: {
                            if(geocodeCache.text !== "") {
                                getUserGeocacheLogs.sendRequest(connector.tokenKey , geocodeCache.text.toLocaleUpperCase())
                                userGeocacheLogs.open()
                            }
                        }
                    }
                }
            }
        }
    }

    /// Disconnect button ///
    Item {
        id: disconnectButtonPopup
        height: parent.height * 0.12
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: parent.height * 0.05

        Rectangle {
            radius: 20
            anchors.fill: parent
            anchors.margins: 20
            color: Palette.silver()

            Text {
                id: connectButtonName
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 24
                text: "Se déconnecter"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Functions.disconnectAccount()
                    userSettingsPopup.close()
                }
            }
        }
    }

    UserGeocacheLogs {
        id: userGeocacheLogs
        backgroundWidth: main.width*0.9
    }

    function addCachesOnMap() {
        if(main.state !== "")
            fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
    }

    function updateMap(index) {
        var center = fastMap.mapItem.center
        fastMap.deleteMap()
        settings.namePlugin = listPlugins[index]
        fastMap.createMap()
        fastMap.mapItem.center = center
        addCachesOnMap()
    }

    function closeIfMenu() {
    }
}
