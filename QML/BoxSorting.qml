import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: groupBoxSorting
    x: parent.width/3
    y:parent.height/8

    GroupBox {
        id:control
        background: Rectangle {
            y: control.topPadding - control.bottomPadding
            width: parent.width
            height: parent.height - control.topPadding + control.bottomPadding
            color: Palette.turquoise()
            radius: 10
        }

        Column {

            RadioButton {
                id:button1
                text: "Tri par difficulté"
                checked: true
                onClicked: {
                }
                contentItem: Text {
                    text: button1.text
                    font.family: localFont.name
                    font.pointSize: 16
                    color: button1.checked ? Palette.white() : Palette.silver()
                    leftPadding: button1.indicator.width + button1.spacing
                }
                indicator: Rectangle {
                    y:10
                    implicitWidth: 25
                    implicitHeight: 25
                    radius: 10
                    border.width: 1
                    Rectangle {
                        anchors.fill: parent
                        visible: button1.checked
                        color: Palette.greenSea()
                        radius: 10
                        anchors.margins: 4
                    }
                }
            }

            RadioButton {
                id:button2
                text: "Tri par terrain"
                onClicked: {
                }
                contentItem: Text {
                    text: button2.text
                    font.family: localFont.name
                    font.pointSize: 16
                    color: button2.checked ? Palette.white() : Palette.silver()
                    leftPadding: button2.indicator.width + button2.spacing
                }
                indicator: Rectangle {
                    y:10
                    implicitWidth: 25
                    implicitHeight: 25
                    radius: 10
                    border.width: 1
                    Rectangle {
                        anchors.fill: parent
                        visible: button2.checked
                        color: Palette.greenSea()
                        radius: 10
                        anchors.margins: 4
                    }
                }
            }
        }
    }
}
