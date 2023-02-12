import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions
import com.mycompany.connecting 1.0

Rectangle {
    id: userSettings
    height: parent.height*0.95
    width: parent.width*0.95
    x: -parent.width
    y: -parent.height
    color: Palette.white()
    opacity: 0.8
    radius: 10

    Behavior on x { NumberAnimation { duration: 700 } }
    Behavior on y { NumberAnimation { duration: 700 } }

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        Column {
            anchors.fill: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "CHOIX DES CARTES  "
                color: Palette.greenSea()
            }

            // Maps
            GroupBox {
                id: groupBoxMaps
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    border.color: Palette.greenSea()
                    border.width: 2
                }

                Column {
                    spacing: 35

                    RadioButton {
                        id:button1
                        visible: true
                        text: "Open Street Map"
                        checked: settings.namePlugin === settings.listPlugins[0]
                        onClicked: {
                            settings.sat = false
                            if(settings.namePlugin !== settings.listPlugins[0]) {
                                updateMap(0)
                            }
                        }
                        contentItem: Text {
                            text: button1.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button1.checked ? Palette.greenSea() : Palette.silver()
                            leftPadding: button1.indicator.width + button1.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            y: parent.height / 2 - height / 2
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

                    ButtonTiles {
                        anchors.top: button1.bottom
                        folderTiles: tilesDownloader.dirOsm
                        satTiles: false
                        Component.onCompleted: tilesDownloader.dirSizeFolder(tilesDownloader.dirOsm , false)
                    }

                    RadioButton {
                        id:button2
                        visible: true
                        text: "Google Maps : plan"
                        checked: settings.namePlugin === settings.listPlugins[1] && settings.sat === false
                        onClicked: {
                            settings.sat = false
                            if(settings.namePlugin !== settings.listPlugins[1]) {
                                updateMap(1)
                            }
                        }
                        contentItem: Text {
                            text: button2.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button2.checked ? Palette.greenSea() : Palette.silver()
                            leftPadding: button2.indicator.width + button2.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            y: parent.height / 2 - height / 2
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

                    ButtonTiles {
                        anchors.top: button2.bottom
                        folderTiles: tilesDownloader.dirGooglemaps
                        satTiles: false
                        Component.onCompleted: tilesDownloader.dirSizeFolder(tilesDownloader.dirGooglemaps , false)
                    }

                    RadioButton {
                        id:button3
                        visible: true
                        text: "Google Maps : satellite"
                        checked: settings.namePlugin === settings.listPlugins[1] && settings.sat === true
                        onClicked: {
                            settings.sat = true
                            if(settings.namePlugin !== settings.listPlugins[1]) {
                                updateMap(1)
                            }
                        }
                        contentItem: Text {
                            text: button3.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button3.checked ? Palette.greenSea() : Palette.silver()
                            leftPadding: button3.indicator.width + button3.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            y: parent.height / 2 - height / 2
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

                    ButtonTiles {
                        anchors.top: button3.bottom
                        folderTiles: tilesDownloader.dirGooglemaps
                        satTiles: true
                        Component.onCompleted: tilesDownloader.dirSizeFolder(tilesDownloader.dirGooglemaps , true)
                    }

                    RadioButton {
                        id:button4
                        visible: true
                        text: "Here"
                        checked: settings.namePlugin === settings.listPlugins[2]
                        onClicked: {
                            settings.sat = false
                            if(settings.namePlugin !== settings.listPlugins[2]) {
                                updateMap(2)
                            }
                        }
                        contentItem: Text {
                            text: button4.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button4.checked ? Palette.greenSea() : Palette.silver()
                            leftPadding: button4.indicator.width + button4.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            y: parent.height / 2 - height / 2
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
                color: Palette.greenSea()
            }

            //Display Circles
            GroupBox {
                id: circlesCaches
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    border.color: Palette.greenSea()
                    border.width: 2
                }

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
                            color: buttonCircles.checked ? Palette.greenSea() : Palette.silver()
                            leftPadding: buttonCircles.indicator.width + buttonCircles.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            y: parent.height / 2 - height / 2
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
                            color: buttonCircle.checked ? Palette.greenSea() : Palette.silver()
                            leftPadding: buttonCircle.indicator.width + buttonCircle.spacing
                            verticalAlignment: Text.AlignVCenter
                        }
                        indicator: Rectangle {
                            y: parent.height / 2 - height / 2
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
                        color: Palette.greenSea()
                        font.pointSize: 15
                        placeholderText: qsTr("rayon en km")
                        horizontalAlignment: TextInput.AlignHCenter
                        background: Rectangle {
                            color: Palette.white()
                            radius: 8
                            border.color: Palette.greenSea()
                            border.width: 2
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
                color: Palette.greenSea()
            }

            //maximum number of caches in a list
            GroupBox {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.8
                background: Rectangle {
                    border.color: Palette.greenSea()
                    border.width: 2
                }

                Column {
                    spacing: 15
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text  {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Maximum de caches dans une liste"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
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
                            implicitWidth: userSettings.width/2
                            border.color: Palette.greenSea()
                            border.width: 2
                            radius: 8
                        }
                        contentItem: TextInput {
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            activeFocusOnPress: false
                            text: control.textFromValue(control.value, control.locale)
                            font: control.font
                            color: Palette.greenSea()
                        }
                        up.indicator: Image {
                            anchors.margins: 15
                            anchors.right: parent.right
                            anchors.verticalCenter:  parent.verticalCenter
                            source: "qrc:/Image/plus.png"
                            scale: 0.55
                        }
                        down.indicator: Image  {
                            anchors.margins: 15
                            anchors.left: parent.left
                            anchors.verticalCenter:  parent.verticalCenter
                            source: "qrc:/Image/minus.png"
                            scale: 0.55
                        }
                    }
                }
            }

            // Satellite info
            Text  {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "INFOS SATELLITE"
                font.family: localFont.name
                font.pointSize: 14
                color: Palette.greenSea()
            }

            SatelliteInfo {
                id: satelliteInfo
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.8
                height: parent.height*0.45
            }

            // Disconnect button
            FastButton {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Se déconnecter"
                font.pointSize: 18
                onClicked: {
                    Functions.disconnectAccount()
                    userSettings.hideMenu()
                }
            }
        }
    }

    function addCachesOnMap() {
        if(main.state !== "")
            fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
    }

    function updateMap(index) {
        var center = fastMap.mapItem.center
        fastMap.deleteMap()
        settings.namePlugin = settings.listPlugins[index]
        fastMap.createMap()
        fastMap.mapItem.center = center
        addCachesOnMap()
    }

    function closeIfMenu() {
    }

    function showMenu() {
        console.log("Show menu...")
        userSettings.x = 0
        userSettings.y = 0
    }

    function hideMenu() {
        console.log("Hide menu...")
        userSettings.x = userSettings.width * -1
        userSettings.y = userSettings.height * -1
    }

    function isMenuVisible() {
        return (userSettings.x === 0)
    }
}
