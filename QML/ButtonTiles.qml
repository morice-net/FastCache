import QtQuick

import "JavaScript/Palette.js" as Palette

Text {
    id: buttonTiles

    property string folderTiles: ""
    property bool satTiles: false

    color: Palette.turquoise()
    font.family: localFont.name
    font.pointSize: 13
    text: {
        if(folderTiles === tilesDownloader.dirOsm) {
            return tilesDownloader.folderSizeOsm !== "" ? "Tuiles: "  + tilesDownloader.folderSizeOsm + " (appui long pour supprimer)"  :
                                                          "Tuiles: 0.0 octets"
        } if(folderTiles === tilesDownloader.dirGooglemaps && satTiles === false) {
            return tilesDownloader.folderSizeGooglemapsPlan !== "" ? "Tuiles: "  + tilesDownloader.folderSizeGooglemapsPlan + " (appui long pour supprimer)"
                                                                   : "Tuiles: 0.0 octets"
        } else if(folderTiles === tilesDownloader.dirGooglemaps && satTiles === true) {
            return tilesDownloader.folderSizeGooglemapsSat  !== "" ? "Tuiles: "  + tilesDownloader.folderSizeGooglemapsSat + " (appui long pour supprimer)"
                                                                   : "Tuiles: 0.0 octets"
        } else if(folderTiles === tilesDownloader.dirCyclOsm) {
            return tilesDownloader.folderSizeCyclOsm  !== "" ? "Tuiles: "  + tilesDownloader.folderSizeCyclOsm + " (appui long pour supprimer)"
                                                             : "Tuiles: 0.0 octets"
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressAndHold: {
            if(folderTiles === tilesDownloader.dirOsm)
                tilesDownloader.removeDir(tilesDownloader.dirOsm, false)
            else if(folderTiles === tilesDownloader.dirGooglemaps && !satTiles)
                tilesDownloader.removeDir(tilesDownloader.dirGooglemaps, false)
            else if(folderTiles === tilesDownloader.dirGooglemaps && satTiles)
                tilesDownloader.removeDir(tilesDownloader.dirGooglemaps, true)
            else if(folderTiles === tilesDownloader.dirCyclOsm)
                tilesDownloader.removeDir(tilesDownloader.dirCyclOsm, false)
        }
    }
}
