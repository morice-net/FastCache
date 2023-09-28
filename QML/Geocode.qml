import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick
import QtQuick.Controls
import Qt.labs.settings
import QtPositioning
import QtLocation

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

FastPopup {
    id: geocode

    property bool geocodeResponseOpened: geocodeResponse.opened

    width: main.width * 0.9
    height: main.height * 0.7
    anchors.centerIn: parent
    backgroundRadius: 10
    backgroundOpacity: 0.9

    Column {
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.7

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Rue")
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: street
            width: geocode.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            color: Palette.greenSea()
            background: Rectangle {
                radius:5
                border.width: 3
                border.color: street.focus ? Palette.silver() :Palette.greenSea()
            }
            font.family: localFont.name
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Ville")
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: city
            width: geocode.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            color: Palette.greenSea()
            background: Rectangle {
                radius:5
                border.width: 3
                border.color: city.focus ? Palette.silver() :Palette.greenSea()
            }
            font.family: localFont.name
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Etat")
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: stateName
            width: geocode.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            color: Palette.greenSea()
            background: Rectangle {
                radius:5
                border.width: 3
                border.color: stateName.focus ? Palette.silver() :Palette.greenSea()
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Pays")
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: country
            width: geocode.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            color: Palette.greenSea()
            background: Rectangle {
                radius:5
                border.width: 3
                border.color: country.focus ? Palette.silver() :Palette.greenSea()
            }
            font.family: localFont.name
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Code postal")
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: postalCode
            width: geocode.width * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            color: Palette.greenSea()
            background: Rectangle {
                radius:5
                border.width: 3
                border.color: postalCode.focus ? Palette.silver() :Palette.greenSea()
            }
            font.family: localFont.name
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 50

            FastButton {
                id: goButton
                text: "Ok"
                font.pointSize: 17
                onClicked: {
                    address.street = street.text
                    address.city = city.text
                    address.state = stateName.text
                    address.country = country.text
                    address.postalCode = postalCode.text
                    geocoding(address)
                }
            }

            FastButton {
                id: clearButton
                text: "Effacer"
                font.pointSize: 17
                onClicked: {
                    street.text = ""
                    city.text = ""
                    stateName.text = ""
                    country.text = ""
                    postalCode.text = ""
                }
            }
        }
    }

    Address {
        id: address
        street: ""
        city: ""
        state:""
        country: ""
        postalCode: ""
    }

    GeocodeModel {
        id: geocodeModel
        plugin: fastMap.checkedPluginMap()
        autoUpdate: false
        onStatusChanged: {
            if ((status === GeocodeModel.Ready) || (status === GeocodeModel.Error))
                geocodeMessage()
        }
    }

    FastPopup {
        id: geocodeResponse
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
                            adventureLabCachesRetriever.indexMoreCaches = 0
                            adventureLabCachesRetriever.sendRequest(connector.tokenKey)
                        }
                        fastMap.mapItem.center =QtPositioning.coordinate(listModel.get(index).valLat , listModel.get(index).valLon)
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

    function popupResponseHeight( )  {
        if((geocodeModel.count)*(main.height / 6 )<= main.height * 0.9)
        {
            return (geocodeModel.count)*(main.height/6 )
        } else {
            return main.height * 0.9
        }
    }

    function geocoding( address)   {
        geocodeModel.query = address
        geocodeModel.update()
    }

    function geocodeMessage()  {
        var   count = geocodeModel.count

        if(count <= 0){
            geocode.close()
        } else {
            listModel.clear()
            for (var i=0; i<count; i++){
                listModel.append({"lat":"Latitude: " , "valLat": Math.round(geocodeModel.get(i).coordinate.latitude * 10000) / 10000,
                                     "lon":"Longitude: " , "valLon": Math.round(geocodeModel.get(i).coordinate.longitude * 10000) / 10000,
                                     "city":"Ville: " ,"valCity":geocodeModel.get(i).address.city,
                                     "state":"Etat: " ,"valState":geocodeModel.get(i).address.state,
                                     "country":"Pays: " , "valCountry": geocodeModel.get(i).address.country});
            }
            geocodeResponse.open()
            geocode.close()
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}
