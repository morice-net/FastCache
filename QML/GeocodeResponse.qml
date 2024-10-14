import QtQuick
import QtPositioning

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

FastPopup {
    id: geocodeResponse

    property alias listModel: listModel

    width: main.width * 0.9
    height: geocodelist.height + 30
    x: (parent.width - geocodeResponse.width) / 2
    y: -geocode.y + 20
    closeButtonVisible: false
    backgroundRadius: 10

    ListView {
        id: geocodelist
        clip: true
        width: parent.width
        height: popupResponseHeight() * 0.85
        model: listModel
        delegate: delegate
    }

    ListModel {
        id: listModel
    }

    Component {
        id: delegate

        Rectangle {
            id: item
            width: parent.width
            height: main.height / 5
            color: Palette.white()
            border.width: 1
            border.color: Palette.greenSea()
            radius: 5

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    geocodeResponse.close()
                    main.state = "address"
                    // caches
                    cachesNear.latPoint = listModel.get(index).valLat
                    cachesNear.lonPoint = listModel.get(index).valLon
                    cachesNear.distance = 100
                    cachesNear.updateFilterCaches(listTypes, listSizes, Functions.createFilterDifficultyTerrainGs(), main.excludeFound,
                                                  main.excludeArchived, Functions.createFilterKeywordDiscoverOwner(), userInfo.name)
                    cachesNear.indexMoreCaches = 0
                    cachesNear.sendRequest(connector.tokenKey)

                    //lab caches
                    if(settings.labCache === false) {
                        adventureLabCachesRetriever.cachesActive = false
                        adventureLabCachesRetriever.latPoint = listModel.get(index).valLat
                        adventureLabCachesRetriever.lonPoint = listModel.get(index).valLon
                        adventureLabCachesRetriever.distance = 100
                        adventureLabCachesRetriever.excludeOwnedCompleted = main.excludeFound
                        adventureLabCachesRetriever.indexMoreLabCaches = 0
                        adventureLabCachesRetriever.sendRequest(connector.tokenKey)
                    }
                    fastMap.mapItem.center = QtPositioning.coordinate(listModel.get(index).valLat , listModel.get(index).valLon)
                }
            }

            Column {
                leftPadding: 20
                topPadding: 10

                Text {
                    text: lat + Functions.formatLat(valLat)
                    color: Palette.greenSea()
                    font.family: localFont.name
                }

                Text {
                    text: lon + Functions.formatLon(valLon)
                    color: Palette.greenSea()
                    font.family: localFont.name
                }

                Text {
                    text: city + valCity
                    color: Palette.greenSea()
                    font.family: localFont.name
                }

                Text {
                    text: state + valState
                    color: Palette.greenSea()
                    font.family: localFont.name
                }

                Text {
                    text: country + valCountry
                    color: Palette.greenSea()
                    font.family: localFont.name
                }
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}
