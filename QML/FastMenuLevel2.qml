import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {

    Button {
        id: buttonGoback
        icon.source: "../Image/goback.png"
        icon.width: 40
        icon.height: 30
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
        buttonSelected: main.listState === "address"
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
        buttonSelected: main.listState === "coordinates"
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
            horizontalAlignment: TextInput.AlignHCenter
            anchors.bottomMargin: 10
            color: Palette.turquoise()
            font.capitalization: Font.AllUppercase
            font.pointSize: 16
            background: Rectangle {
                implicitWidth: geocodeCacheButtonMenu.width / 2
                implicitHeight: 20
                color: Palette.white()
                radius: 10
            }
        }

        function buttonClicked() {
            if(geocodeCache.text.length !== 0) {
                if(main.viewState === "fullcache")
                    // previous cache in case the download fails
                    previousGeocode = fullCache.geocode
                hideMenu()
                fullCache.geocode = geocodeCache.text.toUpperCase()
                fullCacheRetriever.sendRequest(connector.tokenKey)
                main.listState = ""
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
            horizontalAlignment: TextInput.AlignHCenter
            anchors.bottomMargin: 10
            color: Palette.turquoise()
            font.capitalization: Font.AllUppercase
            font.pointSize: 16
            background: Rectangle {
                implicitWidth: codeTravelBugButtonMenu.width / 2
                implicitHeight: 20
                color: Palette.white()
                radius: 10
            }
        }

        function buttonClicked() {
            if(codeTravelBug.text.length !== 0) {
                hideMenu()
                travelbug.sendRequest(connector.tokenKey , codeTravelBug.text.toUpperCase());
            }
        }
    }

    FastSelectableButtonMenu {
        id: pocketQueriesButtonMenu
        anchors.top: codeTravelBugButtonMenu.bottom
        buttonSelected: main.listState === "pocketQuery"
        buttonText: "Pockets Queries"

        function buttonClicked() {
            getPocketsqueriesList.sendRequest(connector.tokenKey)
            direction = true
            openMenu = 2
            fastMenuLevel2.x = -parent.width
        }
    }
}
