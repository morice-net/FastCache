import QtQuick 2.6

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0


FastPopup {
    id: userInfoPopup

    /// User Info ///
    Item {
        id: userInfoTopPopup
        height: parent.height * 0.3
        width: parent.width

        Column {
            spacing: 10
            anchors.fill: parent

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
                color: Palette.black()
            }
            Text {
                height: userInfoTopPopup.height * 0.19
                width: parent.width
                text: findCount + " caches trouvées (" + userInfo.premium + ")"
                font.family: localFont.name
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: userInfoTopPopup.height * 0.1
                color: Palette.greenSea()
            }

        }
    }

    /// Travel bugs ///
    Column {
        spacing: 10
        anchors.top: userInfoTopPopup.bottom
        anchors.bottom: disconnectButtonPopup.top
        anchors.left: userInfoPopup.left
        anchors.right: userInfoPopup.right
        anchors.margins: 10
        anchors.topMargin: parent.height * 0.1

        Repeater {
            model: getTravelbugUser.tbsCode.length

            Item {
                height: userInfoPopup.height * 0.2
                width: userInfoPopup.width
                Row {
                    anchors.fill: parent
                    Image {
                        source: "qrc:/Image/" + "trackable_travelbug.png"
                        scale: 1.4
                    }


                    Text {
                        text: getTravelbugUser.trackingNumbers[index]
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 14
                        color: Palette.black()
                    }

                    Text {
                        text: getTravelbugUser.tbsName[index]
                        font.family: localFont.name
                        textFormat: Qt.RichText
                        font.bold: true
                        font.pointSize: 14
                        color: Palette.black()
                        wrapMode: Text.Wrap
                    }

                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        travelbug.sendRequest(connector.tokenKey , getTravelbugUser.tbsCode[index]);
                        main.viewState = "travelbug"
                        userInfoPopup.close()
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
