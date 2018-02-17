import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebView 1.1
import Qt.labs.settings 1.0

import "QML/JavaScript/Palette.js" as Palette
import "QML"
import com.mycompany.connecting 1.0

Item {

    id: main

    FastSettings { id: settings }

    property var listTypes : [settings.traditional , settings.mystery , settings.multi , settings.earth , settings.cito,
        settings.ape , settings.event , settings.giga , settings.letterbox , settings.mega , settings.virtual ,
        settings.webcam , settings.wherigo , settings.gchq]

    property var listSizes : [settings.micro , settings.small , settings.regular , settings.large , settings.notChosen,
        settings.virtualSize , settings.other]

    visible: true
    anchors.fill: parent

    PositionSource {
        id: currentPosition
        updateInterval: 1000
        active: true
    }

    CachesBBox {
        id: cachesBBox

        latBottomRight: fastMap.mapItem.toCoordinate(Qt.point(main.x,main.height)).latitude
        lonBottomRight: fastMap.mapItem.toCoordinate(Qt.point(main.x,main.height)).longitude
        latTopLeft: fastMap.mapItem.toCoordinate(Qt.point(main.width,main.y)).latitude
        lonTopLeft: fastMap.mapItem.toCoordinate(Qt.point(main.width,main.y)).longitude

        onCachesChanged: fastMap.mapItem.updateCachesOnMap()
    }

    FastMap { id: fastMap }

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
        onRequestReady:{
            cachesBBox.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),createFilterExcludeCachesFound(),
                                          createFilterExcludeCachesArchived(),userInfo.name )
            cachesBBox.sendRequest(connector.tokenKey)
        }
    }

    CacheTypes {
        id: cacheTypes
    }

    CacheSizes {
        id: cacheSizes
    }

    Component.onCompleted: {
        // retrieve settings (todo: remove and put alias in settings instead)
        connector.tokenKey = settings.tokenKey

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
        console.log(" ---> TYPES       ###########")
        console.log(cacheTypes.types[0].typeId)
        console.log(cacheTypes.types[0].pattern)
        console.log(cacheTypes.types[0].markerId)
        console.log(cacheTypes.types[0].typeIdGs)
        console.log(" ---> SIZES       ###########")
        console.log(cacheSizes.sizes[6].sizeId)
        console.log(cacheSizes.sizes[6].sizeIdGs)

    }

    function createFilterTypesGs(){
        var  list = []
  //      cacheTypes.types.reverse()
        for (var i = 0; i < listTypes.length; i++) {
            if(listTypes[i] === false ){
                list.push( cacheTypes.types[i].typeIdGs)
                if(cacheTypes.types[i].markerId === 6){
                    list.push(4738 )
                    list.push(1304)
                    list.push(3653 )
                }
            }
        }
   //     cacheTypes.types.reverse()
        if(list.length == cacheTypes.types.length)
            return []
        return list
    }

    function createFilterSizesGs(){
        var  list = [] ;
        cacheSizes.sizes.reverse()
        for (var i = 0; i < listSizes.length; i++) {
            if(listSizes[i] === true ){
                list.push( cacheSizes.sizes[i].sizeIdGs)
            }
        }
        cacheSizes.sizes.reverse()
        if(list.length == cacheSizes.sizes.length - 1)
            return []
        return list
    }

    function createFilterDifficultyTerrainGs(){
        var  list = []
        list.push(settings.difficultyMin)
        list.push(settings.difficultyMax)
        list.push(settings.terrainMin)
        list.push(settings.terrainMax)
        return list
    }

    function createFilterExcludeCachesFound(){
        return settings.excludeCachesFound
    }

    function createFilterExcludeCachesArchived(){
        return settings.excludeCachesArchived
    }

    function disconnectAccount() {
        connector.tokenKey = ""
        userInfo.name = ""
        userInfo.finds = 0
        userInfo.avatarUrl = ""
        userInfo.premium = ""
    }

    function reconnectAccount() {
        connector.connect()
    }

    function reloadCaches(){
        fastMap.clearMap()
        cachesBBox.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),createFilterExcludeCachesFound(),
                                      createFilterExcludeCachesArchived(),userInfo.name )        
        cachesBBox.sendRequest(connector.tokenKey)
    }
}
