import QtQuick 2.6
import QtQuick.Controls 2.0
import QtPositioning 5.2

import "JavaScript/helper.js" as Helper
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
                font.pointSize: 14
                text: "Name"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
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
                font.pointSize: 14
                text: "Type"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
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
                font.pointSize: 14
                text: "Taille"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
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
                font.pointSize: 14
                text: "Géocode"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
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
                font.pointSize: 14
                text: "Distance"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: Helper.formatDistance(Math.round(currentPosition.position.coordinate
                                                       .distanceTo(QtPositioning.coordinate(fullCache.lat, fullCache.lon))))
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
                font.pointSize: 14
                text: "Difficulté"
                color: Palette.silver()
            }

            RaterField {
                y: 5
                reversedColor: true
                ratingName: " "
                ratingValue: fullCache.difficulty
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Terrain"
                color: Palette.silver()
            }

            RaterField {
                y: 5
                reversedColor: true
                ratingName:" "
                ratingValue: fullCache.terrain
            }
        }

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Favori"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.favoritePoints
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
                font.pointSize: 14
                text: "Propriétaire"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.owner
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
                font.pointSize: 14
                text: "Localisation"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.location
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
                font.pointSize: 14
                text: "Coordonnées"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: main.formatLat(fullCache.lat) + "   " + main.formatLon(fullCache.lon)
                color: Palette.white()
            }
        }

        Rectangle {
            id: separator
            width: parent.width
            height: 2
            color: Palette.white()
            radius:10

        }

        Row {
            width: parent.width
            spacing: 2

            Repeater {
                model:8
                Image {
                    source: "qrc:/Image/" + cacheAttributes.attributes[fullCache.attributes[index]-1].icon
                }
            }
        }
    }
}
