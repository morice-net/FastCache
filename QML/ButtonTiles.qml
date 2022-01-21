import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: buttonTiles

    property string folderTiles: ""
    property bool satTiles: false

    Text {
        id: tiles
        anchors.top: parent.bottom
        text: textTiles()
        color: colorTiles()
        font.family: localFont.name
        font.pointSize: 13

        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                if(folderTiles === tilesDownloader.dirOsm) {
                    tilesDownloader.removeDir(tilesDownloader.dirOsm , false)
                } else if(folderTiles === tilesDownloader.dirGooglemaps && settings.sat === false) {
                    tilesDownloader.removeDir(tilesDownloader.dirGooglemaps , false)
                } else if(folderTiles === tilesDownloader.dirGooglemaps && settings.sat === true) {
                    tilesDownloader.removeDir(tilesDownloader.dirGooglemaps , true)
                }
            }
        }
    }

    function textTiles() {
        if(folderTiles === tilesDownloader.dirOsm) {
            return tilesDownloader.folderSizeOsm !== "" ? "Tuiles: "  + tilesDownloader.folderSizeOsm + " (appui long pour supprimer)"  :
                                                          "Tuiles: 0.0 octets"
        } if(folderTiles === tilesDownloader.dirGooglemaps && satTiles === false) {
            return tilesDownloader.folderSizeGooglemapsPlan !== "" ? "Tuiles: "  + tilesDownloader.folderSizeGooglemapsPlan + " (appui long pour supprimer)"
                                                                    : "Tuiles: 0.0 octets"
        } else if(folderTiles === tilesDownloader.dirGooglemaps && satTiles === true) {
            return tilesDownloader.folderSizeGooglemapsSat  !== "" ? "Tuiles: "  + tilesDownloader.folderSizeGooglemapsSat + " (appui long pour supprimer)"
                                                                   : "Tuiles: 0.0 octets"
        }
    }

    function colorTiles() {
        if(folderTiles === tilesDownloader.dirOsm) {
            return tilesDownloader.folderSizeOsm === "" ? Palette.silver() : Palette.greenSea()
        } if(folderTiles === tilesDownloader.dirGooglemaps && satTiles === false) {
            return tilesDownloader.folderSizeGooglemapsPlan === "" ? Palette.silver() : Palette.greenSea()
        } else if(folderTiles === tilesDownloader.dirGooglemaps && satTiles === true) {
            return tilesDownloader.folderSizeGooglemapsSat === "" ? Palette.silver() : Palette.greenSea()
        }
    }
}
