import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebView 1.1


import "QML/JavaScript/Palette.js" as Palette
import "QML"
import com.mycompany.connecting 1.0

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

    MouseArea {
        anchors.fill: parent
        onClicked: connector.connect()
    }

    // Used for loggin
    WebView {
        id: webEngine
        url: ""
        anchors.fill: parent
        visible: false

        onLoadingChanged: {
            if (loadRequest.errorString == "net::ERR_UNKNOWN_URL_SCHEME") {
                console.log("error: " + loadRequest.errorString + " url: " + loadRequest.url)
                connector.oauthVerifierAndToken(loadRequest.url)
                webEngine.visible = false
            }
        }
    }

    LoadingPage {
        id: loadingPage
    }

    Component.onCompleted: {
        loadingPage.opacity = 0;
    }

    function onConnected() {

    }

    Connector{
        id: connector
        onLogOn: {
            console.log("\n\n***\nDownloading... " + url);
            webEngine.url = url;
            webEngine.visible = true;
        }
    }
}
