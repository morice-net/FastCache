import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: fastDoubleButtonMenu
    height: parent.height * 0.12
    width: parent.width
    property bool firstButtonSelected
    property string button1Text
    property string button2Text

    Rectangle {
        radius: 20
        anchors.margins: 20
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 2
        color: Palette.greenSea()

        Rectangle {
            radius: 20
            height: parent.height
            width: parent.width/2
            x: fastDoubleButtonMenu.firstButtonSelected ? 0 : parent.width/2
            color: Palette.turquoise()

            Behavior on x { PropertyAnimation { duration: 400 } }
        }

        Row {
            anchors.fill: parent
            Text {
                width: parent.width/2
                height: parent.height
                font.family: localFont.name
                font.pointSize: 24
                text: fastDoubleButtonMenu.button1Text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: fastDoubleButtonMenu.firstButtonSelected ? Palette.white() : Palette.turquoise()
            }
            Text {
                width: parent.width/2
                height: parent.height
                font.family: localFont.name
                font.pointSize: 24
                text: fastDoubleButtonMenu.button2Text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: fastDoubleButtonMenu.firstButtonSelected ? Palette.turquoise() : Palette.white()
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                buttonClicked()
            }
        }
    }
}
