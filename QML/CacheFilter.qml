import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: cacheFilter
    anchors.top: parent.bottom
    width: parent.width * 0.8
    x: parent.width * 0.1

    opacity: 0
    visible:  opacity > 0

    Behavior on opacity { NumberAnimation { duration: 500 } }

    Rectangle {
        x: 5
        y: 5
        id: searchRectangle
        color: Palette.white()
        radius: 3
        border.width: 1
        border.color: Palette.silver().replace("#", "#66")

        property int destWidth: parent.width * 0.75
        width: parent.width
        height: main.height * 0.4
        anchors.top: filterHeadArrow.bottom
        anchors.margins: -2

        Column {
            Text {
                x: 10
                text: "Par type"
                font.family: "Roboto"
                font.pointSize: 12
                color: Palette.black()
            }

            Grid {
                columns: 7
                Repeater {
                    model: 14
                    SelectableIcon {
                        type: index
                    }
                }
            }
        }
    }

    Image {
        id: filterHeadArrow
        source: "qrc:/Image/filterHeadArrow.png"
    }

}
