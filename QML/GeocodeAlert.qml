import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Popup {
    id: geocodeAlert
    background: Rectangle {
        x:20
        y:main.height/3
        implicitWidth: main.width*0.8
        implicitHeight:main.height*0.08
        color:Palette.turquoise()
        border.color: Palette.greenSea()
        radius: 10
    }

    ColumnLayout {
        x:27
        y: main.height/3
        height: tabTitle.height * 2

        Label {
            id: tabTitle
            color: Palette.white()
            text: qsTr("Le plugin ne gère pas le géocoding.")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Behavior on opacity { NumberAnimation { duration: 800 } }
}



