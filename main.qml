import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebEngine 1.0


import "QML/JavaScript/Palette.js" as Palette
import "QML"

Item {
    id: main
    visible: true
    anchors.fill: parent

    signal connect

    FastSettings {
        id: settings
    }

    PositionSource {
        id: currentPosition
        updateInterval: 1000
        active: true

        onPositionChanged: {
            var coord = currentPosition.position.coordinate;
            console.log("Coordinate:", coord.longitude, coord.latitude);
        }
    }

    FastMap {

    }

    /*
    WebEngineView {
        url: ""
        anchors.fill: parent
    }
    */

    LoadingPage {
        id: loadingPage
    }

    MouseArea {
        anchors.fill: parent
        onClicked: main.connect()
    }

    Component.onCompleted: {
        loadingPage.opacity = 0;
    }

    function onConnected() {

    }
}
