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

        Row {
            spacing: 10

            Button {
                id:buttonDelete
                visible: false
                contentItem: Text {
                    text:"Etes vous sur?"
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
                    sqliteStorage.deleteCachesInList("cacheslists", sqliteStorage.listsIds[listIndex])
                    sqliteStorage.deleteList("lists", sqliteStorage.listsIds[listIndex])
                    buttonDelete.visible = false
                    buttonNo.visible = false
                    separator1.visible = false
                }
            }

            Button {
                id:buttonNo
                visible: false
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
                    buttonDelete.visible = false
                    buttonNo.visible = false
                    separator1.visible = false
                }
            }
        }

        Rectangle {
            id: separator1
            visible: false
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        Repeater {
            model: sqliteStorage.countLists

            ListBox {
                x:10
                checked:listCheckedBool(fullCache.geocode)[index]
                visibleEditList: index !== 0
                visibleDeleteList: index !== 0
                onListBoxClicked: {
                    listChecked[index] = !listChecked[index]
                }
                contentItem: Text {
                    text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
                    font.family: localFont.name
                    font.pointSize: 16
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: indicator.width + 25
                    color: checked ? Palette.white() : Palette.silver()
                }
                onDeleteListClicked: {
                    buttonDelete.visible = true
                    buttonNo.visible = true
                    separator1.visible = true
                    listIndex = index
                }
                onEditListClicked: {
                    renameList.visible = true
                    separator4.visible = true
                    listIndex = index
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

            Button {
                id:buttonDel
                visible: newList.checked
                contentItem: Text {
                    text:"Effacer"
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
                }
            }

            Button {
                id:buttonCreate
                visible: newList.checked
                contentItem: Text {
                    text:"Créer la liste"
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
                    if (createNewList.length !== 0) {
                        sqliteStorage.updateLists("lists" , -1 , createNewList.text )
                        newList.checked = false
                        sqliteStorage.countCachesInLists.push(0)
                    }
                }
            }
        }

        Rectangle {
            id: separator3
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        TextField {
            id: renameList
            visible: false
            placeholderText: qsTr(sqliteStorage.readAllStringsFromTable("lists")[listIndex])
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

        Rectangle {
            id: separator4
            visible: false
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        Button {
            x:10
            contentItem: Text {
                text:"Ok"
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
                // Rename list
                if(renameList.visible === true  && renameList.text.length !== 0)
                {
                    sqliteStorage.updateLists("lists", sqliteStorage.listsIds[listIndex], renameList.text)
                    renameList.visible = false
                    separator3.visible = false
                }
                // Close cachesRecordedLists
                if(listChecked.indexOf(true) === -1)
                {
                    fullCacheRetriever.deleteToStorage(sqliteStorage)
                    fullCache.registered = false
                } else if((listChecked.indexOf(true) !== -1)  &&  (fullCache.registered === false)) {
                    fullCacheRetriever.writeToStorage(sqliteStorage)
                    fullCache.registered = true
                }
                sqliteStorage.updateListWithGeocode("cacheslists" ,listChecked , fullCache.geocode)
                sqliteStorage.numberCachesInLists("cacheslists")
                closeIfMenu()
                cachesRecordedLists.close()
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }

    function listCheckedBool(geocode) {
        listChecked = sqliteStorage.cacheInLists("cacheslists", geocode)
        return listChecked
    }
}

