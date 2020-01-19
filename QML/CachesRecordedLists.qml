import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: cachesRecordedLists
    width: parent.width * 0.9
    background: Rectangle {
        implicitWidth: 110
        implicitHeight: 200
        opacity: 0.8
        border.color: Palette.silver()
        color:Palette.greenSea()
        border.width: 1
        radius: 15
    }

    Column {
        spacing: 10

        Text {
            y: 10
            font.family: localFont.name
            font.pointSize: 24
            verticalAlignment: Text.AlignLeft
            horizontalAlignment: Text.AlignLeft
            color: Palette.white()
            text: "Choisir les listes.."
        }

        CheckBox {
            id : recorded
            x:10
            contentItem: Text {
                text: "Enregistrées()"
                font.family: localFont.name
                font.pointSize: 16
                color: recorded.checked ? Palette.white() : Palette.silver()
                verticalAlignment: Text.AlignVCenter
                leftPadding: recorded.indicator.width + recorded.spacing
            }
            indicator: Rectangle {
                implicitWidth: 25
                implicitHeight: 25
                radius: 3
                border.width: 1
                y: parent.height / 2 - height / 2
                Rectangle {
                    anchors.fill: parent
                    visible: recorded.checked
                    color: Palette.greenSea()
                    radius: 3
                    anchors.margins: 4
                }
            }
        }

        Rectangle {
            id: separator1
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        CheckBox {
            id : newList
            x:10
            contentItem: Text {
                text: "Nouvelle liste"
                font.family: localFont.name
                font.pointSize: 16
                color: newList.checked ? Palette.white() : Palette.silver()
                verticalAlignment: Text.AlignVCenter
                leftPadding: newList.indicator.width + newList.spacing
            }
            indicator: Rectangle {
                implicitWidth: 25
                implicitHeight: 25
                radius: 3
                border.width: 1
                y: parent.height / 2 - height / 2
                Rectangle {
                    anchors.fill: parent
                    visible: newList.checked
                    color: Palette.greenSea()
                    radius: 3
                    anchors.margins: 4
                }
            }
        }

        TextField {
            id: createNewList
            visible: newList.checked
            placeholderText: qsTr("nouvelle liste")
            font.family: localFont.name
            font.pointSize: 16
            color: Palette.greenSea()
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        Row {
            spacing: 10
            x: parent.width / 2

            Button {
                id:buttonCreate
                x:10
                visible: newList.checked
                contentItem: Text {
                    text:"Créer"
                    font.family: localFont.name
                    font.pixelSize: 25
                    color: Palette.white()
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    color: Palette.greenSea()
                    border.color: Palette.white()
                    border.width: 1
                    radius: 5
                }
                onClicked: {  }
            }

            Button {
                id:buttonDel
                visible: newList.checked
                contentItem: Text {
                    text:"Annuler"
                    font.family: localFont.name
                    font.pixelSize: 25
                    color: Palette.white()
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    color: Palette.greenSea()
                    border.color: Palette.white()
                    border.width: 1
                    radius: 5
                }
                onClicked: {
                    createNewList.text = "" ;
                    newList.checked = false;
                }
            }
        }

        Rectangle {
            id: separator2
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}

