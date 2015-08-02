import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3

import "QML/JavaScript/Palette.js" as Palette
import "QML"

Item {
    id: main
    visible: true
    anchors.fill: parent

    signal connect(string login, string pass)

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

    LoadingPage {
        id: loadingPage
    }

    LoginPage {
        id: loginPage
        height: 140
        width: 400
        anchors.centerIn: parent
        visible: true
    }

    Component.onCompleted: {
        loadingPage.opacity = 0;
    }

}
