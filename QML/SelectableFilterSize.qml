import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

CheckBox {
    id: control

    property list <string> listSizeFr: ["Micro" , "Petite" , "Normale" , "Grande" , "Non renseignée" , "Virtuelle" , "Autre"]

    checked: listSizes[index]
    onClicked: {
        main.listSizes[index] = control.checked
        textSizeButton()
        updateFilterSize()


    }
    onPressAndHold: {
        updatelistSizes(!listSizes[index])
        textSizeButton()
    }
    contentItem: Text {
        text: listSizeFr[index]
        font.family: localFont.name
        font.pointSize: 16
        color: control.checked ? Palette.white() : Palette.silver()
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: implicitWidth
        radius: 3
        border.width: 1
        y: parent.height / 2 - height / 2

        Rectangle {
            anchors.fill: parent
            visible: control.checked
            color: Palette.greenSea()
            radius: 3
            anchors.margins: 4
        }
    }
    Component.onDestruction: {
        settings.micro = listSizes[0]
        settings.small = listSizes[1]
        settings.regular = listSizes[2]
        settings.large = listSizes[3]
        settings.notChosen = listSizes[4]
        settings.virtualSize = listSizes[5]
        settings.other = listSizes[6]
    }

    function updateFilterSize()  {
        mainItem.forceActiveFocus()
        if(index === 0)
            settings.micro = main.listSizes[0]
        else if (index === 1)
            settings.small = main.listSizes[1]
        else if (index === 2)
            settings.regular = main.listSizes[2]
        else if (index === 3)
            settings.large = main.listSizes[3]
        else if (index === 4)
            settings.notChosen = main.listSizes[4]
        else if (index === 5)
            settings.virtualSize = main.listSizes[5]
        else if (index === 6)
            settings.other= main.listSizes[6]
        else console.log("Erreur d'index dans SelectableSize")
    }

    function updatelistSizes(flag) {
        var list = []
        for (var i = 0; i < listSizes.length; i++) {
            list.push(flag)
        }
        listSizes = list
    }
}


