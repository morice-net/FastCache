import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: fastSelectableButtonMenu
    height: parent.height * 0.12
    width: parent.width
    property bool buttonSelected
    property string buttonText
    
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 2
        color: fastSelectableButtonMenu.buttonSelected ? Palette.greenSea() : Palette.turquoise()
        
        Text {
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 24
            text: fastSelectableButtonMenu.buttonText
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: fastSelectableButtonMenu.buttonSelected ? Palette.turquoise() : Palette.white()
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                buttonClicked()
            }
        }
    }
}