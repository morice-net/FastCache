import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: recordedListsManager

    property int listIndex: 0

    width: main.width
    height: main.height

    Column {
        id: renameDeleteColumn
        width:recordedListsManager.width
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

        // rename list

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
                    listChecked.splice(listIndex , 1 )
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

    ScrollView {
        id: displayListColumn
        clip: true
        anchors.top: renameDeleteColumn.bottom
        anchors.margins: 10
        width: repeaterColumn.width
        height: Math.min(repeaterColumn.height, 4 * main.height / 5)
        contentWidth: -1

        Column {
            id: repeaterColumn
            spacing: 10
            width:recordedListsManager.width*0.9

            // repeater
            Repeater {
                model: sqliteStorage.countLists

                ListBox {
                    x:10
                    checkable: false
                    editable: index !== 0
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

    // add list
    Column {
        id: newListColumn
        width:recordedListsManager.width
        anchors.top: displayListColumn.bottom
        anchors.margins: 10
        visible: true
        spacing: 10

        Rectangle {
            width: recordedListsManager.width*0.9
            height: 2
            color: Palette.white()
            radius:10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            width: parent.width * 0.9
            height: childrenRect.height
            spacing: 10
            // new list
            FastTextButton {
                id : newList
                buttonText: "Nouvelle liste"
                onClicked: {
                    buttonDel.visible = !buttonDel.visible
                    createNewList.visible = !createNewList.visible
                    buttonCreate.visible = !buttonCreate.visible
                }
            }

            TextField {
                id: createNewList
                visible: false
                placeholderText: qsTr("Nouvelle liste")
                font.family: localFont.name
                font.pointSize: 20
                color: Palette.greenSea()
                width: parent.width - newList.width - parent.spacing
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.turquoise()
                    border.width: 1
                    radius: 5
                }
            }
        }

        Row {
            spacing: 10
            height: childrenRect.height
            width: childrenRect.width
            anchors.horizontalCenter: parent.horizontalCenter

            FastTextButton {
                id:buttonDel
                visible: false
                buttonText: "Effacer"
                onClicked: {
                    createNewList.text = "" ;
                }
            }

            // create list
            FastTextButton {
                id:buttonCreate
                visible: false
                buttonText: "Créer la liste"
                onClicked: {
                    if (createNewList.length !== 0) {
                        listChecked.push(false)
                        sqliteStorage.updateLists("lists" , -1 , createNewList.text )
                        sqliteStorage.numberCachesInLists("cacheslists")
                    }
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: recordedListsManager.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        // button Valider
        FastTextButton {
            buttonText:"Valider"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                // Close recordedListsManager
                closeIfMenu()
                recordedListsManager.close()
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}
