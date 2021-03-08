import QtQuick 2.6

Item {

    MouseArea {
        anchors.fill: parent
        onClicked: {
            fastMenuLevel1.x = 0
            fastMenuLevel2.x  = -parent.width
        }
    }

    FastSelectableButtonMenu {
        id: addressButtonMenu
        anchors.top: nearButtonMenu.bottom
        anchors.topMargin: 25
        buttonSelected: main.state === "address"
        buttonText: "Adresse"

        function buttonClicked() {
            main.state = "address"
            if(fastMap.checkedPluginMap().supportsGeocoding()){
                main.cachesActive = false
                hideMenu()
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
        anchors.topMargin: 25
        buttonSelected: main.state === "coordinates"
        buttonText: "Coordonnées"

        function buttonClicked() {
            main.state = "coordinates"
            main.cachesActive = false
            hideMenu()
            coordinatesBox.open()
        }
    }

    FastSelectableButtonMenu {
        id: geocodeCacheButtonMenu
        anchors.top: coordinatesButtonMenu.bottom
        anchors.topMargin: 25
        buttonText: "Géocode de la cache"

        function buttonClicked() {
        }
    }

    FastSelectableButtonMenu {
        id: codeTravelBugButtonMenu
        anchors.top: geocodeCacheButtonMenu.bottom
        anchors.topMargin: 25
        buttonText: "Code du travel bug"

        function buttonClicked() {
        }
    }
}
