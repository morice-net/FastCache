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

        Column {
            anchors.fill: parent
            spacing: 10

            /// User Info
            Image {
                height: userInfoTopPopup.height * 0.5
                width: height
                source: userInfo.avatarUrl
            }

            Text {
                height: userInfoTopPopup.height * 0.29
                width: parent.width
                text: userInfo.name
                font.family: localFont.name
                font.pixelSize: userInfoTopPopup.height * 0.2
                color: Palette.white()
            }

            Text {
                height: userInfoTopPopup.height * 0.19
                width: parent.width
                text: findCount + " caches trouvées"
                font.family: localFont.name
                font.italic: true
                font.pixelSize: userInfoTopPopup.height * 0.1
                color: Palette.white()
            }

            Text {
                height: userInfoTopPopup.height * 0.19
                width: parent.width
                text:  "Membre : " + userInfo.premium
                font.family: localFont.name
                font.italic: true
                font.pixelSize: userInfoTopPopup.height * 0.1
                color: Palette.white()
            }

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
                id: circlesMap
                width: parent.width*0.7

                RadioButton {
                    id:buttonCircles
                    visible: true
                    text: "Affichage des cercles"
                    checked: settings.circlesMap
                    onClicked: {
                        settings.circlesMap = !settings.circlesMap
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
