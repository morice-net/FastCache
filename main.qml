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

    UserInfoPopup { id: userInfoPopup }

    GeocodeAlert { id: geocodeAlert }

    CoordinatesBox { id: coordinatesBox }

    UserWaypoint { id: userWaypoint }

    // Used for loggin
    WebView {
        id: webEngine
        url: ""
        anchors.fill: parent
        visible: false

        onUrlChanged: {
            console.log("[URL] The load request URL is: " + url);
            console.log("[URL] redirectUri: ", connector.redirectUri)
            if (tools.beginsWith(url, connector.redirectUri + "?")) {
                connector.oauthRefreshToken(url)
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
        onLoginProcedureDone: userInfo.sendRequest(connector.tokenKey, getTravelbugUser)
        onExpiresAtChanged: settings.expiresAt = expiresAt
    }

    UserInfo {
        id: userInfo
        onRequestReady:{
            cachesBBox.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs() , createFilterExcludeCachesFound() ,
                                          createFilterExcludeCachesArchived() , createFilterKeywordDiscoverOwner() , userInfo.name )
            reloadCaches()
        }
    }

    CacheAttributes {
        id: cacheAttributes
    }

    FullCache {
        id: fullCache
    }

    FullCacheRetriever{
        id: fullCacheRetriever
        Component.onCompleted: updateFullCache(fullCache)
    }

    Travelbug{
        id: travelbug
        onStateChanged: {
            if(travelbug.state!== "loading" && travelbug.state!=="OK")
            {
                toast.visible;
                toast.show("Erreur  " + "(" + state + ")");
            }
        }
    }

    SendCacheNote{
        id:sendCacheNote
        onStateChanged: {
            toast.visible = sendCacheNote.state !== "loading";
            if(sendCacheNote.state !== "OK" && sendCacheNote.state !== "No Content")
                toast.show("Erreur  " + "(" + state + ")");
            if (sendCacheNote.state === "OK")
                toast.show("La note personnelle a été correctement envoyée");
            else {
                toast.show("La note personnelle a été supprimée ")
            }
        }
    }

    SendCacheLog{
        id:sendCacheLog
        onStateChanged: {
            toast.visible = sendCacheLog.state !== "loading";
            if (sendCacheLog.state !== "Created") {
                toast.show("Erreur  " + "(" + state + ")");
            } else {
                toast.show("Le log de la cache a été correctement envoyé ");
            }
        }
        onFoundsChanged: {
            findCount = sendCacheLog.founds;
            fastCache.swipeToPage(3);
        }
    }

    SendTravelbugLog{
        id:sendTravelbugLog
        onStateChanged: {
            toast.visible = sendTravelbugLog.state !== "loading";
            if (sendTravelbugLog.state !== "Created") {
                toast.show("Erreur  " + "(" + state + ")");
            } else {
                toast.show("Le log du travelbug a été correctement envoyé ");
            }
        }
    }

    SendUserWaypoint{
        id: sendUserWaypoint
        onStateChanged: {
            toast.visible = sendUserWaypoint.state !== "loading";
            if (sendUserWaypoint.state !== "Created" && sendUserWaypoint.state !== "No Content" && sendUserWaypoint.state !== "OK") {
                toast.show("Erreur  " + "(" + state + ")");
            } else if (sendUserWaypoint.state === "Created"){
                toast.show("L'étape personnelle a été crée ");
            } else if (sendUserWaypoint.state === "No Content" && fastCache.deleteUserWpt === true){
                fullCache.removeUserWpt(fastCache.userWptIndex);
                toast.show("L'étape personnelle a été supprimée");
            }
            else if (sendUserWaypoint.state === "No Content" && fastCache.deleteUserWpt === false){
                fullCache.removeCorrectedcoordinates();
                toast.show("L'étape personnelle a été supprimée");
            } else if (sendUserWaypoint.state === "OK"){
                toast.show("L'étape personnelle a été modifiée");
            }
        }
        Component.onCompleted: updateFullCache(fullCache)
    }

    GetTravelbugUser{
        id:getTravelbugUser
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

    SQLiteStorage {
        id: sqliteStorage
    }

    Timer {
        id: refeshTokenTimer // every 15 min
        interval: 90000; running: true; repeat: true
        onTriggered: connector.connect()
    }

    Component.onCompleted: {
        main.viewState = "map"
        fastMap.mapItem.updateCachesOnMap(cachesBBox)

        // retrieve settings (todo: remove and put alias in settings instead)
        connector.tokenKey = settings.tokenKey
        connector.refreshToken = settings.refreshToken
        connector.expiresAt = settings.expiresAt
        console.log("Settings expiresAt: " + settings.expiresAt + " - Connector expiresAt: " + connector.expiresAt)

        // token key not set means connection to GC needed
        if (connector.tokenKey != "") {
            console.log("FastSettings: tokenKey=" + connector.tokenKey)
            userInfo.sendRequest(connector.tokenKey, getTravelbugUser)
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

        cachesBBox.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs() , createFilterExcludeCachesFound() ,
                                      createFilterExcludeCachesArchived() , createFilterKeywordDiscoverOwner() , userInfo.name )
        cachesBBox.sendRequest(connector.tokenKey)
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

    function recordAppSettings() {
        settings.tokenKey = connector.tokenKey
        settings.refreshToken = connector.refreshToken
        fastMenuHeader.recordInSettings()
    }

}
