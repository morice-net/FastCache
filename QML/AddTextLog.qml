import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: addText
    width: main.width/2
    height: item.height + 20
    backgroundRadius: 10
    backgroundColor: Palette.silver()
    x: 30
    y: 30

    Column {
        id: item
        spacing: 25

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Date"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = new Date().toLocaleDateString(Qt.LocaleDate);
                    addText.close() ;
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Heure"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = new Date().getHours(Qt.LocaleDate) + " h : " + new Date().getMinutes(Qt.LocaleDate);
                    addText.close() ;
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Utilisateur"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = userInfo.name ;
                    addText.close() ;
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Propriétaire"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = fullCache.owner
                    addText.close()
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Nom de la cache"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = fullCache.name;
                    addText.close() ;
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Difficulté"
            color: Palette.greenSea()
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = fullCache.difficulty;
                    addText.close() ;
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Terrain"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = fullCache.terrain;
                    addText.close() ;
                }
            }
        }

        Label {
            font.pointSize: 16
            font.family: localFont.name
            text: "Taille"
            color: Palette.greenSea()

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addLog = fullCache.size;
                    addText.close() ;
                }
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}
