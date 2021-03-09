import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

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
        height: parent.height * 0.20
        anchors.top: coordinatesButtonMenu.bottom
        anchors.topMargin: 25
        buttonText: "Géocode de la cache"

        TextField {
            id: geocodeCache
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            color: Palette.turquoise()
            font.pointSize: 16
            placeholderText: "GC               "
            background: Rectangle {
                implicitHeight: 30
                color: Palette.white()
                radius: 10
            }
        }

        function buttonClicked() {
        }
    }

    FastSelectableButtonMenu {
        id: codeTravelBugButtonMenu
        height: parent.height * 0.20
        anchors.top: geocodeCacheButtonMenu.bottom
        anchors.topMargin: 25
        buttonText: "Code du travel bug"

        TextField {
            id: codeTravelBug
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            color: Palette.turquoise()
            font.pointSize: 16
            placeholderText: "                 "
            background: Rectangle {
                implicitHeight: 30
                color: Palette.white()
                radius: 10
            }
        }

        function buttonClicked() {
        }
    }
}
