import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

CheckBox {
    id: control

    property bool type

    checked: type
    onClicked: {
        main.listTypes[index] = control.checked
        updateFilterType()
    }
    indicator: Rectangle {
        opacity: 0.8
        implicitWidth: control.width
        implicitHeight: implicitWidth
        radius: 8
        border.color: Palette.black()
        border.width: 2

        Rectangle {
            width: parent.width
            height: width
            radius: 8
            color: control.down ? Palette.backgroundGrey():Palette.greenSea()
            visible: control.checked
        }

        AnimatedSprite {
            id: cacheIconSprite
            running: false
            source: "qrc:/Image/cacheList.png"
            frameCount: 15
            currentFrame: index
            width: parent.width * 0.9
            height: width
        }
    }

    function updateFilterType()  {
        main.forceActiveFocus()
        if(index === 0)
            settings.traditional = main.listTypes[0]
        else if (index === 1)
            settings.mystery = main.listTypes[1]
        else if (index === 2)
            settings.multi = main.listTypes[2]
        else if (index === 3)
            settings.earth = main.listTypes[3]
        else if (index === 4)
            settings.cito = main.listTypes[4]
        else if (index === 5)
            settings.ape = main.listTypes[5]
        else if (index === 6)
            settings.event= main.listTypes[6]
        else if (index === 7)
            settings.giga = main.listTypes[7]
        else if (index === 8)
            settings.letterbox = main.listTypes[8]
        else if (index === 9)
            settings.mega = main.listTypes[9]
        else if (index === 10)
            settings.virtual = main.listTypes[10]
        else if(index === 11)
            settings.webcam = main.listTypes[11]
        else if (index === 12)
            settings.wherigo = main.listTypes[12]
        else if (index === 13)
            settings.gchq = main.listTypes[13]
        else console.log("Erreur d'index dans SelectableIcon")
    }
}

