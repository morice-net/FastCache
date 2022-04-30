import QtQuick 2.6
import QtQuick.Controls 2.5
import QtPositioning 5.2

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

import com.mycompany.connecting 1.0

Item {
    id: detailsPage
    visible:true

    property bool formatCoordinates: true

    Column {
        spacing: 5
        anchors.fill: parent
        anchors.topMargin: fastCacheHeaderIcon.height * 2
        clip: true

        Row {
            spacing: 15

            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Nom"
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
                text: fullCache.type
                color: Palette.white()
            }
        }

        Row {
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
                text: fullCache.size
                color: Palette.white()
            }
        }

        Row {
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
            spacing: 15

            Text {
                id:diff
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Difficulté"
                color: Palette.silver()
            }

            RaterField {
                anchors.verticalCenter: diff.verticalCenter
                y: 5
                reversedColor: true
                ratingName: " "
                ratingValue: fullCache.difficulty
            }
        }

        Row {
            spacing: 15

            Text {
                id:terr
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Terrain"
                color: Palette.silver()
            }

            RaterField {
                anchors.verticalCenter: terr.verticalCenter
                y: 5
                reversedColor: true
                ratingName:" "
                ratingValue: fullCache.terrain
            }
        }

        Row {
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
            spacing: 15

            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Cachée le"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: new Date(fullCache.date).toLocaleDateString(Qt.locale("fr_FR"))
                color: Palette.white()
            }
        }

        Row {
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
            spacing: 15

            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text:  fullCache.isCorrectedCoordinates ? "Coord.modif" : "Coordonnées"
                color: Palette.silver()
            }

            Text {
                id: coordinates
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.isCorrectedCoordinates ? formatLatText(formatCoordinates , fullCache.correctedLat) + "  ,   " +
                                                         formatLonText(formatCoordinates , fullCache.correctedLon) :
                                                         formatLatText(formatCoordinates , fullCache.lat) + "  ,   " +
                                                         formatLonText(formatCoordinates , fullCache.lon)
                color: Palette.white()

                MouseArea {
                    anchors.fill: parent
                    onClicked: formatCoordinates = !formatCoordinates
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 2
            color: Palette.white()
            radius: 10
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 14
            text: fullCache.favorited ? "Cette cache est dans vos favoris": "Cette cache n'est pas dans vos favoris"
            color: Palette.white()
        }

        Rectangle {
            id: rect
            width: parent.width
            height: 2
            color: Palette.white()
            radius:10
        }

        CacheAttributes {
            id: cacheAttributes
            anchors.top: rect.bottom
        }
    }

    function formatLatText(format , lat) {
        if(format)  {
            return Functions.formatLat(lat)
        } else {
            return lat
        }
    }

    function formatLonText(format , lon) {
        if(format)  {
            return Functions.formatLon(lon)
        } else {
            return lon
        }
    }
}


