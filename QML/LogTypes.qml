import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

GroupBox {
    id: groupBox
    width: parent.width*0.7

    Column {

        RadioButton {
            id:button1
            text: "Trouvée"
            checked: true
            onClicked: {
                typeLogCheck = 2
                typeLog = typeLogCheck
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
            text: "Non trouvée"
            onClicked: {
                typeLogCheck = 3
                typeLog = typeLogCheck
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

        RadioButton {
            id:button3
            text: "Note"
            onClicked: {
                typeLogCheck = 4
                typeLog = typeLogCheck
            }
            contentItem: Text {
                text: button3.text
                font.family: localFont.name
                font.pointSize: 16
                color: button3.checked ? Palette.white() : Palette.silver()
                leftPadding: button3.indicator.width + button3.spacing
            }
            indicator: Rectangle {
                y:10
                implicitWidth: 25
                implicitHeight: 25
                radius: 10
                border.width: 1
                Rectangle {
                    anchors.fill: parent
                    visible: button3.checked
                    color: Palette.greenSea()
                    radius: 10
                    anchors.margins: 4
                }
            }
        }

        RadioButton {
            id:button4
            text: "Nécessite une maintenance"
            onClicked: {
                typeLogCheck = 45
                typeLog = typeLogCheck
            }
            contentItem: Text {
                text: button4.text
                font.family: localFont.name
                font.pointSize: 16
                color: button4.checked ? Palette.white() : Palette.silver()
                leftPadding: button4.indicator.width + button4.spacing
            }
            indicator: Rectangle {
                y:10
                implicitWidth: 25
                implicitHeight: 25
                radius: 10
                border.width: 1
                Rectangle {
                    anchors.fill: parent
                    visible: button4.checked
                    color: Palette.greenSea()
                    radius: 10
                    anchors.margins: 4
                }
            }
        }

        RadioButton {
            id:button5
            text: "Nécessite d'être archivée"
            onClicked: {
                typeLogCheck = 7
                typeLog = typeLogCheck
            }
            contentItem: Text {
                text: button5.text
                font.family: localFont.name
                font.pointSize: 16
                color: button5.checked ? Palette.white() : Palette.silver()
                leftPadding: button5.indicator.width + button5.spacing
            }
            indicator: Rectangle {
                y:10
                implicitWidth: 25
                implicitHeight: 25
                radius: 10
                border.width: 1
                Rectangle {
                    anchors.fill: parent
                    visible: button5.checked
                    color: Palette.greenSea()
                    radius: 10
                    anchors.margins: 4
                }
            }
        }

        RadioButton {
            id:button6
            text: "Maintenance effectuée"
            onClicked: {
                typeLogCheck = 46
                typeLog = typeLogCheck
            }
            contentItem: Text {
                text: button6.text
                font.family: localFont.name
                font.pointSize: 16
                color: button6.checked ? Palette.white() : Palette.silver()
                leftPadding: button6.indicator.width + button6.spacing
            }
            indicator: Rectangle {
                y:10
                implicitWidth: 25
                implicitHeight: 25
                radius: 10
                border.width: 1
                Rectangle {
                    anchors.fill: parent
                    visible: button6.checked
                    color: Palette.greenSea()
                    radius: 10
                    anchors.margins: 4
                }
            }
        }

        RadioButton {
            id:button7
            text: "Désactivée"
            onClicked: {
                typeLogCheck = 22
                typeLog = typeLogCheck
            }
            contentItem: Text {
                text: button7.text
                font.family: localFont.name
                font.pointSize: 16
                color: button7.checked ? Palette.white() : Palette.silver()
                leftPadding: button7.indicator.width + button7.spacing
            }
            indicator: Rectangle {
                y:10
                implicitWidth: 25
                implicitHeight: 25
                radius: 10
                border.width: 1
                Rectangle {
                    anchors.fill: parent
                    visible: button7.checked
                    color: Palette.greenSea()
                    radius: 10
                    anchors.margins: 4
                }
            }
        }

        RadioButton {
            id:button8
            text: "Archivée"
            onClicked: {
                typeLogCheck = 5
                typeLog = typeLogCheck
            }
            contentItem: Text {
                text: button8.text
                font.family: localFont.name
                font.pointSize: 16
                color: button8.checked ? Palette.white() : Palette.silver()
                leftPadding: button8.indicator.width + button8.spacing
            }
            indicator: Rectangle {
                y:10
                implicitWidth: 25
                implicitHeight: 25
                radius: 10
                border.width: 1
                Rectangle {
                    anchors.fill: parent
                    visible: button8.checked
                    color: Palette.greenSea()
                    radius: 10
                    anchors.margins: 4
                }
            }
        }
    }
}
