import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: columnLayout.implicitHeight * 1.4 + (pocketsqueries.visible ? pocketsqueries.height + 15 : 0)
        clip: true

        ColumnLayout {
            id: columnLayout
            width: parent.width
            spacing: 15

            // map / list
            Text {
                text: "Cartes , listes"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Map.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            main.viewState = "map"
                            if (main.listState === "cachesActive")
                                fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_List.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            main.viewState = "list"
                            if (main.listState === "cachesActive")
                                fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
                        }
                    }
                }
            }

            // active/inactive map
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Map.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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

            // filter caches
            Text {
                visible:(!fastMap.compassMapButton) && ((main.viewState === "map" || main.viewState === "list") && fastList.state === "") ||
                        (main.viewState === "map" && fastList.state === "selectedInList")
                text: "Filtres"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            RowLayout {
                visible:(!fastMap.compassMapButton) && ((main.viewState === "map" || main.viewState === "list") && fastList.state === "") ||
                        (main.viewState === "map" && fastList.state === "selectedInList")
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Filter.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            fastMenuHeader.changeFiltersVisibility()
                            hideMenu()
                        }
                    }
                }
            }

            // list sort
            RowLayout {
                visible: main.viewState !== "fullcache" && viewState === "list"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Sort.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            groupBoxSorting.visible = !groupBoxSorting.visible
                            hideMenu()
                        }
                    }
                }
            }

            // caches near
            Text {
                text: "Recherches"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Near.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            hideMenu()
                            nearCachesClicked()
                            fastMap.mapItem.center = locationSource
                        }
                    }
                }
            }

            // saved caches
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Saved.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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

            // search by address
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Address.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            main.listState === "address"
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

            // search by coordinates
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Coordinates.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            main.listState === "coordinates"
                            hideMenu()
                            coordinatesBox.backgroundOpacity = 0.9
                            coordinatesBox.open()
                        }
                    }
                }
            }

            // search by géocode
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_GeocodeCache.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            geocodeCache.visible = !geocodeCache.visible
                            if(geocodeCache.text.length !== 0) {
                                if(main.viewState === "fullcache")
                                    // previous cache in case the download fails
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

            TextField {
                id: geocodeCache
                visible: false
                color: Palette.greenSea()
                font.capitalization: Font.AllUppercase
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle {
                    implicitWidth: main.width / 4.5
                    color: Palette.white()
                    border.color: Palette.greenSea()
                    border.width: 1
                    radius: 5
                }
            }

            // search by travel bug code
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_CodeTb.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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

            TextField {
                id: codeTravelBug
                visible: false
                color: Palette.greenSea()
                font.capitalization: Font.AllUppercase
                font.pointSize: 16
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle {
                    implicitWidth: main.width / 4.5
                    color: Palette.white()
                    border.color: Palette.greenSea()
                    border.width: 1
                    radius: 5
                }
            }


            // pockets queries
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_PocketsQueries.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            main.listState === "pocketQuery"
                            getPocketsqueriesList.sendRequest(connector.tokenKey)
                            pocketsqueries.visible = true
                        }
                    }
                }
            }

            // settings: maps, lists
            Text {
                visible: !fastMap.compassMapButton
                text: "Paramètres cartes, listes , gps"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            RowLayout {
                visible: !fastMap.compassMapButton
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Settings.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            userSettings.showMenu()
                            hideMenu()
                        }
                    }
                }
            }

            // gps
            RowLayout {
                visible: !fastMap.compassMapButton
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Gps.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                            satelliteInfo.showMenu()
                            hideMenu()
                        }
                    }
                }
            }

            Text {
                text: "Déconnexion"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // disconnect
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                //  Layout.topMargin: 10

                Image {
                    source: "../Image/menu_Disconnect.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Se déconnecter ( appui long )"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onPressAndHold: {
                            Functions.disconnectAccount()
                            userSettings.hideMenu()
                        }
                    }
                }
            }

            // quit
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Quit.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
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
                        onClicked: sureQuit.visible = true
                    }
                }
            }

            // list pockets queries
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
