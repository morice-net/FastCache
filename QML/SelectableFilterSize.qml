import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

CheckBox {
    id: control

    property bool sizeCache
    property var listSizeFr: ["Micro" , "Petite" , "Normale" , "Grande" , "Non renseignée" , "Virtuelle" , "Autre"]

    checked: sizeCache
    onClicked: {
        main.listSizes[index] = control.checked
        updateFilterSize()
    }
    onPressAndHold: updatelistSizes(!sizeCache)
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
    Component.onCompleted: textSizeButton()
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
        main.forceActiveFocus()
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

    function textSizeButton() {
        if(listSizes[0] && listSizes[1] && listSizes[2] && listSizes[3] && listSizes[4] && listSizes[5] && listSizes[6])
        {
            textButtonId.text = "Toutes..."
            return
        }
        var textArray = ""
        if(listSizes[0]) {
            textArray += "Mc "
        }
        if(listSizes[1]) {
            textArray += "Pt "
        }
        if(listSizes[2]) {
            textArray += "Nm "
        }
        if(listSizes[3]) {
            textArray += "Gr "
        }
        if(listSizes[4]) {
            textArray += "NonRenseignée "
        }
        if(listSizes[5]) {
            textArray += "Virt "
        }
        if(listSizes[6]) {
            textArray += "Autre "
        }
        if(textArray === "")
            textArray = "Aucune"
        textButtonId.text = textArray
    }

    function updatelistSizes(flag) {
        var list = []
        for (var i = 0; i < listSizes.length; i++) {
            list.push(flag)
        }
        listSizes = list
    }
}


