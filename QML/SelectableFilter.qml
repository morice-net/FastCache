import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: selectableFilter
    width: parent.width
    height: 50

    property string filterText: ""

    Row {
        spacing: selectableFilter.width / 2 - 100
        width: parent.width * 0.9

        Text {
            horizontalAlignment: Text.AlignHCenter
            font.family: localFont.name
            font.pointSize: 18
            color: Palette.greenSea()
            width: parent.width
            text: selectableFilter.filterText
        }
    }
}
