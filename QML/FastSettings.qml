import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtPositioning 5.3
import Qt.labs.settings 1.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Settings {
    id: settings

    // tokens
    property string tokenKey: ""
    property string tokenSecret: ""

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

    // filter by size.
    property bool micro: true
    property bool small: true
    property bool regular: true
    property bool large: true
    property bool notChosen: true
    property bool virtualSize: true
    property bool other: true

    // filter by difficulty
    property real difficultyMin: 1
    property real difficultyMax: 5

    // filter byterrain
    property real terrainMin: 1
    property real terrainMax: 5

    // Exclude caches found.
    property bool excludeCachesFound: true

    // Exclude caches archived.
    property bool excludeCachesArchived: true
}




