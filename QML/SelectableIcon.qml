import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

CheckBox {
    id:control

    property bool type

    checked: type
    onClicked:{ listTypes[index] = control.checked
        updateFilterType() }
    indicator: Rectangle {
        opacity: 0.8
        implicitWidth: searchRectangle.width /7
        implicitHeight: implicitWidth
        radius: 15
        border.color: Palette.black()
        border.width: 3

        Rectangle {
            width: parent.width
            height: width
            radius: 15
            color: control.down ? Palette.backgroundGrey():Palette.greenSea()
            visible: control.checked
        }

        AnimatedSprite {
            id: cacheIconSprite
            paused: true
            x: parent.width * 0.05
            source: "qrc:/Image/cacheList.png"
            frameCount: 15
            currentFrame: index % 15
            width: parent.width * 0.9
            height: width
            anchors.centerIn: parent
        }
    }

    function updateFilterType()  {
        if(index==0)
            settingsFilterType.traditional = listTypes[0]
        else if (index==1)
            settingsFilterType.mystery = listTypes[1]
        else if (index==2)
            settingsFilterType.multi = listTypes[2]
        else if (index==3)
            settingsFilterType.earth = listTypes[3]
        else if (index==4)
            settingsFilterType.cito = listTypes[4]
        else if (index==5)
            settingsFilterType.ape = listTypes[5]
        else if (index==6)
            settingsFilterType.event = listTypes[6]
        else if (index==7)
            settingsFilterType.giga = listTypes[7]
        else if (index==8)
            settingsFilterType.letterbox = listTypes[8]
        else if (index==9)
            settingsFilterType.mega = listTypes[9]
        else if (index==10)
            settingsFilterType.virtual = listTypes[10]
        else if(index==11)
            settingsFilterType.webcam = listTypes[11]
        else if (index==12)
            settingsFilterType.wherigo = listTypes[12]
        else if (index==13)
            settingsFilterType.gchq = listTypes[13]
        else console.log("Erreur d'index dans SelectableIcon")
    }
}

