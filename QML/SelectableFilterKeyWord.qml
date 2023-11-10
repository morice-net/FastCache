import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

FastPopup {
    height: main.height * 0.6
    width: main.width * 0.8
    backgroundOpacity: 0.9
    backgroundRadius: 8

    Column {
        id: column
        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id:label1
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Mot-clé:"
            font.pointSize: 16
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: mot
            text: qsTr(settings.keyWord)
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/1.5
                radius: 6
                border.color: mot.focus ? Palette.silver() :Palette.greenSea()
            }
            onTextChanged: keyWordButton()
        }

        Label {
            id:label2
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Découvreur:"
            font.pointSize: 16
            color: Palette.white()
            anchors.topMargin: 5
            font.family: localFont.name
        }

        TextField {
            id: decouvreur
            text: qsTr(settings.discover)
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/1.5
                radius: 6
                border.color: decouvreur.focus ? Palette.silver() :Palette.greenSea()
            }
            onTextChanged: keyWordButton()
        }

        Label {
            id: label3
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Proprietaire:"
            font.pointSize: 16
            color: Palette.white()
            font.family: localFont.name
        }

        TextField {
            id: proprietaire
            text: qsTr(settings.owner)
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/1.5
                radius: 6
                border.color: proprietaire.focus ? Palette.silver() :Palette.greenSea()
            }
            onTextChanged: keyWordButton()
        }

        FastButton {
            id: efface
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Effacer"
            font.pointSize: 16
            onClicked: {
                mot.text = ""
                decouvreur.text = ""
                proprietaire.text = ""
                main.listKeywordDiscoverOwner[0] = mot.text
                main.listKeywordDiscoverOwner[1] = decouvreur.text
                main.listKeywordDiscoverOwner[2] = proprietaire.text
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }

    function recordInSettings() {
        settings.keyWord = mot.text
        settings.discover = decouvreur.text
        settings.owner = proprietaire.text
    }

    function keyWordButton() {
        var index = 0
        main.listKeywordDiscoverOwner[0] = mot.text
        main.listKeywordDiscoverOwner[1] = decouvreur.text
        main.listKeywordDiscoverOwner[2] = proprietaire.text
        if(mot.text.length) index += 1
        if(decouvreur.text.length) index += 1
        if(proprietaire.text.length)  index += 1
        if(index === 0) {
            keywordButtonId.text = "Pas de filtres"
        } else if(index === 1) {
            keywordButtonId.text = index + " Filtre"
        } else if(index >> 1) {
            keywordButtonId.text = index + " Filtres"
        }
    }
}
