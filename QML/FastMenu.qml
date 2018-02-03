import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: fastMenu
    anchors.fill: parent

    Rectangle {
        id: menuShadow
        anchors.fill: parent
        visible: false

        color: Palette.black()
        opacity: 0

        Behavior on opacity { NumberAnimation { duration: 1200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: fastMenu.hideMenu()
        }

        onOpacityChanged: {
            visible = opacity > 0 ? true : false
        }
    }

    Rectangle {
        id: menu
        width: parent.width * 0.8
        height: parent.height
        x: -parent.width
        color: Palette.white()
        clip: true

        Behavior on x { NumberAnimation { duration: 600 } }

        ///////////////////////////////////////////////////////////////////////////
        //                      user info on the top of the menu                 //
        ///////////////////////////////////////////////////////////////////////////
        Item {
            id: userInfoMenu
            height: parent.height * 0.12
            width: parent.width

            Row {
                x: 10
                y: 10
                spacing: 10
                Image {
                    height: userInfoMenu.height - 20
                    width: height
                    source: userInfo.avatarUrl
                }
                Column {
                    Text {
                        text: userInfo.name
                        font.family: localFont.name
                        font.pixelSize: userInfoMenu.height * 0.45
                        color: Palette.black()
                    }
                    Text {
                        text: userInfo.finds + " caches trouvées (" + userInfo.premium + ")"
                        font.family: localFont.name
                        font.pixelSize: userInfoMenu.height * 0.2
                        color: Palette.greenSea()
                    }
                }
            }
        }

        ///////////////////////////////////////////////////////////////////////////
        //                      button on the bottom of the menu                 //
        ///////////////////////////////////////////////////////////////////////////
        Item {
            id: connectButtonMenu
            height: parent.height * 0.12
            width: parent.width
            y: parent.height - height - 20

            Rectangle {
                anchors.fill: parent
                anchors.margins: 20
                color: Palette.turquoise()

                Text {
                    id: connectButtonName
                    anchors.fill: parent
                    font.family: localFont.name
                    font.pointSize: 24
                    text: userInfo.name.length > 0 ? "Se déconnecter" : "Se connecter"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Palette.white()
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (connectButtonName.text == "Se connecter")
                            main.reconnectAccount()
                        else
                            main.disconnectAccount()
                    }
                }
            }
        }
        // Footer
    }


    function showMenu() {
        console.log("Show menu...")
        menu.x = 0
        menuShadow.opacity = 0.5
    }

    function hideMenu() {
        console.log("Hide menu...")
        menu.x = menu.width * -1
        menuShadow.opacity = 0
    }

}
