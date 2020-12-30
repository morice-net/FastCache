import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.3
import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0
import QtPositioning 5.3
import QtLocation 5.6

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: geocode

    Item {
        id: item2
        anchors.margins: 5

        anchors.fill: parent

        GridLayout {
            id: gridLayout3
            anchors.rightMargin: 10
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            anchors.topMargin: 10
            rowSpacing: 15
            rows: 1
            columns: 2

            y: 80
            width: parent.width

            Label {
                id: label2
                text: qsTr("Rue")
                color: Palette.white()
                font.family: localFont.name
            }

            TextField {
                id: street
                Layout.fillWidth: true
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: parent.width - label2.width
                    radius:5
                    border.color: street.focus ? Palette.silver() :Palette.greenSea()
                }
                font.family: localFont.name
            }

            Label {
                id: label3
                text: qsTr("Ville")
                color: Palette.white()
                font.family: localFont.name
            }

            TextField {
                id: city
                Layout.fillWidth: true
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: parent.width - label2.width
                    radius:5
                    border.color: street.focus ? Palette.silver() :Palette.greenSea()
                }
                font.family: localFont.name
            }

            Label {
                id: label4
                text: qsTr("Etat")
                color: Palette.white()
                font.family: localFont.name
            }

            TextField {
                id: stateName
                Layout.fillWidth: true
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: parent.width - label2.width
                    radius:5
                    border.color: street.focus ? Palette.silver() :Palette.greenSea()
                }
            }

            Label {
                id: label5
                text: qsTr("Pays")
                color: Palette.white()
                font.family: localFont.name
            }

            TextField {
                id: country
                Layout.fillWidth: true
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: parent.width - label2.width
                    radius:5
                    border.color: street.focus ? Palette.silver() :Palette.greenSea()
                }
                font.family: localFont.name
            }

            Label {
                id: label6
                text: qsTr("Code postal")
                color: Palette.white()
                font.family: localFont.name
            }

            TextField {
                id: postalCode
                Layout.fillWidth: true
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: parent.width - label2.width
                    radius:5
                    border.color: street.focus ? Palette.silver() :Palette.greenSea()
                }
                font.family: localFont.name
            }

            RowLayout {
                id: rowLayout1
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignRight

                Button {
                    id: goButton
                    text: qsTr("Ok")
                    background: Rectangle {
                        anchors.fill: parent
                        opacity: 0.9
                        color: Palette.white()
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
                    contentItem: Text {
                        text: goButton.text
                        color: goButton.down ? Palette.turquoise() : Palette.greenSea()
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    font.family: localFont.name
                    onClicked: {
                        address.street = street.text
                        address.city = city.text
                        address.state = stateName.text
                        address.country = country.text
                        address.postalCode = postalCode.text
                        geocoding(address)
                    }
                }

                Button {
                    id: clearButton
                    text: qsTr("Effacer")
                    background: Rectangle {
                        anchors.fill: parent
                        opacity: 0.9
                        color: Palette.white()
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
                    contentItem: Text {
                        text: clearButton.text
                        color: clearButton.down ? Palette.turquoise() : Palette.greenSea()
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    font.family: localFont.name
                    onClicked: {
                        street.text = ""
                        city.text = ""
                        stateName.text = ""
                        country.text = ""
                        postalCode.text = ""
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.columnSpan: 2
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
        plugin: fastMap.mapPlugin
        autoUpdate: false
        onStatusChanged: {
            if ((status == GeocodeModel.Ready) || (status == GeocodeModel.Error))
                geocodeMessage()
        }
    }

    FastPopup {
        id: geocodeResponse

        ListView {
            id: geocodelist
            width: parent.width
            height: popupResponseHeight( )*0.85
            model: listModel
            delegate: delegate
            ScrollBar.vertical: ScrollBar {}
        }

        ListModel {
            id: listModel
        }

        Component {
            id: delegate

            Rectangle {
                id: item
                width: parent.width
                height: main.height/5
                color: Palette.white()
                border.width: 1
                border.color: Palette.greenSea()
                radius: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        geocodeResponse.close()
                        main.state = "address"
                        cachesNear.latPoint = listModel.get(index).valLat
                        cachesNear.lonPoint = listModel.get(index).valLon
                        cachesNear.distance = 100
                        cachesNear.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs() , createFilterExcludeCachesFound() ,
                                                      createFilterExcludeCachesArchived() , createFilterKeywordDiscoverOwner() , userInfo.name )
                        cachesNear.indexMoreCaches = 0
                        cachesNear.sendRequest(connector.tokenKey)

                        fastMap.mapItem.center =QtPositioning.coordinate(listModel.get(index).valLat , listModel.get(index).valLon)
                    }
                }

                Column {
                    leftPadding: 20
                    topPadding: 10

                    Text {
                        text: lat + main.formatLat(valLat)
                        color: Palette.greenSea()
                        font.family: localFont.name
                    }

                    Text {
                        text: lon + main.formatLon(valLon)
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
        if((geocodeModel.count)*(main.height/6 )<= main.height*0.9)
        {
            return (geocodeModel.count)*(main.height/6 )
        } else {
            return main.height*0.9
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
