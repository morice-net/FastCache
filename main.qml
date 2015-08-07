import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebKit 3.0

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

    WebView {
        url: "https://www.geocaching.com/oauth/mobileoauth.ashx?oauth_callback=x-locus%3A%2F%2Foauth.callback%2Fcallback%2Fgeocaching&oauth_consumer_key=90C7F340-7998-477D-B4D3-AC48A9A0F560&oauth_nonce=48293542179&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1438953000&oauth_version=1.0&oauth_signature=Foz01H5OF4JnXITLEp4VuciD9rI%3D"
        anchors.fill: parent
    }

    LoadingPage {
        id: loadingPage
    }

    Component.onCompleted: {
        loadingPage.opacity = 0;
    }

    function onConnected() {

    }
}
