import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.5

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
        visible: main.state === "recorded" && main.viewState === "list" && main.state !== "cachesActive" ? true:false
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
        height: main.state === "near" || main.state === "address" || main.state === "coordinates" || main.state === "recorded" ||
                main.state === "pocketQuery"
                ? parent.height - fastListHeader.height - fastListBottom.height -10 : parent.height - fastListHeader.height -10
        y: main.state === "near" || main.state === "address"  || main.state === "coordinates" || main.state === "recorded" ||
           main.state === "pocketQuery"
        spacing: 5
        model: sorting
        ScrollBar.vertical: ScrollBar {}
    }

    Rectangle {
        id: fastListHeader
        width: parent.width
        height: parent.height * 0.07
        color: Palette.white()

        Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.family: localFont.name
            font.pixelSize: parent.height * 0.5
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
        width: parent.width
        height: parent.height * 0.05
        color: Palette.turquoise()
        radius:10
        anchors.top: fastListHeader.bottom
        visible: main.state === "near" || main.state === "address" || main.state === "coordinates"  ? true : false

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
            }
        }
    }

    function textHeader() {
        if(main.state === "cachesActive"){
            fastListBottom.visible = false ;
            fastListColumn.y = fastListHeader.height + 10
            return "Liste de caches(" + fastListColumn.count + ")"
        } else if(main.state === "near" ){
            fastListBottom.visible = true ;
            fastListColumn.y = fastListHeader.height + fastListBottom.height +10
            return  "Caches proches(" + fastListColumn.count + ")"
        } else if(main.state === "address" ){
            fastListBottom.visible = true ;
            fastListColumn.y = fastListHeader.height + fastListBottom.height +10
            return  "Par adresse(" + fastListColumn.count + ")"
        } else if(main.state === "coordinates" ){
            fastListBottom.visible = true ;
            fastListColumn.y = fastListHeader.height + fastListBottom.height +10
            return  "Par coordonnées(" + fastListColumn.count + ")"
        } else if (main.state === "pocketQuery") {
            fastListBottom.visible = false ;
            fastListColumn.y = fastListHeader.height + 10
            return "Pocket Query(" + fastListColumn.count + ")"
        } else if(main.state === "recorded"){
            fastListBottom.visible = false ;
            fastListColumn.y = fastListHeader.height + tabViewRecordedCaches.height + 10
            return sqliteStorage.readAllStringsFromTable("lists")[tabViewRecordedCaches.currentIndex] + " ( " + fastListColumn.count + " )"
        }
        return ""
    }

    function createAllSelectedInList(flag) {
        var selected = []
        if(main.state !== "") {
            for (var i = 0; i < cachesSingleList.caches.length; i++) {
                selected.push(flag)
            }
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
            if(selectedInList[i])
                listGeocodes.push(listCaches[i].geocode)
        }
        return listGeocodes
    }
}


