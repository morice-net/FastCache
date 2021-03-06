import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Item {

    Button {
        id: buttonGoback
        icon.source: "qrc:/Image/goback.png"
        icon.width: 50
        icon.height: 50
        topPadding: 20
        leftPadding: 20
        onClicked:{
            direction = false
            openMenu = 2
            fastMenuLevel2.x = -parent.width
        }
        background: Rectangle {
            color: "transparent"
        }
    }

    FastSelectableButtonMenu {
        id: addressButtonMenu
        anchors.top: buttonGoback.bottom
        buttonSelected: main.state === "address"
        buttonText: "Adresse"

        function buttonClicked() {
            if(fastMap.checkedPluginMap().supportsGeocoding()){
                hideMenu()
                openMenu = 2
                direction = false
                fastMenuLevel2.x = -parent.width
                geocode.open()
            } else {
                hideMenu()
                toast.visible = true
                toast.show("Le plugin ne gère pas le géocoding.")
            }
        }
    }

    FastSelectableButtonMenu {
        id: coordinatesButtonMenu
        anchors.top: addressButtonMenu.bottom
        buttonSelected: main.state === "coordinates"
        buttonText: "Coordonnées"

        function buttonClicked() {
            hideMenu()
            openMenu = 2
            direction = false
            fastMenuLevel2.x = -parent.width
            coordinatesBox.backgroundOpacity = 0.9
            coordinatesBox.open()
        }
    }

    FastSelectableButtonMenu {
        id: geocodeCacheButtonMenu
        height: parent.height * 0.17
        anchors.top: coordinatesButtonMenu.bottom
        centeredVertical: false
        buttonText: "Géocode de la cache"

        TextField {
            id: geocodeCache
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            color: Palette.turquoise()
            font.capitalization: Font.AllUppercase
            font.pointSize: 16
            placeholderText: "GC               "
            background: Rectangle {
                color: Palette.white()
                radius: 10
            }
        }

        function buttonClicked() {
            if(geocodeCache.text.length !== 0) {
                if(main.viewState === "fullcache")
                    // previous cache in case the download fails
                    previousGeocode = fullCache.geocode
                fullCache.geocode = geocodeCache.text.toUpperCase()
                fullCacheRetriever.sendRequest(connector.tokenKey)
            }
        }
    }

    FastSelectableButtonMenu {
        id: codeTravelBugButtonMenu
        height: parent.height * 0.17
        anchors.top: geocodeCacheButtonMenu.bottom
        centeredVertical: false
        buttonText: "Code du travel bug"

        TextField {
            id: codeTravelBug
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            color: Palette.turquoise()
            font.capitalization: Font.AllUppercase
            font.pointSize: 16
            placeholderText: "                 "
            background: Rectangle {
                color: Palette.white()
                radius: 10
            }
        }

        function buttonClicked() {
            if(codeTravelBug.text.length !== 0) {
                travelbug.sendRequest(connector.tokenKey , codeTravelBug.text.toUpperCase());
            }
        }
    }

    FastSelectableButtonMenu {
        id: pocketQueriesButtonMenu
        anchors.top: codeTravelBugButtonMenu.bottom
        buttonSelected: main.state === "pocketQuery"
        buttonText: "Pockets Queries"

        function buttonClicked() {
            getPocketsqueriesList.sendRequest(connector.tokenKey)
            direction = true
            openMenu = 2
            fastMenuLevel2.x = -parent.width
        }
    }
}
