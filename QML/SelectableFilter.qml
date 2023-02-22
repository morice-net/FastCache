import QtQuick

import "JavaScript/Palette.js" as Palette

Item {
    id: selectableFilter
    height: 5

    property string filterText: ""

    Text {
        horizontalAlignment: Text.AlignHCenter
        font.family: localFont.name
        font.pointSize: 18
        color: Palette.greenSea()
        width: parent.width
        text: selectableFilter.filterText
    }
}

