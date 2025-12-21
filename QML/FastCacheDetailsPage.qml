import QtQuick
import QtPositioning

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette

Item {
    id: detailsPage
    visible:true

    property bool formatCoordinates: true
    property bool adventureLabLaunched: false //adventure Lab launched for lab caches
    property int cachesFindCount: findCount

    onCachesFindCountChanged: {
        // dynamic updating of a lab cache
        if(fullCache.type === "labCache" && main.listState !== "recorded") {  //lab cache not recorded
            fullLabCacheRetriever.sendRequest(connector.tokenKey)
        } else if(fullCache.type === "labCache" && main.listState === "recorded") { //lab cache recorded
            fullLabCacheRetriever.parseJson(sqliteStorage.readColumnJson("fullcache" , fullCache.geocode ))
        }
    }

    Connections {
        target: Qt.application
        function onStateChanged() {
            console.log("Application state:  " + Qt.application.state)
            if(Qt.application.state === Qt.ApplicationActive && adventureLabLaunched === true ) { // we return to the main application
                adventureLabLaunched = false
                if(fullCache.type === "labCache" && main.listState === "recorded") { //lab cache recorded
                    var listGeocode = []
                    var listLatitude = []
                    var listLongitude = []
                    listGeocode.push(fullCache.geocode)
                    listLatitude.push(fullCache.lat)
                    listLongitude.push(fullCache.lon)
                    fullLabCachesRecorded.sendRequest(connector.tokenKey , listGeocode ,listLatitude ,listLongitude ,
                                                      sqliteStorage.cacheInLists("cacheslists", fullCache.geocode) , sqliteStorage)
                }
                userInfo.sendRequest(connector.tokenKey, getTravelbugUser)  // updates the number of caches found
                return
            }
        }
    }

    Column {
        spacing: 3
        anchors.fill: parent
        anchors.topMargin: fastCacheHeaderIcon.height * 1.3
        clip: true

        //load wherigo cartridge
        FastButton {
            id: buttonWherigo
            visible: fullCache.type === "Wherigo"    // cache wherigo
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 13
            text: "charger le cartouche wherigo"
            onClicked: {
                wherigoCartridge.downloadCartridge(connector.tokenKey, fullCache.cartridgeGuid , fullCache.geocode)
            }
        }

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
                text: fullCache.type !== "labCache" ? fullCache.type : "Lab Cache"
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
            visible: fullCache.type === "labCache"

            Text {
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Mode"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.adventureType === "Nonsequential" ? "Non séquentiel" : "Séquentiel"
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
                width: fastCache.width * 0.3
                font.family: localFont.name
                font.pointSize: 14
                text: fullCache.geocode
                color: Palette.white()
                elide: Text.ElideRight
                clip: true
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
                text: Helper.formatDistance(Math.round(locationSource.distanceTo(QtPositioning.coordinate(fullCache.isCorrectedCoordinates ?
                                                                                                              fullCache.correctedLat : fullCache.lat,
                                                                                                          fullCache.isCorrectedCoordinates ?
                                                                                                              fullCache.correctedLon : fullCache.lon))))
                color: Palette.white()
            }
        }

        Row {
            spacing: 15
            visible: fullCache.type === "labCache"

            Text {
                id: note
                width: fastCache.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Note"
                color: Palette.silver()
            }

            RaterField {
                anchors.verticalCenter: note.verticalCenter
                y: 5
                reversedColor: true
                ratingName: "   " + fullCache.ratingsAverage.toString()  + " sur un total de " + fullCache.ratingsTotalCount
                ratingValue: fullCache.ratingsAverage
            }
        }

        Row {
            spacing: 15
            visible: fullCache.type !== "labCache"

            Text {
                id: diff
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
            visible: fullCache.type !== "labCache"

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
            visible: fullCache.type !== "labCache"

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
            visible: fullCache.type !== "labCache"

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
                color: Palette.blueGreen()

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        ownerProfile.originalUrl = fullCache.ownerUrl
                        ownerProfile.open()
                    }
                }
            }
        }

        Row {
            spacing: 15
            visible: fullCache.type !== "labCache"

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
            visible: fullCache.type !== "labCache"

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
                text: fullCache.isCorrectedCoordinates ? "Coord.modif" : "Coordonnées"
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
                color: Palette.blueGreen()

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
            visible: fullCache.type === "labCache"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 17
            text: "Ouvrez l'application Adventure Lab pour\n continuer cette aventure...."
            color: Palette.white()
        }

        FastButtonIcon {
            id: buttonAdventureLab
            visible: fullCache.type === "labCache"
            anchors.horizontalCenter: parent.horizontalCenter
            height: 60
            width: 60
            source: "../Image/" + "icon_AdventureLab.png"
            sourceWidth: 60
            sourceHeight: 60
            onClicked: {
                fullCache.launchAdventureLab(fullCache.shortDescription)
                adventureLabLaunched = true
            }
        }

        Text {
            visible: fullCache.type !== "labCache"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 14
            text: fullCache.favorited ? "Cette cache est dans vos favoris": "Cette cache n'est pas dans vos favoris"
            color: Palette.white()
        }

        Rectangle {
            id: line
            visible: fullCache.type !== "labCache"
            width: parent.width
            height: 2
            color: Palette.white()
            radius:10
        }

        CacheAttributes {
            id: cacheAttributes
            visible: fullCache.type !== "labCache"
        }
    }
}


