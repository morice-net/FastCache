import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

FastPopup {
    id: userInfoPopup

    Item {
        id: userInfoTopPopup
        height: parent.height * 0.3
        width: parent.width

        Column {
            anchors.fill: parent
            spacing: 10

            /// User Info
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                height: userInfoTopPopup.height * 0.5
                width: height
                source: userInfo.avatarUrl
            }

            Text {
                height: userInfoTopPopup.height * 0.29
                width: parent.width
                text: userInfo.name
                font.family: localFont.name
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: userInfoTopPopup.height * 0.2
                color: Palette.white()
            }

            Text {
                height: userInfoTopPopup.height * 0.19
                width: parent.width
                text: findCount + " caches trouvées (" + userInfo.premium + ")"
                font.family: localFont.name
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: userInfoTopPopup.height * 0.1
                color: Palette.white()
            }

            // Maps
            Text {
                width: parent.width
                font.family: localFont.name
                leftPadding: 5
                font.pointSize: 14
                text: "CHOIX DES CARTES  "
                color: Palette.silver()
            }

            GroupBox {
                id: groupBoxMaps
                width: parent.width*0.7

                Column {

                    RadioButton {
                        id:button1
                        visible: true
                        text: "Open Street Map"
                        checked: settings.name === "osm"
                        onClicked: {
                            settings.name = "osm"
                            settings.sat = false
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
                        checked: settings.name === "googlemaps" && settings.sat === false
                        onClicked: {
                            settings.name = "googlemaps"
                            settings.sat = false
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
                        checked: settings.name === "googlemaps" && settings.sat === true
                        onClicked: {
                            settings.name = "googlemaps"
                            settings.sat = true
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

    function closeIfMenu() {
    }
}
