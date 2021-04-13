import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Item {
    id: fastMenu
    anchors.fill: parent

    property int openMenu: 1  // 1: menu 1 open, 2: menu 2 open, 3: pockets queries list open
    property bool direction: true  // true: menu go forward, false: menu go back

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
        //                      items on the menu                 //
        ///////////////////////////////////////////////////////////////////////////

        FastMenuLevel1 {
            id: fastMenuLevel1
            width: parent.width
            height: parent.height
            anchors.bottomMargin: 2
            anchors.top: userInfoMenu.bottom

            Behavior on x { NumberAnimation {
                    duration: 900
                    onRunningChanged: {
                        if ((openMenu === 1) && (!running)) {
                            fastMenuLevel2.x  = 0
                        } else if ((openMenu === 2) && (!running))  {
                            openMenu = 1
                        }
                    }
                }
            }
        }

        FastMenuLevel2 {
            id: fastMenuLevel2
            x: - parent.width
            height: parent.height
            width: parent.width
            anchors.bottomMargin: 2
            anchors.top: userInfoMenu.bottom

            Behavior on x { NumberAnimation {
                    duration: 900
                    onRunningChanged: {
                        if ((openMenu === 2) && (direction) && (!running)) {
                            pocketsqueries.x  = 15
                        } else if ((openMenu === 2) && (!direction) && (!running)){
                            fastMenuLevel1.x = 0
                        }
                    }
                }
            }
        }
    }

    ListPocketsqueries {
        id: pocketsqueries
        x: -parent.width
        y: fastMenuLevel1.y
        height: fastMenuLevel1.height
        width: fastMenuLevel1.width*0.9

        Behavior on x { NumberAnimation {
                duration: 900
                onRunningChanged: {
                    if ((openMenu === 3) && (!running)) {
                        fastMenuLevel2.x = 0
                    }
                }
            }
        }
    }

    function isMenuVisible() {
        return (menu.x == 0)
    }

    function showMenu() {
        //web view description page not visible
        fastCache.webViewDescriptionPageVisible = false
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
            fastCache.webViewDescriptionPageVisible = true
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

