import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.3
import QtPositioning 5.3
import QtWebView 1.1
import Qt.labs.settings 1.0
import QtLocation 5.3
import QtSensors 5.3

import "QML/JavaScript/Palette.js" as Palette
import "QML"
import com.mycompany.connecting 1.0

Item {
    id: main
    anchors.fill: parent
    visible: true
    focus: true

    // State can take "near" "address" "coordinates"....
    property string viewState: "" // "map" or "list" or "fullcache" or"travelbug"
    property bool cachesActive: false

    property var listTypes : [settings.traditional , settings.mystery , settings.multi , settings.earth , settings.cito,
        settings.ape , settings.event , settings.giga , settings.letterbox , settings.mega , settings.virtual ,
        settings.webcam , settings.wherigo , settings.gchq]

    property var listSizes : [settings.micro , settings.small , settings.regular , settings.large , settings.notChosen,
        settings.virtualSize , settings.other]

    property var listDifficultyTerrain : [settings.difficultyMin , settings.difficultyMax , settings.terrainMin , settings.terrainMax]

    property var listKeywordDiscoverOwner : [settings.keyWord , settings.discover , settings.owner]

    property bool excludeFound : settings.excludeCachesFound
    property bool excludeArchived: settings.excludeCachesArchived

    // used for the compass.
    property double beginLat
    property double beginLon

    // number of caches found
    property int findCount: userInfo.finds

    signal positionUpdated

    FastSettings { id: settings }

    Location {
        id: beginLocation
        coordinate {
            latitude: beginLat.toFixed(5)
            longitude: beginLon.toFixed(5)
        }
    }

    PositionSource {
        id: currentPosition
        updateInterval: 1000
        active: true
        onPositionChanged: {
            main.positionUpdated()
        }
    }

    CachesBBox {
        id: cachesBBox
        onCachesChanged: fastMap.mapItem.updateCachesOnMap(cachesBBox)
    }

    CachesNear{
        id: cachesNear
        onCachesChanged: fastMap.mapItem.updateCachesOnMap(cachesNear)
    }

    FastMap { id: fastMap }

    FastList { id: fastList }

    FastCache { id: fastCache }

    FastTravelbug { id: fastTravelbug }

    FastMenuHeader { id: fastMenuHeader }

    FastMenu { id: fastMenu }

    Geocode { id: geocode }

    GeocodeAlert { id: geocodeAlert }

    CoordinatesBox { id: coordinatesBox }

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

    SureQuit {
        id: sureQuit
    }

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
                                          createFilterExcludeCachesArchived(),createFilterKeywordDiscoverOwner() , userInfo.name )
            reloadCaches()
        }
    }

    CacheAttributes {
        id: cacheAttributes
    }

    CacheTypes {
        id: cacheTypes
    }

    CacheSizes {
        id: cacheSizes
    }

    WaypointTypes {
        id: waypointTypes
    }

    LogTypes {
        id: logTypes
    }

    FullCache {
        id: fullCache
    }

    Travelbug{
        id: travelbug
    }

    SendCacheNote{
        id:sendCacheNote
        onStateChanged: {
            toast.visible = sendCacheNote.state === "noError" || sendCacheNote.state === "error";
            if (sendCacheNote.state === "error") {
                toast.show("Erreur dans l'envoi de la note personnelle");
            } else {
                toast.show("La note personnelle à été correctement envoyée ");
            }
        }
    }

    SendCacheLog{
        id:sendCacheLog
        onStateChanged: {
            toast.visible = sendCacheLog.state === "noError" || sendCacheLog.state === "error";
            if (sendCacheLog.state === "error") {
                toast.show("Erreur dans l'envoi du log de la cache");
            } else {
                toast.show("Le log de la cache à été correctement envoyé ");
            }
        }
        onFoundsChanged: {
            findCount = sendCacheLog.founds;
            fastCache.swipeToPage(3);
        }
    }

    Location {
        id: fullCacheLocation
        coordinate {
            latitude: fullCache.lat
            longitude: fullCache.lon
        }
    }

    Compass { // the compass sensor object
        id: compass
        active: false // turn the compass on
        skipDuplicates: true // skip similar values
    }

    OrientationSensor {
        id: orientationReading
        active: false
        skipDuplicates: true
    }

    Toast {
        id: toast
    }

    Timer {
        id: lastReload
        interval: 4000
    }

    Component.onCompleted: {
        main.viewState = "map"

        fastMap.mapItem.updateCachesOnMap(cachesBBox)

        // retrieve settings (todo: remove and put alias in settings instead)
        connector.tokenKey = settings.tokenKey

        // token key not set means connection to GC needed
        if (connector.tokenKey != "") {
            console.log("FastSettings: tokenKey=" + connector.tokenKey)
            userInfo.sendRequest(connector.tokenKey)
        } else {
            connector.connect()
        }
    }

    Component.onDestruction: {
        recordAppSettings()
    }

    Keys.onPressed: {
        event.accepted = true
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
            if (webEngine.visible) {
                webEngine.visible = false
            } else if (coordinatesBox.opened) {
                coordinatesBox.close()
            } else if (geocodeAlert.opened) {
                geocodeAlert.close()
            } else if (geocode.opened) {
                geocode.close()
            } else if (fastMenu.isMenuVisible()) {
                fastMenu.hideMenu()
            } else if (fastMenuHeader.isFiltersVisible()) {
                fastMenuHeader.changeFiltersVisibility()
            } else if (main.viewState == "fullcache" || main.viewState == "list") {
                main.viewState = "map"
            } else if (main.viewState == "travelbug") {
                main.viewState = "fullcache"
            }else {
                sureQuit.visible = true
            }
        }
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
        if(list.length === cacheTypes.types.length)
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
        if(list.length === cacheSizes.sizes.length - 1)
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

    function createFilterKeywordDiscoverOwner(){
        var  list = []
        list.push(listKeywordDiscoverOwner[0])
        list.push(listKeywordDiscoverOwner[1])
        list.push(listKeywordDiscoverOwner[2])
        return list
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
        if (lastReload.running){
            return;
        }
        if (!cachesActive){
            return;
        }
        lastReload.start()

        cachesBBox.latBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).latitude
        cachesBBox.lonBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).longitude
        cachesBBox.latTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).latitude
        cachesBBox.lonTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).longitude

        cachesBBox.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),createFilterExcludeCachesFound(),
                                      createFilterExcludeCachesArchived(),createFilterKeywordDiscoverOwner(),userInfo.name )
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

    function  cacheType(typeGs) {
        for (var i = 0; i < cacheTypes.types.length; i++) {
            if(cacheTypes.types[i].typeIdGs === typeGs ){
                return  cacheTypes.types[i].frenchPattern
            }
        }
        return
    }

    function  cacheSize(sizeGs) {
        for (var i = 0; i < cacheSizes.sizes.length; i++) {
            if(cacheSizes.sizes[i].sizeIdGs === sizeGs ){
                return  cacheSizes.sizes[i].frenchPattern
            }
        }
        return
    }

    function  formatLat( lat) {
        var latitude = "N "
        var degrees = 0
        var min = 0.0
        if(lat<0){
            latitude = "S "
        }
        degrees = Math.floor(Math.abs(lat))
        min = (Math.abs(lat) - degrees) * 60
        latitude += degrees + "°" + min.toFixed(3) + "'"
        return latitude

    }

    function  formatLon( lon) {
        var longitude = "E "
        var degrees = 0
        var min = 0.0
        if(lon<0){
            longitude = "O "
        }
        degrees = Math.floor(Math.abs(lon))
        min = (Math.abs(lon) - degrees) * 60
        longitude += degrees + "°" + min.toFixed(3) + "'"
        return longitude
    }

    function  waypointMarker(name) {
        for (var i = 0; i < waypointTypes.types.length; i++) {
            if(waypointTypes.types[i].name === name ){
                return  waypointTypes.types[i].icon
            }
        }
        return
    }

    function  waypointNameFr(name) {
        for (var i = 0; i < waypointTypes.types.length; i++) {
            if(waypointTypes.types[i].name === name ){
                return  waypointTypes.types[i].nameFr
            }
        }
        return
    }

    function  logTypeGs(index) {
        return logTypes.types[index].typeIdGs
    }

    function recordAppSettings() {
        settings.tokenKey = connector.tokenKey
        console.log(" ---> TYPES       ###########")
        console.log(cacheTypes.types[0].typeId)
        console.log(cacheTypes.types[0].pattern)
        console.log(cacheTypes.types[0].markerId)
        console.log(cacheTypes.types[0].typeIdGs)
        console.log(" ---> SIZES       ###########")
        console.log(cacheSizes.sizes[6].sizeId)
        console.log(cacheSizes.sizes[6].sizeIdGs)

        fastMenuHeader.recordInSettings()
    }
}
