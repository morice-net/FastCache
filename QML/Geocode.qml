import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.3
import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0
import QtPositioning 5.3
import QtLocation 5.6

import "JavaScript/Palette.js" as Palette


Popup {
    id: geocode

    opacity: 0
    background: Rectangle {
        x:20
        y:20
        implicitWidth: main.width*0.8
        implicitHeight:main.height*0.4
        color:Palette.turquoise()
        border.color: Palette.greenSea()
        border.width: 1
        opacity:0.9
        radius: 10
    }

    ColumnLayout {
        id: tabRectangle
        y: 20
        height: tabTitle.height * 2
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.left: parent.left
        anchors.right: parent.right

        Label {
            id: tabTitle
            color: Palette.white()
            text: qsTr("Adresse")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        id: item2
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.bottomMargin: 20
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: tabRectangle.bottom

        GridLayout {
            id: gridLayout3
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            rowSpacing: 10
            rows: 1
            columns: 2
            anchors.fill: parent

            Label {
                id: label2
                text: qsTr("Rue")
                color: Palette.white()
            }

            TextField {
                id: street
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: street.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label3
                text: qsTr("Ville")
                color: Palette.white()
            }

            TextField {
                id: city
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: city.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label4
                text: qsTr("Etat")
                color: Palette.white()
            }

            TextField {
                id: stateName
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: stateName.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label5
                text: qsTr("Pays")
                color: Palette.white()
            }

            TextField {
                id: country
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: country.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label6
                text: qsTr("Code postal")
                color: Palette.white()
            }

            TextField {
                id: postalCode
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: postalCode.focus ? Palette.black() :Palette.turquoise()
                }
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
                        anchors.margins: 5
                        opacity: 0.9
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
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
                        anchors.margins: 5
                        opacity: 0.9
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
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

    Behavior on opacity { NumberAnimation { duration: 800 } }


    onVisibleChanged: {
        if (visible)
            opacity = 1
        else
            opacity = 0
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

    Popup {
        id: geocodeResponse

        Component {
            id: delegate

            Item {
                width: main.width/1.6
                height: main.height/5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        geocodeResponse.close()
                        main.state = "address"
                        cachesNear.latPoint = listModel.get(index).valLat
                        cachesNear.lonPoint = listModel.get(index).valLon
                        cachesNear.distance = 100000
                        cachesNear.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),createFilterExcludeCachesFound(),
                                                      createFilterExcludeCachesArchived(),createFilterKeywordDiscoverOwner() , userInfo.name )
                        cachesNear.sendRequest(connector.tokenKey)

                    }
                }

                Column {
                    leftPadding: 20
                    topPadding: 10

                    Text {
                        text: lat + valLat
                        color: Palette.white()
                    }

                    Text {
                        text: lon + valLon
                        color: Palette.white()
                    }

                    Text {
                        text: city + valCity
                        color: Palette.white()
                    }

                    Text {
                        text: state + valState
                        color: Palette.white()
                    }

                    Text {
                        text: country + valCountry
                        color: Palette.white()
                    }

                }
            }
        }

        ListModel {
            id: listModel
        }

        ListView {
            id: geocodelist
            width: parent.width
            model: listModel
            delegate: delegate
            ScrollBar.vertical: ScrollBar {}
            highlight: Rectangle { color: Palette.turquoise(); radius: 10 }
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
                listModel.append({"lat":"Latitude:  " , "valLat": Math.round(geocodeModel.get(i).coordinate.latitude * 10000) / 10000,
                                     "lon":"Longitude:   " , "valLon": Math.round(geocodeModel.get(i).coordinate.longitude * 10000) / 10000,
                                     "city":"Ville:   " ,"valCity":geocodeModel.get(i).address.city,
                                     "state":"Etat:   " ,"valState":geocodeModel.get(i).address.state,
                                     "country":"Pays:   " , "valCountry": geocodeModel.get(i).address.country});

            }
            geocodeResponse.open()
            geocode.close()
        }
    }
}
