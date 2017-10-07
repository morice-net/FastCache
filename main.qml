import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebView 1.1
import Qt.labs.settings 1.0

import "QML/JavaScript/Palette.js" as Palette
import "QML"
import com.mycompany.connecting 1.0

Item {
    id: main
    visible: true
    anchors.fill: parent

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
        id: fastMap
        anchors.top: fastMenuHeader.bottom
    }

    FastMenuHeader { id: fastMenuHeader }

    FastMenu { id: fastMenu }

    // Used for loggin
    WebView {
        id: webEngine
        url: ""
        anchors.fill: parent
        visible: false

        onLoadingChanged: {
            if (tools.beginsWith(loadRequest.url, "http://oauth.callback/") ) {
                connector.oauthVerifierAndToken(loadRequest.url)
                webEngine.visible = false
            }
        }
    }

    LoadingPage { id: loadingPage }

    /////////////////////////
    // Invisible elements  //
    /////////////////////////

    FontLoader { id: localFont; source: "qrc:/Ressources/DellaRespira-Regular.ttf" }

    Tools { id: tools }

    Connector {
        id: connector
        onLogOn: {
            console.log("\n\n***\nDownloading... " + url);
            webEngine.url = url;
            webEngine.visible = true;
        }
        onLoginProcedureDone: userInfo.sendRequest(connector.tokenKey)
    }

    UserInfo {
        id: userInfo
        onRequestReady: cachesBBox.sendRequest(connector.tokenKey)
    }

    CachesBBox {
        id: cachesBBox

        latBottomRight: fastMap.mapItem.toCoordinate(Qt.point(fastMap.x,fastMap.y)).latitude
        lonBottomRight: fastMap.mapItem.toCoordinate(Qt.point(fastMap.x,fastMap.y)).longitude
        latTopLeft: fastMap.mapItem.toCoordinate(Qt.point(main.width,main.height)).latitude
        lonTopLeft: fastMap.mapItem.toCoordinate(Qt.point(main.width,main.height)).longitude
    }

    CacheTypes {
        id: cacheTypes
    }

    CacheSizes {
        id: cacheSizes
    }

    FastSettings { id: settings }

    Component.onCompleted: {

        // retrieve settings (todo: remove and put alias in settings instead)
        connector.tokenKey = settings.tokenKey
        connector.tokenSecret = settings.tokenSecret

        // token key not set means connection to GC needed
        if (connector.tokenKey != "") {
            console.log("FastSettings: tokenKey=" + connector.tokenKey)
            userInfo.sendRequest(connector.tokenKey)
        } else {
            connector.connect()
        }

        // Mask the loading page
        loadingPage.opacity = 0;
    }

    Component.onDestruction: {
        settings.tokenKey = connector.tokenKey
        settings.tokenSecret = connector.tokenSecret
        console.log(" ---> TYPES       ###########")
        console.log(cacheTypes.types[0].typeId)
        console.log(cacheTypes.types[0].pattern)
        console.log(cacheTypes.types[0].markerId)
        console.log(cacheTypes.types[0].typeIdGs)
        console.log(" ---> SIZES       ###########")
        console.log(cacheSizes.sizes[0].sizeId)
        console.log(cacheSizes.sizes[0].sizeIdGs)
        console.log(" ---> BBox       ###########")
        console.log(cachesBBox.caches[0].name)


    }
}
