import QtQuick 2.6
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: detailsPage
    Column {
        spacing: 5
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.05

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Name"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: fullCache.name
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Type"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: main.cacheType(fullCache.type)
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Taille"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: main.cacheSize(fullCache.size)
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Géocode"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: fullCache.geocode
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Distance"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Difficulté"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Terrain"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Favori"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Propriétaire"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Localisation"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
                text: "Coordonnées"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 13
                text: ""
                color: Palette.white()
            }
        }
    }
}
