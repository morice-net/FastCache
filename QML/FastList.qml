import QtQuick

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastList
    anchors.fill: parent
    opacity: main.viewState === "list" ? 1 : 0
    visible: opacity > 0
    color: Palette.white()

    property bool selectAll: false
    property int tabBarRecordedCachesIndex: tabViewRecordedCaches.currentIndex
    property var selectedInList: createAllSelectedInList(false)
    property var listCaches: sorting.modelState()

    states: [
        State {
            name: "selectedInList"
            PropertyChanges { target: fastList }
        }
    ]

    TabViewRecordedCaches{
        id : tabViewRecordedCaches
        visible: main.listState === "recorded" && main.viewState === "list" ? true:false
    }

    LoadingPage {
        id: loadingPage
    }

    ListCachesSort {
        id: sorting
    }

    ListView {
        id: fastListColumn
        width: parent.width
        height: main.listState === "near" || main.listState === "address" || main.listState === "coordinates" || main.listState === "recorded" ||
                main.listState === "pocketQuery"
                ? parent.height - fastListHeader.height - fastListBottom.height - 30 : parent.height - fastListHeader.height - 30
        spacing: 5
        model: sorting
    }

    Rectangle {
        id: fastListHeader
        x: main.width * 0.32
        width: parent.width
        height: parent.height * 0.07
        color: Palette.white()

        Text {
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 18
            color: Palette.greenSea()
            text: textHeader()

            MouseArea {
                anchors.fill: parent
                onPressAndHold: {
                    if(fastList.state === "selectedInList") {
                        fastList.state = ""
                        selectedInList = createAllSelectedInList(false)
                    } else {
                        fastList.state = "selectedInList"
                    }
                }
                onClicked: {
                    if(fastList.state === "selectedInList" ){
                        selectAll = !selectAll
                        selectedInList = createAllSelectedInList(selectAll)
                    }
                }
            }
        }
    }

    Rectangle {
        id: fastListBottom
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height * 0.05
        color: Palette.silver()
        radius:10
        anchors.top: fastListHeader.bottom
        visible: main.listState === "near" || main.listState === "address" || main.listState === "coordinates"  ? true : false

        Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pointSize: 20
            font.family: localFont.name
            text: "Rechercher d'autres caches.."
            color: Palette.black()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                cachesNear.sendRequest(connector.tokenKey)

                // lab caches
                if(settings.labCache === false)
                    adventureLabCachesRetriever.sendRequest(connector.tokenKey)
            }
        }
    }

    // When the menu is open, it allows you to darken the background.
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Palette.black()
        opacity: fastMenu.isMenuVisible() ? 0.8 : 0
        visible: fastMenu.isMenuVisible()

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    function textHeader() {
        if(main.annexMainState === "cachesActive"){
            fastListBottom.visible = false ;
            fastListColumn.y = fastListHeader.height + 10
            return "Carte active (" + fastListColumn.count + ")"

        } else if(main.annexMainState === "near"){
            if(fastListColumn.count < settings.maxCachesInList) {
                fastListBottom.visible = true
                fastListColumn.y = fastListHeader.height + fastListBottom.height + 10
            } else {
                fastListBottom.visible = false ;
                fastListColumn.y = fastListHeader.height + 10
            }
            return  "Caches proches (" + fastListColumn.count + ")"

        } else if(main.annexMainState === "address" ){
            if(fastListColumn.count < settings.maxCachesInList) {
                fastListBottom.visible = true
                fastListColumn.y = fastListHeader.height + fastListBottom.height + 10
            } else {
                fastListBottom.visible = false ;
                fastListColumn.y = fastListHeader.height + 10
            }
            return  "Par adresse (" + fastListColumn.count + ")"

        } else if(main.annexMainState === "coordinates" ){
            if(fastListColumn.count < settings.maxCachesInList) {
                fastListBottom.visible = true
                fastListColumn.y = fastListHeader.height + fastListBottom.height + 10
            } else {
                fastListBottom.visible = false ;
                fastListColumn.y = fastListHeader.height + 10
            }
            return  "Par coordonnées (" + fastListColumn.count + ")"

        } else if (main.annexMainState === "pocketQuery") {
            fastListBottom.visible = false ;
            fastListColumn.y = fastListHeader.height + 10
            return "Pocket Query (" + fastListColumn.count + ")"

        } else if(main.annexMainState === "recorded"){
            fastListBottom.visible = false ;
            fastListColumn.y = fastListHeader.height + tabViewRecordedCaches.height + 10
            return sqliteStorage.readAllStringsFromTable("lists")[tabViewRecordedCaches.currentIndex] + " ( " + fastListColumn.count + " )"
        }

        fastListBottom.visible = false ;
        return "Carte non active (" + fastListColumn.count + ")"
    }

    function createAllSelectedInList(flag) {
        var selected = []
        for (var i = 0; i < cachesSingleList.caches.length; i++) {
            selected.push(flag)
        }
        console.log("selected in list:  " + selected)
        return selected
    }

    function getSelectedInList() {
        var selected = selectedInList
        console.log("selected in list:  " + selected)
        return selected
    }

    function listGeocodesOnList() {
        var listGeocodes = []
        for (var i = 0; i <selectedInList.length ; i++) {
            if(listCaches[i].geocode.substring(0,2) === "GC" && selectedInList[i])
                listGeocodes.push(listCaches[i].geocode)
        }
        return listGeocodes
    }

    function listIdsLabCachesOnList() {
        var listIds = []
        for (var i = 0; i <selectedInList.length ; i++) {
            if(listCaches[i].geocode.substring(0,2) !== "GC" && selectedInList[i])
                listIds.push(listCaches[i].geocode)
        }
        return listIds
    }

    function listLatitudesLabCachesOnList() {
        var listLatitudes = []
        for (var i = 0; i <selectedInList.length ; i++) {
            if(listCaches[i].geocode.substring(0,2) !== "GC" && selectedInList[i])
                listLatitudes.push(listCaches[i].lat)
        }
        return listLatitudes
    }

    function listLongitudesLabCachesOnList() {
        var listLongitudes = []
        for (var i = 0; i <selectedInList.length ; i++) {
            if(listCaches[i].geocode.substring(0,2) !== "GC" && selectedInList[i])
                listLongitudes.push(listCaches[i].lon)
        }
        return listLongitudes
    }


    function listAllCodesOnList() {
        var list = []
        for (var i = 0; i <selectedInList.length ; i++) {
            if(selectedInList[i])
                list.push(listCaches[i].geocode)
        }
        return list
    }

    function sortByDistance() {
        // sort the list by distance if necessary
        if(main.viewState === "list" && main.sortingBy === main.sortDistance && !sorting.listSortedByDistance()) {
            sorting.sortList()
        }
    }
}


