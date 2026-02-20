import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {
    id: menu

    property int currentSelectedIndex: -1

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: columnLayout.implicitHeight * 1.4 + (pocketsqueries.visible ? pocketsqueries.height + 15 : 0)
        clip: true

        ColumnLayout {
            id: columnLayout
            width: parent.width
            spacing: 15

            // maps / lists
            Text {
                text: "Cartes , listes"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // map (index 0)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    radius: 6
                    opacity: menu.currentSelectedIndex === 0 ? 0.2 : 0
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Map.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Carte"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: main.viewState === "map" ? Palette.greenSea() : Palette.silver()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 0
                                main.viewState = "map"
                                if (main.listState === "cachesActive")
                                    fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
                            }
                        }
                    }
                }
            }

            //  List (index 1)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 1 ? 0.2 : 0
                    radius : 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_List.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Liste"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: main.viewState === "list" ? Palette.greenSea() : Palette.silver()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 1
                                main.viewState = "list"
                                if (main.listState === "cachesActive")
                                    fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
                            }
                        }
                    }
                }
            }

            // map active , inactive (index 2)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 2 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Map.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: mapActive
                        text: main.listState === "cachesActive" ? "Carte active" : "Carte inactive"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 2
                                if(main.listState !== "cachesActive") {
                                    main.listState = "cachesActive"
                                    mapActive.text = "Carte active"
                                    hideMenu()
                                    fastMap.currentZoomlevel = 13
                                    Functions.reloadCachesBBox()
                                } else {
                                    main.listState = ""
                                    mapActive.text = "Carte inactive"
                                    hideMenu()
                                }
                            }
                        }
                    }
                }
            }
            
            // filters
            Text {
                text: "Filtres"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // Filter caches (index 3)
            Item {
                visible:(!fastMap.compassMapButton) && ((main.viewState === "map" || main.viewState === "list") && fastList.state === "") ||
                        (main.viewState === "map" && fastList.state === "selectedInList")
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 3 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Filter.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Filtrer les caches"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 3
                                fastMenuHeader.changeFiltersVisibility()
                                hideMenu()
                            }
                        }
                    }
                }
            }

            //  sort lists (index 4)
            Item {
                visible: main.viewState !== "fullcache" && viewState === "list"
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 4 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Sort.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Trier les listes"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 4
                                groupBoxSorting.visible = !groupBoxSorting.visible
                                hideMenu()
                            }
                        }
                    }
                }
            }

            // research
            Text {
                text: "Recherches"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // caches near (index 5)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 5 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Near.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Caches proches"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 5
                                hideMenu()
                                nearCachesClicked()
                                fastMap.mapItem.center = locationSource
                            }
                        }
                    }
                }
            }

            // saved caches (index 6)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 6 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Saved.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Caches enregistrées"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 6
                                main.listState = "recorded";
                                cachesRecorded.updateMapCachesRecorded()
                                fastMap.clearMap()
                                cachesRecorded.updateListCachesRecorded(sqliteStorage.listsIds[tabBarRecordedCachesIndex])
                                hideMenu()
                                Functions.centerMapCaches(cachesSingleList.caches)
                                fastMap.cachesOnMap = fastMap.countCachesOnMap()
                            }
                        }
                    }
                }
            }

            // search by address (index 7)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 7 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Address.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: byAddress
                        text: "Recherche par adresse"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 7
                                main.listState = "address"
                                if(fastMap.checkedPluginMap().supportsGeocoding()){
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
                }
            }

            // search by coordinates (index 8)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 8 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Coordinates.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: byCoordinates
                        text: "Recherche par coordonnées"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 8
                                main.listState = "coordinates"
                                hideMenu()
                                coordinatesBox.backgroundOpacity = 0.9
                                coordinatesBox.open()
                            }
                        }
                    }
                }
            }

            // search by geocode (index 9)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 9 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_GeocodeCache.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: byGeocode
                        text: "Recherche par géocode"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 9
                                geocodeCache.visible = !geocodeCache.visible
                                if(geocodeCache.text.length !== 0) {
                                    if(main.viewState === "fullcache")
                                        previousGeocode = fullCache.geocode
                                    hideMenu()
                                    fullCache.geocode = geocodeCache.text.toUpperCase()
                                    fullCacheRetriever.sendRequest(connector.tokenKey)
                                    main.listState = ""
                                    geocodeCache.text = ""
                                }
                            }
                        }
                    }
                }
            }

            TextField {
                id: geocodeCache
                visible: false
                color: Palette.greenSea()
                font.capitalization: Font.AllUppercase
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: main.width / 4.5
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                background: Rectangle {
                    color: Palette.white()
                    border.color: Palette.greenSea()
                    border.width: 1
                    radius: 5
                }
            }

            // search by code travel bug (index 10)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 10 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_CodeTb.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: byCodeTravelBug
                        text: "Recherche par code travel bug"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 10
                                codeTravelBug.visible = !codeTravelBug.visible
                                if(codeTravelBug.text.length !== 0) {
                                    hideMenu()
                                    travelbug.sendRequest(connector.tokenKey , codeTravelBug.text.toUpperCase());
                                    codeTravelBug.text = ""
                                }
                            }
                        }
                    }
                }
            }

            TextField {
                id: codeTravelBug
                visible: false
                color: Palette.greenSea()
                font.capitalization: Font.AllUppercase
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: main.width / 4.5
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                background: Rectangle {
                    color: Palette.white()
                    border.color: Palette.greenSea()
                    border.width: 1
                    radius: 5
                }
            }

            // search  Pockets Queries (index 11)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 11 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_PocketsQueries.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: pockets
                        text: "Pockets Queries"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 11
                                main.listState = "pocketQuery"
                                getPocketsqueriesList.sendRequest(connector.tokenKey)
                                pocketsqueries.visible = true
                            }
                        }
                    }
                }
            }

            // settings
            Text {
                visible: !fastMap.compassMapButton
                text: "Paramètres cartes, listes , gps"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // settings maps/lists (index 12)
            Item {
                visible: !fastMap.compassMapButton
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 12 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Settings.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: settingsMenu
                        text: "Paramètres cartes , listes"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 12
                                userSettings.showMenu()
                                hideMenu()
                            }
                        }
                    }
                }
            }

            // informations GPS (index 13)
            Item {
                visible: !fastMap.compassMapButton
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 13 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Gps.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id: settingsGps
                        text: "Informations gps"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 13
                                satelliteInfo.showMenu()
                                hideMenu()
                            }
                        }
                    }
                }
            }

            // disconnect
            Text {
                text: "Déconnexion"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // disconnect (index 14)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 14 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Disconnect.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Se déconnecter (appui long)"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onPressAndHold: {
                                menu.currentSelectedIndex = 14
                                Functions.disconnectAccount()
                                userSettings.hideMenu()
                            }
                        }
                    }
                }
            }

            // quit (index 15)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 10
                Layout.rightMargin : 10

                Rectangle {
                    anchors.fill: parent
                    color: Palette.greenSea()
                    opacity: menu.currentSelectedIndex === 15 ? 0.2 : 0
                    radius: 6
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "../Image/menu_Quit.png"
                        sourceSize: Qt.size(23, 23)
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: 30
                    }

                    Text {
                        text: "Quitter Fast Cache"
                        font.family: localFont.name
                        font.pointSize: 17
                        color: Palette.greenSea()
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                menu.currentSelectedIndex = 15
                                sureQuit.visible = true
                            }
                        }
                    }
                }
            }

            // Pockets queries list
            Text {
                visible : pocketsqueries.visible && getPocketsqueriesList.names.length !== 0
                text: "Pockets queries"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            RowLayout {
                Layout.preferredHeight: pocketsqueries.height
                spacing: 0

                Item { Layout.fillWidth: true }

                ListPocketsqueries {
                    id: pocketsqueries
                    Layout.preferredWidth: main.width / 2
                    visible: false
                }

                Item { Layout.fillWidth: true }
            }
        }
    }
}
