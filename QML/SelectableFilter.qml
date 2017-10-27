import QtQuick 2.3

import "JavaScript/Palette.js" as Palette

Item {
    id: selectableFilter
    width: parent.width
    height: 60
    property bool filterSelected: true
    property string filterText: ""

    Row {
        spacing: selectableFilter.width / 2 - 100
        width: searchRectangle.width

        Text {
            text: " " + selectableFilter.filterText
            font.family: localFont.name
            font.pointSize: 22
            color: Palette.black()
            width: selectableFilter.width/2

        }
    }

}
