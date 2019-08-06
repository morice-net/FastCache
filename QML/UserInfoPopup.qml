import QtQuick 2.6

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0


FastPopup {
    id: userInfoPopup

    background: Rectangle {
        anchors.fill: parent
        implicitWidth: main.width
        implicitHeight:main.height
        color: Palette.turquoise()
        radius: 10
    }

    Item {
        id: connectButtonMenu
        height: parent.height * 0.12
        width: parent.width * 0.9
        anchors.centerIn: parent

        Rectangle {
            id: connectButtonMenuRectangle
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
