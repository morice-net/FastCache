import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: cachesRecordedLists
    closeButtonVisible: false

    property var listChecked: []
    property int listIndex: 0
    width: Math.max( displayListColumn.width, manageListButton.width )
    height: displayListColumn.height + manageListButton.height + 50

    background: Rectangle {
        id: backgroundRectangle
        width: Math.max( displayListColumn.width, manageListButton.width )
        height: displayListColumn.height + manageListButton.height + 30
        color: Palette.turquoise()
    }

    ScrollView {
        id: displayListColumn
        visible: true
        clip: true
        width: repeaterColumn.width
        height: Math.min(repeaterColumn.height, 4 * main.height / 5)

        Column {
            id: repeaterColumn
            spacing: 10
            width: childrenRect.width
            height: childrenRect.height

            Component.onCompleted: console.log("column LENGTH = " + width + "x" + height)
            // repeater
            Repeater {
                model: sqliteStorage.countLists

                ListBox {
                    x:10
                    checked:listCheckedBool(fullCache.geocode)[index]
                    text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
                    onListBoxClicked: {
                        listChecked[index] = !listChecked[index]
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
                    }
                }
            }
        }
    }

    FastTextButton {
        id: manageListButton
        buttonText: "Gérer les listes..."
        onClicked: recordedListManager.open()
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 10
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
