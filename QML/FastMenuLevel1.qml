import QtQuick

import "JavaScript/MainFunctions.js" as Functions

Item {
    id: fastMenuLevel1
    FastDoubleButtonMenu {
        id: mapButtonMenu
        firstButtonSelected: true
        button1Text: "Carte"
        button2Text: "Liste"

        function buttonClicked() {
            firstButtonSelected = !firstButtonSelected
            if (firstButtonSelected)
                main.viewState = "map"
            else
                main.viewState = "list"
            if (main.listState === "cachesActive")
                fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
        }
    }

    FastSelectableButtonMenu {
        id: bboxButtonMenu
        anchors.top: mapButtonMenu.bottom
        anchors.topMargin: 2
        anchors.bottomMargin: 18
        buttonSelected: false
        buttonText: " Carte active"
        centered: false

        Item {
            height: parent.height * 0.8
            width: parent.width * 0.45
            anchors.right: parent.right
            anchors.margins: parent.height * 0.1
            y: parent.height * 0.1

            FastDoubleButtonMenu {
                id: activeCaches
                height: parent.height
                firstButtonSelected: main.listState === "cachesActive"
                button1Text: "On"
                button2Text: "Off"
                small: true

                function buttonClicked() {
                    if(main.listState === "cachesActive") {
                        main.listState = ""
                    } else {
                        main.listState = "cachesActive"
                    }
                    if (firstButtonSelected) {
                        hideMenu()
                        fastMap.currentZoomlevel = 13
                        Functions.reloadCachesBBox()
                    } else {
                        hideMenu()
                        main.listState = ""
                    }
                }
            }
        }

        function buttonClicked() {
        }
    }

    FastSelectableButtonMenu {
        id: nearButtonMenu
        anchors.top: bboxButtonMenu.bottom
        anchors.topMargin: 30
        anchors.bottomMargin: 18
        buttonSelected: main.listState === "near"
        buttonText: main.viewState === "fullcache" ? "Lancer Maps" : "Caches proches"

        function buttonClicked() {
            if (main.viewState === "fullcache") {
                fullCache.launchMaps(fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                     fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon);
            } else {
                hideMenu()
                nearCachesClicked()
                fastMap.mapItem.center = locationSource
            }
        }
    }

    FastSelectableButtonMenu {
        id: addressButtonMenu
        anchors.top: nearButtonMenu.bottom
        anchors.topMargin: 2
        anchors.bottomMargin: 18
        buttonText: main.viewState === "fullcache" ? "Naviguer" : "Recherche"

        function buttonClicked() {
            if(main.viewState === "fullcache"){
                hideMenu()
                fastCache.compassPageInit(fastCache.compassPageTitleFullCache() , fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                          fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
                fastCache.swipeToPage(fastCache.compassPageIndex)
                fastCache.z = 0
            } else {
                fastMenuLevel1.x = -parent.width
            }
        }
    }

    FastSelectableButtonMenu {
        id: saveButtonMenu
        anchors.top: addressButtonMenu.bottom
        anchors.topMargin: 30
        anchors.bottomMargin: 18
        buttonText: main.viewState === "fullcache" ? "Log de la cache" : "Caches Enregistrées"

        function buttonClicked() {
            if(main.viewState === "fullcache"){
                hideMenu()
                fastCache.swipeToPage(fastCache.logPageIndex)
            } else {
                // Display list of recorded caches and prepare Center Map.
                main.listState = "recorded";
                cachesRecorded.updateMapCachesRecorded()
                fastMap.clearMap()
                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[tabBarRecordedCachesIndex])

                // center and zoom level
                hideMenu()
                Functions.centerMapCaches(cachesSingleList.caches)

                fastMap.cachesOnMap = fastMap.countCachesOnMap()  // number of caches on map
            }
        }
    }
}
