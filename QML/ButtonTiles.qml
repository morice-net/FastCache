import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: buttonTiles

    Text {
        id: tiles
        anchors.top: parent.bottom
        text: "Tuiles"
        color: tilesDownloader.folderSizeOsm === "" ? Palette.silver() : Palette.greenSea()
        font.family: localFont.name
        font.pointSize: 16
    }

    Text {
        anchors.top: tiles.bottom
        anchors.left: tiles.left
        anchors.leftMargin: 20
        text: tilesDownloader.folderSizeOsm !== "" ? tilesDownloader.folderSizeOsm + " (appui long pour supprimer les tuiles)"  : ""
        color: Palette.greenSea()
        font.family: localFont.name
        font.pointSize: 12

        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                tilesDownloader.removeDir(tilesDownloader.dirOsm)
            }
        }
    }

    Component.onCompleted: {
        tilesDownloader.dirSizeOsm()
    }
}
