import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: cachesRecordedLists
    closeButtonVisible: false

    property var listChecked: main.viewState !== "fullcache" ? listCheckedBoolAtFalse() : listCheckedBool(fullCache.geocode)
    property int listIndex: 0

    width: Math.max( displayListColumn.width, manageListButton.width )
    height: displayListColumn.height + manageListButton.height + recordCachesButton.height + refreshCachesButton.height + 60
    background: Rectangle {
        id: backgroundRectangle
        width: Math.max( displayListColumn.width, manageListButton.width )
        height: displayListColumn.height + manageListButton.height + recordCachesButton.height + refreshCachesButton.height + 40
        color: Palette.turquoise()
        radius: 10
    }

    RecordedListsManager {
        id: recordedListsManager
        x: -200
        y: -50
    }

    ScrollView {
        id: displayListColumn
        clip: true
        width: repeaterColumn.width
        height: Math.min(repeaterColumn.height, 4 * main.height / 5)
        contentWidth: -1

        Column {
            id: repeaterColumn
            spacing: 10
            width: Math.max(childrenRect.width, main.width * 2 / 3)
            height: childrenRect.height

            // repeater
            Repeater {
                model: sqliteStorage.countLists

                ListBox {
                    checkable: main.state !== "recorded" || viewState === "fullcache"  ? true : main.tabBarRecordedCachesIndex === index
                    checked: listChecked[index]
                    text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
                    onListBoxClicked: {
                        listChecked[index] = !listChecked[index]
                        if(main.viewState === "fullcache")
                        {
                            if(listChecked.indexOf(true) === -1)
                            {
                                fullCacheRetriever.deleteToStorage(sqliteStorage)
                                fullCache.registered = false
                            } else if((listChecked.indexOf(true) !== -1)  &&  (fullCache.registered === false)) {
                                fullCacheRetriever.writeToStorage(sqliteStorage)
                                fullCache.registered = true
                            }
                            sqliteStorage.updateListWithGeocode("cacheslists" , listChecked , fullCache.geocode , true)
                            sqliteStorage.numberCachesInLists("cacheslists")
                            if(main.state === "recorded"){
                                cachesRecorded.updateMapCachesRecorded()
                                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[tabBarRecordedCachesIndex])
                            }
                        }
                    }
                }
            }
        }
    }

    FastButton {
        id: manageListButton
        text: "Gérer les listes..."
        font.pointSize: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 10
        onClicked: recordedListsManager .open()
    }

    FastButton {
        id: recordCachesButton
        text: "Enregistrer les caches"
        visible: main.state !== "recorded" && (viewState !== "fullcache" ) ? true : false
        font.pointSize: 10
        anchors.bottom: manageListButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            console.log("list checked:   " + listChecked)
            var list = []
            if(viewState === "map"){
                list = fastMap.listGeocodesOnMap()
                console.log("list of geocodes(map):   " + list)
            } else if (viewState === "list"){
                list = fastList.listGeocodesOnList()
                console.log("list of geocodes(list):   " + list)
            }
            if(list.length > 0  && listChecked.indexOf(true) !== -1)
                fullCachesRecorded.sendRequest(connector.tokenKey , list , listChecked , sqliteStorage)
            cachesRecordedLists.close()
        }
    }

    FastButton {
        id: deleteCachesButton
        text: "Supprimer les caches"
        visible: main.state !== "recorded" || viewState === "fullcache" ? false : true
        font.pointSize: 10
        anchors.bottom: manageListButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            var list = []
            if(viewState === "map"){
                list = fastMap.listGeocodesOnMap()
                console.log("list of geocodes(map):   " + list)
            } else if (viewState === "list"){
                list = fastList.listGeocodesOnList()
                console.log("list of geocodes(list):   " + list)
            }
            if(list.length > 0 && listChecked.indexOf(true) !== -1){
                for (var i = 0; i < list.length; i++){
                    sqliteStorage.deleteCacheInList("cacheslists", sqliteStorage.listsIds[main.tabBarRecordedCachesIndex] , list[i] )
                }
                sqliteStorage.updateFullCachesTable("cacheslists" ,"fullcache");
                cachesRecorded.updateMapCachesRecorded()
                sqliteStorage.numberCachesInLists("cacheslists")
                fastList.selectedInList = fastList.createAllSelectedInList(false)
                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[tabBarRecordedCachesIndex])
            }
            cachesRecordedLists.close()
        }
    }

    FastButton {
        id: refreshCachesButton
        text: "Rafraichir les caches"
        visible: main.state !== "recorded" || viewState === "fullcache" ? false : true
        font.pointSize: 10
        anchors.bottom: recordCachesButton.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            var list = []
            if(viewState === "map"){
                list = fastMap.listGeocodesOnMap()
                console.log("list of geocodes(map):   " + list)
            } else if (viewState === "list"){
                list = fastList.listGeocodesOnList()
                console.log("list of geocodes(list):   " + list)
            }
            if(list.length > 0 && listChecked.indexOf(true) !== -1){
                fullCachesRecorded.sendRequest(connector.tokenKey , list , listChecked , sqliteStorage)
                cachesRecorded.updateMapCachesRecorded()
                fastList.selectedInList = fastList.createAllSelectedInList(false)
                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[tabBarRecordedCachesIndex])
            }
            cachesRecordedLists.close()
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }

    function listCheckedBool(geocode) {
        var list = sqliteStorage.cacheInLists("cacheslists", geocode)
        return list
    }

    function listCheckedBoolAtFalse() {
        var list = []
        for (var i = 0; i < sqliteStorage.countLists; i++) {
            list.push(false)
        }
        return list
    }
}
