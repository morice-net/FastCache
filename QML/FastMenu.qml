import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Item {
    id: fastMenu
    anchors.fill: parent

    LoadingPage {
        id: loadingPage
    }

    Rectangle {
        id: menuShadow
        anchors.fill: parent
        visible: false
        color: Palette.black()
        opacity: 0

        Behavior on opacity { NumberAnimation { duration: 1200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: fastMenu.hideMenu()
        }
        onOpacityChanged: {
            visible = opacity > 0 ? true : false
        }
    }

    Rectangle {
        id: menu
        width: parent.width * 0.8
        height: parent.height
        x: -parent.width
        color: Palette.white()
        clip: true
        radius:10

        Behavior on x { NumberAnimation { duration: 600 } }

        ///////////////////////////////////////////////////////////////////////////
        //                      user info on the top of the menu                 //
        ///////////////////////////////////////////////////////////////////////////

        Item {
            id: userInfoMenu
            height: parent.height * 0.17
            width: parent.width

            Row {
                anchors.fill: parent
                anchors.margins: 5
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
                    spacing: 0
                    clip: true
                    Text {
                        height: parent.height * 0.5
                        text: userInfo.name
                        font.family: localFont.name
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: height
                        color: Palette.black()

                        onTextChanged: {
                            if (text === "") return
                            while (width > (userInfoMenu.width - userInfoIcon.width - 20)) font.pixelSize--
                        }
                    }

                    Text {
                        height: parent.height * 0.25
                        text: findCount + " caches trouvées"
                        font.family: localFont.name
                        verticalAlignment: Text.AlignBottom
                        font.pixelSize: height
                        color: Palette.greenSea()

                        onTextChanged: {
                            if (text === "0 caches trouvées") return
                            while (width > (userInfoMenu.width - userInfoIcon.width - 20)) font.pixelSize--
                        }
                    }

                    Text {
                        height: parent.height * 0.25
                        text: "Membre : " + userInfo.premium
                        font.family: localFont.name
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: height
                        color: Palette.greenSea()

                        onTextChanged: {
                            if (text === "Membre : ") return
                            while (width > (userInfoMenu.width - userInfoIcon.width - 20)) font.pixelSize--
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Open user info popup")
                    hideMenu()
                    userInfoPopup.open()
                }
            }

            Item {
                id: connectButtonMenu
                height: parent.height
                width: parent.width
                visible: userInfo.name.length === 0

                Rectangle {
                    id: connectButtonMenuRectangle
                    radius: 20
                    anchors.fill: parent
                    anchors.margins: 18
                    color: Palette.turquoise()

                    SequentialAnimation on opacity {
                        id: buttonAnimation
                        running: false
                        loops: 3
                        NumberAnimation { to: 0; duration: 200 }
                        NumberAnimation { to: 1; duration: 200 }
                    }

                    Text {
                        id: connectButtonName
                        anchors.fill: parent
                        font.family: localFont.name
                        font.pointSize: 24
                        text: "Se connecter"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: Palette.white()
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            buttonAnimation.start()
                            main.reconnectAccount()
                        }
                    }
                }
            }
        }

        ///////////////////////////////////////////////////////////////////////////
        //                      button on the middle of the menu                 //
        ///////////////////////////////////////////////////////////////////////////

        FastDoubleButtonMenu {
            id: mapButtonMenu
            anchors.bottomMargin: 2
            anchors.top: userInfoMenu.bottom
            anchors.topMargin: 18

            firstButtonSelected: true
            button1Text: "Carte"
            button2Text: "Liste"

            function buttonClicked() {
                firstButtonSelected = !firstButtonSelected
                if (firstButtonSelected)
                    main.viewState = "map"
                else
                    main.viewState = "list"
                if (main.cachesActive)
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

                    firstButtonSelected: main.cachesActive
                    button1Text: "On"
                    button2Text: "Off"
                    small: true

                    function buttonClicked() {
                        main.cachesActive = !(main.cachesActive)
                        if (firstButtonSelected) {
                            reloadCaches()
                        } else {
                            main.cachesActive = false
                            fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
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

            buttonSelected: main.state === "near"
            buttonText: main.viewState === "fullcache" ? "Lancer Maps" : "Caches proches"

            function buttonClicked() {
                if (main.viewState === "fullcache") {
                    fullCache.launchMaps(fullCache.lat , fullCache.lon);
                } else {
                    main.state = "near"
                    hideMenu()
                    main.cachesActive = false
                    nearCachesClicked()
                    fastMap.mapItem.center = currentPosition.position.coordinate
                }
            }
        }

        FastSelectableButtonMenu {
            id: addressButtonMenu
            anchors.top: nearButtonMenu.bottom
            anchors.topMargin: 2
            anchors.bottomMargin: 18

            buttonSelected: main.state === "address"
            buttonText: main.viewState === "fullcache" ? "Naviguer" : "Adresse"

            function buttonClicked() {
                if(main.viewState === "fullcache"){
                    hideMenu()
                    fastCache.compassPageInit("Cache   " + fullCache.geocode , fullCache.lat , fullCache.lon)
                    fastCache.swipeToPage(0)
                    fastCache.z = 0
                } else {
                    main.state = "address"
                    if(fastMap.checkedPluginMap().supportsGeocoding()){
                        main.cachesActive = false
                        hideMenu()
                        geocode.open()
                    } else {
                        hideMenu()
                        toast.visible = true
                        toast.show("Le plugin ne gère pas le géocoding.")
                    }
                }
            }
        }

        FastSelectableButtonMenu {
            id: coordinatesButtonMenu
            anchors.top: addressButtonMenu.bottom
            anchors.topMargin: 2
            anchors.bottomMargin: 18
            buttonSelected: main.state === "coordinates"
            buttonText: main.viewState === "fullcache" ? "Log" : "Coordonnées"

            function buttonClicked() {
                if(main.viewState === "fullcache"){
                    hideMenu()
                    if(fullCache.imagesName.length !== 0) {
                        fastCache.swipeToPage(6)
                    } else {
                        fastCache.swipeToPage(5)
                    }
                } else {
                    main.state = "coordinates"
                    main.cachesActive = false
                    hideMenu()
                    coordinatesBox.open()
                }
            }
        }

        ///////////////////////////////////////////////////////////////////////////
        //                      button on the bottom of the menu                 //
        ///////////////////////////////////////////////////////////////////////////

        FastSelectableButtonMenu {
            id: saveButtonMenu
            anchors.top: coordinatesButtonMenu.bottom
            anchors.topMargin: 30
            anchors.bottomMargin: 18
            buttonText:  "Caches Enregistrées"

            function buttonClicked() {
                // Display list of recorded caches and prepare Center Map.
                main.cachesActive = false
                main.state = "recorded";
                cachesRecorded.updateMapCachesRecorded()
                fastMap.clearMap()
                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[tabBarRecordedCachesIndex])

                // center and zoom level
                hideMenu()
                centerMapCaches(cachesSingleList.caches)
            }
        }
    }

    function isMenuVisible() {
        return (menu.x == 0)
    }

    function showMenu() {
        //web view description page not visible
        fastCache.webViewDescriptionPageOpacity = 0

        console.log("Show menu...")
        menu.x = 0
        menuShadow.opacity = 0.5
    }

    function hideMenu() {
        console.log("Hide menu...")
        menu.x = menu.width * -1
        menuShadow.opacity = 0

        // web view description page visible
        if(main.state !== "recorded" || main.cachesActive === true)
            fastCache.webViewDescriptionPageOpacity = 1
    }

    function nearCachesClicked() {
        main.state = "near"
        hideMenu()
        var coord = currentPosition.position.coordinate
        cachesNear.latPoint = coord.latitude
        cachesNear.lonPoint = coord.longitude
        cachesNear.distance = 100

        cachesNear.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs() , createFilterExcludeCachesFound() ,
                                      createFilterExcludeCachesArchived() , createFilterKeywordDiscoverOwner() , userInfo.name )
        cachesNear.indexMoreCaches = 0
        cachesNear.sendRequest(connector.tokenKey)
    }

    // load caches by coordinates, from CoordinatesBox.
    function cachesByCoordinates() {
        if(main.viewState !== "fullcache"){
            cachesNear.latPoint = coordinatesBox.resultLat
            cachesNear.lonPoint = coordinatesBox.resultLon
            cachesNear.distance = 100
            cachesNear.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs() ,
                                          createFilterExcludeCachesFound() , createFilterExcludeCachesArchived() ,
                                          createFilterKeywordDiscoverOwner() , userInfo.name )
            cachesNear.indexMoreCaches = 0
            cachesNear.sendRequest(connector.tokenKey)
            fastMap.mapItem.center =QtPositioning.coordinate(coordinatesBox.resultLat , coordinatesBox.resultLon)
        }
    }

    Component.onCompleted: {
        coordinatesBox.okCoordinatesClicked.connect(cachesByCoordinates)
    }
}

