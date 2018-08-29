import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Popup {
    id: coordinatesBox
    background: Rectangle {
        x:30
        y:30
        implicitWidth: main.width*0.8
        implicitHeight:main.height*0.8
        color:Palette.turquoise()
        border.color: Palette.turquoise()
        radius: 10
    }
}
