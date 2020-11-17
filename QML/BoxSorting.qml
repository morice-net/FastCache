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
                text: "Tri par Géocode"
                checked: main.sortingBy === 0
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 0
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
                text: "Tri par Nom"
                checked: main.sortingBy === 1
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 1
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
                text: "Tri par Type"
                checked: main.sortingBy === 2
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 2
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
                text: "Tri par Taille"
                checked: main.sortingBy === 3
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 3
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
                text: "Tri par Difficulté"
                checked: main.sortingBy === 4
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 4
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
                text: "Tri par Terrain"
                checked: main.sortingBy === 5
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 5
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
                text: "Tri par Distance"
                checked: main.sortingBy === 6
                onClicked: {
                    groupBoxSorting.visible = false
                    main.sortingBy = 6
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
        }
    }
}
