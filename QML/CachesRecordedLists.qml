import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

FastPopup {
    id: cachesRecordedLists
    closeButtonVisible: false

    property var listChecked: main.viewState !== "fullcache" ? listCheckedBoolAtFalse() : listCheckedBool(fullCache.geocode)
    property bool recordingMode: true //two modes: recording mode or edit mode
    property int listIndex: 0

    width: displayListColumn.width
    height: Math.min(radioButtons.height + displayListColumn.height + saveMapBox.height + recordCachesButton.height + refreshCachesButton.height +
                     newListColumn.height , main.height * 0.8)
    background: Rectangle {
        id: backgroundRectangle
        color: Palette.turquoise()
        radius: 10
    }

    // radio buttons
    Column {
        id: radioButtons

        RadioButton {
            id:button1
            visible: true
            text: "Enregistrement de caches"
            checked: true
            onClicked: {
                recordingMode = true
                title.text = "Enregistrement"
                renameList.visible = false
                deleteList.visible = false
                newListColumn.visible = false
            }
            contentItem: Text {
                text: button1.text
                font.family: localFont.name
                font.pointSize: 16
                color: button1.checked ? Palette.white() : Palette.silver()
                leftPadding: button1.indicator.width + button1.spacing
                verticalAlignment: Text.AlignVCenter
            }
            indicator: Rectangle {
                y: parent.height / 2 - height / 2
                implicitWidth: 18
                implicitHeight: 18
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
            visible: true
            text: "Edition de listes"
            onClicked:{
                recordingMode = false
                title.text = "Nouvelle liste"
                renameList.visible = false
                deleteList.visible = false
                newListColumn.visible = true
            }
            contentItem: Text {
                text: button2.text
                font.family: localFont.name
                font.pointSize: 16
                color: button2.checked ? Palette.white() : Palette.silver()
                leftPadding: button2.indicator.width + button2.spacing
                verticalAlignment: Text.AlignVCenter
            }
            indicator: Rectangle {
                y: parent.height / 2 - height / 2
                implicitWidth: 18
                implicitHeight: 18
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

        Text {
            x: (cachesRecordedLists.width - width) / 2
            font.family: localFont.name
            font.pointSize: 18
            color: Palette.white()
            text: recordingMode ? "Enregistrer les caches" : "Edition de listes"
        }
    }

    // display lists
    Flickable {
        id: displayListColumn
        flickableDirection: Flickable.VerticalFlick
        clip: true
        width: repeaterColumn.width
        height: Math.min(repeaterColumn.height,  main.height * 0.4)
        contentHeight: repeaterColumn.height
        anchors.top: radioButtons.bottom

        Column {
            id: repeaterColumn
            spacing: 10
            width: main.width * 0.9
            height: childrenRect.height

            Repeater {
                model: sqliteStorage.countLists

                ListBox {
                    checkable: isCheckable(index)
                    checked: listChecked[index]
                    editable: recordingMode ? false : index !== 0
                    text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
                    onDeleteListClicked: {
                        title.text = "Supprimer la liste"
                        newListColumn.visible = false
                        renameList.visible = false
                        deleteList.visible = true
                        listIndex = index
                    }
                    onEditListClicked: {
                        title.text = "Renommer la liste"
                        newListColumn.visible = false
                        renameList.visible = true
                        deleteList.visible = false
                        listIndex = index
                    }
                    onListBoxClicked: {
                        listChecked[index] = !listChecked[index]
                        listChecked = listChecked  // Indicates that list "listChecked" is changing
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

                    function isCheckable(index) {
                        if(!recordingMode)
                            return false
                        if(main.state !== "recorded" || viewState === "fullcache") {
                            return true
                        } else {
                            return main.tabBarRecordedCachesIndex === index
                        }
                    }
                }
            }
        }
    }

    //  save map
    CheckBox {
        id: saveMapBox
        visible: recordingMode ? true : false
        checkable: settings.namePlugin !== settings.listPlugins[2]? true : false  //mapBox or no
        anchors.top: displayListColumn.bottom
        indicator: Rectangle {
            implicitWidth: 25
            implicitHeight: 25
            radius: 8
            border.width: 1
            y: parent.height / 2 - height / 2
            Rectangle {
                anchors.fill: parent
                visible: saveMapBox.checked
                color: Palette.turquoise()
                radius: 3
                anchors.margins: 4
            }
        }
    }

    Text {
        id: saveMapText
        visible: recordingMode ? true : false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: saveMapBox.bottom
        anchors.top: saveMapBox.top
        verticalAlignment: Text.AlignVCenter
        text: "Enregistrer la carte"
        font.family: localFont.name
        font.pointSize: 18
        color: saveMapBox.checked ? Palette.white() : Palette.silver()
    }

    //line
    Rectangle {
        id: line
        anchors.horizontalCenter: parent.horizontalCenter
        width: cachesRecordedLists.width
        anchors.top: saveMapBox.bottom
        height: 2
        color: Palette.white()
    }

    // title
    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: line.bottom
        font.family: localFont.name
        font.pointSize: 20
        color: Palette.white()
        text: "Enregistrement"
    }

    // rename list
    Column {
        id: renameList
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom

        TextField {
            id: rename
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.greenSea()
            width: cachesRecordedLists.width * 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        FastButton {
            id:buttonRename
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ok"
            font.pointSize: 15
            onClicked: {
                if(rename.text.length !== 0)
                {
                    sqliteStorage.updateLists("lists", sqliteStorage.listsIds[listIndex], rename.text)
                    sqliteStorage.numberCachesInLists("cacheslists")
                }
                title.text = "Nouvelle liste"
                renameList.visible = false
                deleteList.visible = false
                newListColumn.visible = true

            }
        }
    }

    // delete list
    Row {
        id: deleteList
        visible: false
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        anchors.topMargin: 10

        FastButton {
            id: buttonDelete
            font.pointSize: 15
            text: "Etes vous sur ?"
            onClicked: {
                listChecked.splice(listIndex , 1 )
                sqliteStorage.deleteCachesInList("cacheslists", sqliteStorage.listsIds[listIndex])
                sqliteStorage.deleteList("lists", sqliteStorage.listsIds[listIndex])
                sqliteStorage.numberCachesInLists("cacheslists")
                sqliteStorage.updateFullCachesTable("cacheslists" ,"fullcache")
                if(main.viewState === "fullcache")
                {
                    if(listChecked.indexOf(true) === -1)
                    {
                        fullCache.registered = false
                    } else {
                        fullCache.registered = true
                    }
                }
                title.text = "Nouvelle liste"
                renameList.visible = false
                deleteList.visible = false
                newListColumn.visible = true
            }
        }

        FastButton {
            id:buttonNo
            text: "Annuler"
            font.pointSize: 15
            onClicked: {
                title.text = "Nouvelle liste"
                renameList.visible = false
                deleteList.visible = false
                newListColumn.visible = true
            }
        }
    }

    // add list
    Column {
        id: newListColumn
        visible: false
        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5

        TextField {
            id: createNewList
            width: cachesRecordedLists.width * 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 20
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
            height: childrenRect.height
            width: childrenRect.width
            anchors.horizontalCenter: parent.horizontalCenter

            FastButton {
                id:buttonDel
                text: "Effacer"
                font.pointSize: 15
                onClicked: {
                    createNewList.text = "" ;
                }
            }

            // create list
            FastButton {
                id:buttonCreate
                text: "Créer la liste"
                font.pointSize: 15
                onClicked: {
                    if (createNewList.length !== 0) {
                        listChecked.push(false)
                        sqliteStorage.updateLists("lists" , -1 , createNewList.text )
                        sqliteStorage.numberCachesInLists("cacheslists")
                    }
                }
            }
        }
    }

    // record caches and map
    FastButton {
        id: recordCachesButton
        text: "Ok"
        visible: main.state !== "recorded" && (viewState !== "fullcache" ) && recordingMode  ? true : false
        font.pointSize: 15
        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        onClicked: {
            console.log("list checked:   " + listChecked)
            var list = []
            if(viewState === "map"){
                if(saveMapBox.checked)
                    Functions.downloadTiles()  // download tiles
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

    // delete or refresh caches
    Column{
        id: deleteRefresh
        anchors.horizontalCenter: parent.horizontalCenter
        visible: main.state === "recorded" && viewState !== "fullcache" && recordingMode  ? true : false
        anchors.top: title.bottom
        spacing: 10
        // delete caches
        FastButton {
            id: deleteCachesButton
            text: "Supprimer les caches"
            font.pointSize: 15
            anchors.horizontalCenter: parent.horizontalCenter
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

        // refresh caches
        FastButton {
            id: refreshCachesButton
            text: "Rafraichir les caches"
            font.pointSize: 15
            anchors.horizontalCenter: parent.horizontalCenter
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
