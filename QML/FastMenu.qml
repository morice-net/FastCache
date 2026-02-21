import QtQuick
import QtQuick.Layouts
import QtPositioning

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {
    id: fastMenu
    anchors.fill: parent

    LoadingPage {
        id: loadingPage
    }

    BoxSorting {
        id: groupBoxSorting
        visible: false
    }

    Rectangle {
        id: menu
        width: parent.width * 0.8
        height: parent.height
        color: Palette.white()
        clip: true
        radius: 10       
        x: -parent.width

        Behavior on x { NumberAnimation { duration: 200 } }

        // user infos
        Item {
            id: userInfoMenu
            height: parent.height * 0.12
            width: parent.width

            Row {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                visible: userInfo.name.length > 0

                Image {
                    id: userInfoIcon
                    height: parent.height
                    width: height
                    source: userInfo.avatarUrl
                }

                Column {
                    height: parent.height
                    spacing: 10
                    clip: true

                    Text {
                        height: parent.height * 0.3
                        text: userInfo.name
                        font.family: localFont.name
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: height
                        color: Palette.greenSea()
                        onTextChanged: (text) => {
                                           if (text === "") return
                                           while (width > (userInfoMenu.width - userInfoIcon.width - 20)) font.pointSize--
                                       }
                    }

                    Text {
                        height: parent.height * 0.2
                        text: findCount + " caches trouvées"
                        font.family: localFont.name
                        verticalAlignment: Text.AlignBottom
                        font.pointSize: height
                        color: Palette.greenSea()
                        onTextChanged: (text) => {
                                           if (text === "0 caches trouvées") return
                                           while (width > (userInfoMenu.width - userInfoIcon.width - 20)) font.pointSize--
                                       }
                    }

                    Text {
                        height: parent.height * 0.2
                        text: "Membre : " + userInfo.premium
                        font.family: localFont.name
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: height
                        color: Palette.greenSea()
                        onTextChanged: (text) => {
                                           if (text === "Membre : ") return
                                           while (width > (userInfoMenu.width - userInfoIcon.width - 20)) font.pointSize--
                                       }
                    }
                }
            }

            Item {
                id: connectButtonMenu
                height: parent.height
                width: parent.width
                visible: userInfo.name.length === 0

                Text {
                    id: connectButtonName
                    anchors.fill: parent
                    font.family: localFont.name
                    font.pointSize: 17
                    text: "Se connecter"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: Palette.greenSea()
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        buttonAnimation.start()
                        Functions.reconnectAccount()
                    }
                }
            }
        }

        FastMenuLevel1 {
            id: fastMenu1
            visible : main.viewState === "map" || main.viewState === "list"
            height: parent.height
            width: parent.width
            anchors.top: userInfoMenu.bottom
        }

        FastMenuLevel2 {
            id: fastMenu2
            visible: main.viewState === "fullcache" || main.viewState === "travelbug"
            height: parent.height
            width: parent.width
            anchors.top: userInfoMenu.bottom
        }
    }

    function isMenuVisible() {
        return (menu.x === 0)
    }

    function showMenu() {
        console.log("Show menu...")
        menu.x = 0
    }

    function hideMenu() {
        console.log("Hide menu...")
        menu.x = menu.width * -1
    }

    function clearBoxSorting() {
        groupBoxSorting.visible = false
    }

    function nearCachesClicked() {
        main.listState = "near"

        hideMenu()
        var coord = locationSource
        // caches
        cachesNear.latPoint = coord.latitude
        cachesNear.lonPoint = coord.longitude
        cachesNear.distance = 100
        cachesNear.updateFilterCaches(listTypes , listSizes , Functions.createFilterDifficultyTerrainGs() , main.excludeFound ,
                                      main.excludeArchived , Functions.createFilterKeywordDiscoverOwner() , userInfo.name)
        cachesNear.indexMoreCaches = 0
        cachesNear.sendRequest(connector.tokenKey)

        //lab caches
        if(settings.labCache === false) {
            adventureLabCachesRetriever.cachesActive = false
            adventureLabCachesRetriever.latPoint = coord.latitude
            adventureLabCachesRetriever.lonPoint = coord.longitude
            adventureLabCachesRetriever.distance = 100
            adventureLabCachesRetriever.excludeOwnedCompleted = main.excludeFound
            adventureLabCachesRetriever.indexMoreLabCaches = 0
            adventureLabCachesRetriever.sendRequest(connector.tokenKey)
        }
    }

    // load caches by coordinates, from CoordinatesBox.
    function cachesByCoordinates() {
        if(main.viewState !== "fullcache"){
            //caches
            cachesNear.latPoint = coordinatesBox.resultLat
            cachesNear.lonPoint = coordinatesBox.resultLon
            cachesNear.distance = 100
            cachesNear.updateFilterCaches(listTypes , listSizes , Functions.createFilterDifficultyTerrainGs() , main.excludeFound ,
                                          main.excludeArchived , Functions.createFilterKeywordDiscoverOwner() , userInfo.name)
            cachesNear.indexMoreCaches = 0
            cachesNear.sendRequest(connector.tokenKey)

            //lab caches
            if(settings.labCache === false) {
                adventureLabCachesRetriever.cachesActive = false
                adventureLabCachesRetriever.latPoint = coordinatesBox.resultLat
                adventureLabCachesRetriever.lonPoint = coordinatesBox.resultLon
                adventureLabCachesRetriever.distance = 100
                adventureLabCachesRetriever.excludeOwnedCompleted = main.excludeFound
                adventureLabCachesRetriever.indexMoreLabCaches = 0
                adventureLabCachesRetriever.sendRequest(connector.tokenKey)
            }
            fastMap.mapItem.center = QtPositioning.coordinate(coordinatesBox.resultLat , coordinatesBox.resultLon)
        }
    }

    Component.onCompleted: {
        coordinatesBox.okCoordinatesClicked.connect(cachesByCoordinates)
    }
}

