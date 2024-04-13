import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions
import com.mycompany.connecting 1.0

Rectangle {
    id: userSettings
    height: parent.height * 0.95
    width: parent.width * 0.95
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
        contentHeight: userSettings.height * 2

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
                width: parent.width * 0.8
                height: columnMaps.height + 40
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    border.color: Palette.greenSea()
                    border.width: 2
                }

                Column {
                    id: columnMaps
                    spacing: 20

                    Repeater {
                        model: 4

                        UserSettingsMap {
                        }
                    }
                }
            }

            //Display Circles
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "CERCLES SUR LES CARTES"
                color: Palette.greenSea()
            }

            GroupBox {
                id: circlesCaches
                width: parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    border.color: Palette.greenSea()
                    border.width: 2
                }

                Column {
                    spacing: 20

                    Repeater {
                        model: 2

                        UserSettingsCircle {
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
                        font.pointSize: 16
                        horizontalAlignment: TextInput.AlignHCenter
                    }
                }
            }

            //maximum number of caches in a list
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "LISTES"
                color: Palette.greenSea()
            }

            GroupBox {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.8
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
                            implicitWidth: userSettings.width * 0.7
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
                        down.indicator: Rectangle {
                            height: parent.height * 0.8
                            width: height
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 5

                            Image {
                                source: "qrc:/Image/minus.png"
                                anchors.fill: parent
                            }
                        }
                        up.indicator: Rectangle {
                            height: parent.height * 0.8
                            width: height
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 5

                            Image {
                                source: "qrc:/Image/plus.png"
                                anchors.fill: parent
                            }
                        }
                    }
                }
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
