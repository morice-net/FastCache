import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtPositioning

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Item {

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: columnLayout.implicitHeight * 1.4
        clip: true

        ColumnLayout {
            id: columnLayout
            width: parent.width
            spacing: 15

            Text {
                text: "Pages de la cache ou du TB"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            // page compass
            RowLayout {
                visible: main.viewState === "fullcache"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Compass.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page boussole"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            viewState = "fullcache"
                            fastCache.compassPageInit(fastCache.compassPageTitleFullCache() , fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                                      fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
                            fastCache.swipeToPage(fastCache.compassPageIndex)
                        }
                    }
                }
            }

            // page map
            RowLayout {
                visible: main.viewState === "fullcache"
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
                    text: "Aller à la page carte"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            viewState = "map"
                            // memorizes the center and the zoom of the map
                            fastMap.mapItem.latCenterMap = fastMap.mapItem.center.latitude
                            fastMap.mapItem.lonCenterMap = fastMap.mapItem.center.longitude
                            fastMap.mapItem.zoomMap = fastMap.mapItem.zoomLevel

                            fastMap.compassMapButton = true
                            fastMap.mapItem.oneCacheOnMap(fullCache.geocode , true) //makes one cache visible on map
                            fastMap.mapItem.allCirclesOnMap(false) // makes all cache circles invisible on the map
                            // center cache or waypoint on map
                            fastMap.mapItem.center = QtPositioning.coordinate(fastCache.goalLat , fastCache.goalLon)

                            fastMap.currentZoomlevel = 17
                            // is cache in list of caches?
                            if(!fastCache.geocodeInCachesList)
                                fastMap.mapItem.addCacheOnMap() // add full cache on map, not in list

                            // Add waypoints cache on map
                            fastMap.mapItem.addWaypointsCacheOnMap()

                            // Add user waypoints cache on map
                            fastMap.mapItem.addUserWaypointsCacheOnMap()

                            // Add circle around cache or waypoint
                            fastMap.mapItem.createCircleWaypoint(fastCache.goalLat , fastCache.goalLon)

                            // Orient the map if necessary
                            if(!fastMap.oldMapNorth)
                                fastMap.mapItem.bearing = locationSource.azimuthTo(QtPositioning.coordinate(fastCache.goalLat , fastCache.goalLon))
                        }
                    }
                }
            }

            // waypoints
            RowLayout {
                visible: main.viewState === "fullcache"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Waypoints.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page étapes"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            fastCache.swipeToPage(fastCache.waypointsPageIndex)
                        }
                    }
                }
            }

            // description
            RowLayout {
                visible: main.viewState === "fullcache"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Description.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page description"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            fastCache.swipeToPage(fastCache.descriptionPageIndex)
                        }
                    }
                }
            }

            // details
            RowLayout {
                visible: main.viewState === "fullcache" || main.viewState === "travelbug"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Details.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page détails"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            if(main.viewState === "fullcache") {
                                fastCache.swipeToPage(fastCache.detailsPageIndex)
                            } else {
                                fastTravelbug.swipeToPage(0)
                            }
                        }
                    }
                }
            }

            // images
            RowLayout {
                visible: main.viewState === "fullcache"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Images.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page images"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            fastCache.swipeToPage(fastCache.imagesPageIndex)
                        }
                    }
                }
            }

            // logs
            RowLayout {
                visible: main.viewState === "fullcache" || main.viewState === "travelbug"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_Logs.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page logs"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            if(main.viewState === "fullcache") {
                                fastCache.swipeToPage(fastCache.logsPageIndex)
                            } else {
                                fastTravelbug.swipeToPage(1)
                            }
                        }
                    }
                }
            }

            // log in
            RowLayout {
                visible: main.viewState === "fullcache" || main.viewState === "travelbug"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_LogIn.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page loguer"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            if(main.viewState === "fullcache") {
                                fastCache.swipeToPage(fastCache.logPageIndex)
                            } else {
                                fastTravelbug.swipeToPage(2)
                            }
                        }
                    }
                }
            }

            // travelBug
            RowLayout {
                visible: main.viewState === "fullcache"
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
                    text: "Aller à la page travelbug"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            fastCache.swipeToPage(fastCache.tbsPageIndex)
                        }
                    }
                }
            }

            // user logs
            RowLayout {
                visible: main.viewState === "fullcache"
                Layout.fillWidth: true
                spacing: 10

                Image {
                    source: "../Image/menu_UserLogs.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Aller à la page logs utilisateur"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            fastCache.swipeToPage(fastCache.userLogsPageIndex)
                        }
                    }
                }
            }

            // launch maps
            Text {
                text: "Lancer Maps"
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
                    source: "../Image/menu_LaunchMaps.png"
                    sourceSize: Qt.size(23, 23)
                    fillMode: Image.PreserveAspectFit
                    Layout.leftMargin: 15
                    Layout.preferredWidth: 30
                }

                Text {
                    text: "Lancer Maps"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            hideMenu()
                            fullCache.launchMaps(fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat ,
                                                 fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon);

                        }
                    }
                }
            }

            // store  or delete cache
            Text {
                visible: main.viewState === "fullcache" && fullCacheRetriever.state !== "loading"
                text: "Enregistrement ou suppression de cache"
                font.family: localFont.name
                font.pointSize: 15
                font.bold: true
                color: Palette.turquoise()
                Layout.leftMargin: 10
            }

            RowLayout {
                visible: main.viewState === "fullcache" && fullCacheRetriever.state !== "loading"
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
                    text: !fullCache.registered ? "Enregistrement de cache" : "Suppression de cache"
                    font.family: localFont.name
                    font.pointSize: 17
                    color: Palette.greenSea()
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cachesRecordedLists.x = (main.width - cachesRecordedLists.width) /2
                            cachesRecordedLists.open()
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
        }
    }
}



