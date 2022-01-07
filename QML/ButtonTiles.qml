import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: buttonTiles

    Text {
        id: tiles
        anchors.top: parent.bottom
        text: tilesDownloader.folderSizeOsm !== "" ? "Tuiles: "  + tilesDownloader.folderSizeOsm + " (appui long pour supprimer)"  : "Tuiles: 0.0 octets"
        color: tilesDownloader.folderSizeOsm === "" ? Palette.silver() : Palette.greenSea()
        font.family: localFont.name
        font.pointSize: 13

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
