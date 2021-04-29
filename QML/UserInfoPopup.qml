import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

FastPopup {
    id: userInfoPopup
    backgroundOpacity: 0.9

    property var listPlugins: ["osm", "googlemaps", "here"]

    Item {
        id: userInfoTopPopup
        height: parent.height * 0.3
        width: parent.width

        /// User Info
        Row {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 10
            visible: userInfo.name.length > 0

            Image {
                id: userInfoIcon
                height: userInfoTopPopup.height * 0.5
                width: height
                source: userInfo.avatarUrl
            }

            Column {
                height: userInfoIcon.height
                clip: true
                spacing: 10

                Text {
                    height: parent.height * 0.29
                    text: userInfo.name
                    font.family: localFont.name
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height
                    color: Palette.white()
                    onTextChanged: {
                        if (text === "") return
                        while (width > (userInfoTopPopup.width*0.85 - userInfoIcon.width - 20)) font.pixelSize--
                    }
                }

                Text {
                    height: parent.height * 0.25
                    text: findCount + " caches trouvées"
                    font.family: localFont.name
                   verticalAlignment: Text.AlignBottom
                    font.pixelSize: height
                    font.italic: true
                    color: Palette.white()
                    onTextChanged: {
                        if (text === "0 caches trouvées") return
                        while (width > (userInfoTopPopup.width*0.85 - userInfoIcon.width - 20)) font.pixelSize--
                    }
                }

                Text {
                    height: parent.height * 0.25
                    text: "Membre : " + userInfo.premium
                    font.family: localFont.name
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: height
                    font.italic: true
                   color: Palette.white()
                    onTextChanged: {
                        if (text === "Membre : ") return
                        while (width > (userInfoTopPopup.width*0.85 - userInfoIcon.width - 20)) font.pixelSize--
                    }
                }
            }
        }

        Column {
            topPadding: userInfoIcon.height + 20
            anchors.fill: parent
            spacing: 10

            Text {
                width: parent.width
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "CHOIX DES CARTES  "
                color: Palette.silver()
            }

            // Maps
            GroupBox {
                id: groupBoxMaps
                width: parent.width*0.7

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

            //Display Circles
            GroupBox {
                id: circlesCaches
                width: parent.width*0.7

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
        }
    }

    /// Disconnect button ///
    Item {
        id: disconnectButtonPopup
        height: parent.height * 0.12
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: parent.height * 0.05

        Rectangle {
            radius: 20
            anchors.fill: parent
            anchors.margins: 20
            color: Palette.turquoise()

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
                    main.disconnectAccount()
                    userInfoPopup.close()
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
        settings.namePlugin = listPlugins[index]
        fastMap.createMap()
        fastMap.mapItem.center = center
        addCachesOnMap()
    }

    function closeIfMenu() {
    }
}
