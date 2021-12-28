import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: buttonTiles

    Image {
        id: icon
        source:"qrc:/Image/" + "icon_check.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(tilesDownloader.folderSizeOsm !== "")
                    deleteButton.visible = !deleteButton.visible
            }
        }
    }

    Text {
        id: tiles
        anchors.left: icon.right
        anchors.leftMargin: 20
        text: "Tuiles"
        color: tilesDownloader.folderSizeOsm === "" ? Palette.silver() : Palette.greenSea()
        font.family: localFont.name
        font.pointSize: 16
    }

    Text {
        anchors.top: tiles.bottom
        anchors.left: tiles.left
        anchors.leftMargin: 10
        text: tilesDownloader.folderSizeOsm
        color: Palette.greenSea()
        font.family: localFont.name
        font.pointSize: 10
    }

    FastButton {
        id: deleteButton
        visible: false
        text:  "Supprimer les tuiles"
        onClicked: deleteButton.visible = false
        onPressAndHold: {
            tilesDownloader.removeDir(tilesDownloader.dirOsm)
            deleteButton.visible = false
        }
    }

    Component.onCompleted: {
        tilesDownloader.dirSizeOsm()
    }
}
