import QtQuick
import QtCore

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Settings {
    id: settings

    // tokens
    property string tokenKey: ""
    property string refreshToken: ""
    property real expiresAt: 0

    // filter by type
    property bool traditional : false
    property bool mystery : false
    property bool multi : false
    property bool earth : false
    property bool cito : false
    property bool ape: false
    property bool event: false
    property bool giga : false
    property bool letterbox: false
    property bool mega: false
    property bool virtual: false
    property bool webcam: false
    property bool wherigo: false
    property bool gchq: false

    // filter by size
    property bool micro: true
    property bool small: true
    property bool regular: true
    property bool large: true
    property bool notChosen: true
    property bool virtualSize: true
    property bool other: true

    // filter by difficulty
    property real difficultyMin: 1.0
    property real difficultyMax: 5.0

    // filter byterrain
    property real terrainMin: 1.0
    property real terrainMax: 5.0

    // Exclude caches found
    property bool excludeCachesFound: true

    // Exclude caches archived
    property bool excludeCachesArchived: true

    // Filter by key word
    property string keyWord: ""

    // Filter by discover
    property string discover: ""

    // Filter by owner
    property string owner: ""

    // Maps : osm,googlemaps,mapbox
    property var listPlugins: ["osm", "googlemaps", "mapbox"]
    property string namePlugin: "osm"
    property bool sat: false

    // Circles on map around caches
    property bool circlesCaches : false

    // Circle on map (radius in km )
    property bool circleMap : false
    property real circleMapRadius : 10.0

    // Maximum number of caches in a list
    property int maxCachesInList : 100

    onMaxCachesInListChanged: {
        cachesBBox.maxCaches = maxCachesInList
        cachesNear.maxCaches = maxCachesInList
        cachesPocketqueries.maxCaches = maxCachesInList
    }
    Component.onCompleted: {
        cachesBBox.maxCaches = maxCachesInList
        cachesNear.maxCaches = maxCachesInList
        cachesPocketqueries.maxCaches = maxCachesInList
    }
}




