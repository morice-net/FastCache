import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: sureQuit
    anchors.fill: parent
    color: Palette.turquoise()
    visible: false

    Text {
        id: sureQuitText
        anchors.centerIn: parent
        text: "Etes-vous sur de vouloir\n   quitter FastCache ?"
        font.family: localFont.name
        font.pointSize: 28
        color: Palette.white()
    }

    Row {
        width: parent.width * 0.8
        height: parent.height * 0.12
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: parent.height * 0.1
        spacing: 10

        Item {
            height: parent.height
            width: parent.width / 2 - 5

            Rectangle {
                radius: 20
                anchors.margins: 20
                anchors.fill: parent
                anchors.topMargin: 20
                anchors.bottomMargin: 2
                color: Palette.white()

                Text {
                    anchors.fill: parent
                    font.family: localFont.name
                    font.pointSize: 24
                    text: "Oui"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Palette.turquoise()
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.quit()
                    }
                }
            }
        }
        Item {
            height: parent.height
            width: parent.width / 2 - 5

            Rectangle {
                radius: 20
                anchors.margins: 20
                anchors.fill: parent
                anchors.topMargin: 20
                anchors.bottomMargin: 2
                color: Palette.white()

                Text {
                    anchors.fill: parent
                    font.family: localFont.name
                    font.pointSize: 24
                    text: "Non"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Palette.turquoise()
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sureQuit.visible = false
                        main.forceActiveFocus()
                    }
                }
            }
        }
    }

}
