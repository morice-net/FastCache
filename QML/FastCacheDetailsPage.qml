import QtQuick 2.6
import QtQuick.Controls 2.5
import QtPositioning 5.2

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: detailsPage
    visible:true

    Column {
        spacing: 5
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.05
        clip: true

        Row {
            width: parent.width
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
                text: fullCache.type
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
                text: fullCache.size
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
                text:  fullCache.isCorrectedCoordinates ? "Coord.modif" : "Coordonnées"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.isCorrectedCoordinates ? main.formatLat(fullCache.correctedLat) + "   " + main.formatLon(fullCache.correctedLon) :
                                                         main.formatLat(fullCache.lat) + "   " + main.formatLon(fullCache.lon)
                color: Palette.white()
            }
        }

        Text {
            x:10
            width: parent.width
            font.family: localFont.name
            font.pointSize: 14
            text:fullCache.favorited ? "Cette cache est dans vos favoris": "Cette cache n'est pas dans vos favoris"
            color: Palette.white()
        }

        Rectangle {
            id: separator
            width: parent.width
            height: 2
            color: Palette.white()
            radius:10
        }

        Rectangle {
            id:rect
            anchors.top:separator.bottom
            width: parent.width
            height:attIcons.visible ? attIcons.height : attText.height
            color: Palette.greenSea()
            visible: true

            // attributes of caches(icons)
            Grid {
                id:attIcons
                x:10
                y:10
                visible: true
                width: parent.width
                columns:10
                spacing: 17

                Repeater {
                    model:fullCache.attributes.length

                    Image {
                        scale:1.3
                        source:"qrc:/Image/" + cacheAttributes.attributesIcon[fullCache.attributes[index]-1]
                        Image {
                            source:"qrc:/Image/Attributes/attribute_no.png"
                            visible: !fullCache.attributesBool[index]
                        }
                    }
                }
            }

            // attributes of caches(text)
            Flickable {
                clip: true
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick
                contentHeight: attText.height + 100
                ScrollBar.vertical: ScrollBar {}

                Column {
                    id:attText
                    x:10
                    width: parent.width
                    visible:!attIcons.visible

                    Repeater {
                        model:fullCache.attributes.length

                        Text {
                            text:fullCache.attributesBool[index] ? cacheAttributes.attributesYes[fullCache.attributes[index]-1]
                                                                 : cacheAttributes.attributesNo[fullCache.attributes[index]-1]
                            font.family: localFont.name
                            font.pointSize: 14
                            color: Palette.white()
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        attIcons.visible = ! attIcons.visible ;
                    }
                }
            }
        }
    }
}


