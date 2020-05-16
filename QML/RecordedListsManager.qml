import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: cachesRecordedLists

    property var listChecked: []
    property int listIndex: 0

    width: parent.width * 0.9

    //first zone
    Column {
        id: renameDeleteColumn
        width:cachesRecordedLists.width
        spacing: 20

        Text {
            id: title
            y: 10
            font.family: localFont.name
            font.pointSize: 28
            verticalAlignment: Text.AlignLeft
            horizontalAlignment: Text.AlignLeft
            color: Palette.white()
            text: "Gérer les listes.."
        }

        // rename list
        TextField {
            id: renameList
            visible: false
            placeholderText: qsTr("Nouvelle liste")
            font.family: localFont.name
            font.pointSize: 20
            color: Palette.greenSea()
            width: parent.width * 0.9
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        FastTextButton {
            id:buttonRename
            visible: false
            buttonText: "Renommer la liste"
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                if(renameList.text.length !== 0)
                {
                    sqliteStorage.updateLists("lists", sqliteStorage.listsIds[listIndex], renameList.text)
                    sqliteStorage.numberCachesInLists("cacheslists")
                }
                title.text = "Gérer les listes.."
                displayListColumn.visible = true
                newListColumn.visible = true
                renameList.visible = false
                buttonRename.visible = false
            }
        }

        // delete list
        Row {
            spacing: 25

            FastTextButton {
                id:buttonDelete
                visible: false
                buttonText: "Etes vous sur ?"

                onClicked: {
                    sqliteStorage.deleteCachesInList("cacheslists", sqliteStorage.listsIds[listIndex])
                    sqliteStorage.deleteList("lists", sqliteStorage.listsIds[listIndex])
                    sqliteStorage.numberCachesInLists("cacheslists")
                    sqliteStorage.updateFullCachesTable("cacheslists" ,"fullcache")
                    if(listChecked.indexOf(true) === -1)
                    {
                        fullCache.registered = false
                    } else {
                        fullCache.registered = true
                    }
                    title.text = "Gérer les listes.."
                    displayListColumn.visible = true
                    newListColumn.visible = true
                    buttonDelete.visible = false
                    buttonNo.visible = false
                }
            }

            FastTextButton {
                id:buttonNo
                visible: false
                buttonText: "Annuler"

                onClicked: {
                    title.text = "Gérer les listes.."
                    displayListColumn.visible = true
                    newListColumn.visible = true
                    buttonDelete.visible = false
                    buttonNo.visible = false
                }
            }
        }
    }

    // second zone
    Flickable {
        id:displayListColumn
        y: renameDeleteColumn.height
        visible: true
        clip: true
        width: cachesRecordedLists.width*0.9
        height: cachesRecordedLists.height/2
        contentHeight: repeaterColumn.height + 80
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: repeaterColumn
            y: renameDeleteColumn.height
            spacing: 10
            width:cachesRecordedLists.width*0.9

            // repeater
            Repeater {
                model: sqliteStorage.countLists

                ListBox {
                    x:10
                    checkable: false
                    editable: true
                    text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
                    width: parent.width * 0.9
                    onDeleteListClicked: {
                        title.text = "Supprimer la liste"
                        displayListColumn.visible = false
                        newListColumn.visible = false
                        buttonDelete.visible = true
                        buttonNo.visible = true
                        listIndex = index
                    }
                    onEditListClicked: {
                        title.text = "Renommer la liste"
                        displayListColumn.visible = false
                        newListColumn.visible = false
                        renameList.visible = true
                        buttonRename.visible = true
                        listIndex = index
                    }
                }
            }
        }
    }

    //third zone
    Column {
        id: newListColumn
        width:cachesRecordedLists.width
        y:displayListColumn.height + renameDeleteColumn.height + 10
        visible: true
        spacing: 10

        Rectangle {
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        // new list
        CheckBox {
            id : newList
            visible: true
            x:10
            contentItem: Text {
                text: "Nouvelle liste"
                font.family: localFont.name
                font.pointSize: 20
                color: newList.checked ? Palette.white() : Palette.silver()
                verticalAlignment: Text.AlignVCenter
                leftPadding: newList.indicator.width + newList.spacing
            }
            indicator: Rectangle {
                implicitWidth: 30
                implicitHeight: 30
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
            placeholderText: qsTr("Nouvelle liste")
            font.family: localFont.name
            font.pointSize: 20
            color: Palette.greenSea()
            width: parent.width * 0.9
            anchors.horizontalCenter: parent.horizontalCenter
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

            FastTextButton {
                id:buttonDel
                visible: newList.checked
                buttonText: "Effacer"

                onClicked: {
                    createNewList.text = "" ;
                }
            }

            // create list
            FastTextButton {
                id:buttonCreate
                visible: newList.checked
                buttonText: "Créer la liste"

                onClicked: {
                    if (createNewList.length !== 0) {
                        sqliteStorage.updateLists("lists" , -1 , createNewList.text )
                        newList.checked = false
                        sqliteStorage.numberCachesInLists("cacheslists")
                    }
                }
            }
        }

        Rectangle {
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        // button Valider
        FastTextButton {
            x:10
            buttonText:"Valider"

            onClicked: {
                // Close cachesRecordedLists
                closeIfMenu()
                cachesRecordedLists.close()
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}
