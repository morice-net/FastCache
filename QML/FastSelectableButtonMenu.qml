import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: fastSelectableButtonMenu
    height: parent.height * 0.12
    width: parent.width
    property bool buttonSelected
    property string buttonText
    property bool centered: true
    property bool centeredVertical: true
    
    Rectangle {
        radius: 20
        anchors.margins: 20
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 2
        color: fastSelectableButtonMenu.buttonSelected ? Palette.greenSea() : Palette.turquoise()
        
        Text {
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 24
            text: fastSelectableButtonMenu.buttonText
            verticalAlignment: centeredVertical ? Text.AlignVCenter :  Text.AlignTop
            horizontalAlignment: centered ? Text.AlignHCenter : Text.AlignLeft
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
