import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: selectableFilter
    width: parent.width
    height: 60

    property string filterText: ""

    Row {
        spacing: selectableFilter.width / 2 - 100
        width: searchRectangle.width

        Text {
            horizontalAlignment: Text.AlignHCenter
            font.family: localFont.name
            font.pointSize: 22
            color: Palette.black()
            width: parent.width
            text: selectableFilter.filterText

        }
    }
}
