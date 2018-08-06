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

    property var listDifficultyTerrain : [settings.difficultyMin , settings.difficultyMax , settings.terrainMin , settings.terrainMax]

    property bool excludeFound : settings.excludeCachesFound
    property bool excludeArchived: settings.excludeCachesArchived    

    visible: true
    anchors.fill: parent

    PositionSource {
        id: currentPosition
        updateInterval: 1000
        active: true       
    }

    CachesBBox {
        id: cachesBBox
        onCachesChanged: fastMap.mapItem.updateCachesOnMap()
    }

    CachesNear{
        id: cachesNear
    }

    FastMap { id: fastMap }

    FastList { id: fastList }

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
            reloadCaches()
        }
    }

    CacheTypes {
        id: cacheTypes
    }

    CacheSizes {
        id: cacheSizes
    }

    Component.onCompleted: {
        main.state = "map"

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
        if(list.length == cacheTypes.types.length)
            return []
        return list
    }

    function createFilterSizesGs(){
        var  list = [] ;
        for (var i = 0; i < listSizes.length; i++) {
            if(listSizes[i] === true ){
                list.push( cacheSizes.sizes[i].sizeIdGs)
            }
        }
        if(list.length == cacheSizes.sizes.length - 1)
            return []
        return list
    }

    function createFilterDifficultyTerrainGs(){
        var  list = []
        list.push(listDifficultyTerrain[0])
        list.push(listDifficultyTerrain[1])
        list.push(listDifficultyTerrain[2])
        list.push(listDifficultyTerrain[3])
        return list
    }

    function createFilterExcludeCachesFound(){
        return excludeFound
    }

    function createFilterExcludeCachesArchived(){
        return excludeArchived
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

    Timer {
        id: lastReload
        interval: 4000
    }

    function reloadCaches(){
        if (lastReload.running){
            return;
        }
        lastReload.start()

        cachesBBox.latBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).latitude
        cachesBBox.lonBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).longitude
        cachesBBox.latTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).latitude
        cachesBBox.lonTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).longitude

        cachesBBox.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),createFilterExcludeCachesFound(),
                                      createFilterExcludeCachesArchived(),userInfo.name )
        cachesBBox.sendRequest(connector.tokenKey)
    }

    function  cacheMarkerId(typeGs) {
        for (var i = 0; i < cacheTypes.types.length; i++) {
            if(cacheTypes.types[i].typeIdGs === typeGs ){
                return  cacheTypes.types[i].markerId
            }
        }
        return
    }

}
