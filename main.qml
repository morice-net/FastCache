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

    // State can take "near" "address" "coordinates" "recorded"....
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

    // current index in TabViewRecordedCaches
    property alias tabBarRecordedCachesIndex: fastList.tabBarRecordedCachesIndex

    // list sort type by: géocode, name , type , size , difficulty , terrain , distance.
    property int sortingBy : 6 // sorting by distance.

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
        onCachesChanged: {
            if(main.cachesActive)
                fastMap.mapItem.updateCachesOnMap(cachesBBox.caches)
        }
        onClearMapRequested: {
            fastMap.clearMap();
        }
    }

    CachesNear {
        id: cachesNear
        onCachesChanged: {
            if(main.state === "near" || main.state === "address" || main.state === "coordinates")
                fastMap.mapItem.updateCachesOnMap(cachesNear.caches)
        }
        onClearMapRequested: {
            fastMap.clearMap()
        }
    }

    CachesRecorded {
        id: cachesRecorded
        onCachesChanged: {
            if(main.state === "recorded")
                fastMap.mapItem.updateCachesOnMap(cachesRecorded.caches)
        }
        onClearMapRequested: {
            fastMap.clearMap()
        }
    }

    CachesRecordedLists {
        id: cachesRecordedLists
        x: main.width/6
        y: 10
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
                connector.oauthAuthorizeCode(url)
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
    }

    CacheAttributes {
        id: cacheAttributes
    }

    FullCache {
        id: fullCache
        onIsCorrectedCoordinatesChanged: {
            correctedCoordinatesDynamic(cachesBBox.caches);
            correctedCoordinatesDynamic(cachesNear.caches);
            correctedCoordinatesDynamic(cachesRecorded.caches);
        }
        onRegisteredChanged: {
            registeredDynamic(cachesBBox.caches)
            registeredDynamic(cachesNear.caches)
        }
        onFoundChanged: {
            foundDynamic(cachesBBox.caches);
            foundDynamic(cachesNear.caches);
            foundDynamic(cachesRecorded.caches);

        }
        onToDoLogChanged: {
            toDoLogDynamic(cachesBBox.caches)
            toDoLogDynamic(cachesNear.caches)
            toDoLogDynamic(cachesRecorded.caches)
        }
    }

    FullCacheRetriever {
        id: fullCacheRetriever
        Component.onCompleted: updateFullCache(fullCache)
    }

    FullCachesRecorded {
        id: fullCachesRecorded
        onStateChanged: {
            toast.visible = fullCachesRecorded.state !== "loading";
            if(fullCachesRecorded.state !== "OK")
                toast.show("Erreur  " + "(" + state + ")");
            if (fullCachesRecorded.state === "OK"){
                fastMap.markedCachesRegistered()
                toast.show("Les caches ont été enregistrées");
            }
        }
    }

    Travelbug {
        id: travelbug
        onStateChanged: {
            if(travelbug.state!== "loading" && travelbug.state!=="OK")
            {
                toast.visible;
                toast.show("Erreur  " + "(" + state + ")");
            }
        }
    }

    SendCacheNote {
        id:sendCacheNote
        onStateChanged: {
            toast.visible = sendCacheNote.state !== "loading";
            if(sendCacheNote.state !== "OK" && sendCacheNote.state !== "No Content")
                toast.show("Erreur  " + "(" + state + ")");
            if (sendCacheNote.state === "OK"){
                toast.show("La note personnelle a été correctement envoyée");
            }
            else {
                toast.show("La note personnelle a été supprimée ")
            }
        }
    }

    SendCacheLog {
        id:sendCacheLog
        onStateChanged: {
            toast.visible = sendCacheLog.state !== "loading";
            if (sendCacheLog.state !== "Created") {
                toast.show("Erreur  " + "(" + state + ")");
                fullCache.toDoLog = true
            } else {
                toast.show("Le log de la cache a été correctement envoyé ");
                fullCache.toDoLog = false

                // if it is a registered cache, mark found on list and map.
                if(fullCache.registered) {
                    var fav = sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "usedFavoritePoint")
                    sqliteStorage.updateFullCacheColumnsFoundJson("fullcache", fullCache.geocode, true, fullCachesRecorded.markFoundInJson(
                                                                      sqliteStorage.readObject("fullcache", fullCache.geocode), new Date().toISOString(), fav))
                    fullCache.found = true
                    fullCache.favorited = fav
                }

                // clears the cache log record
                sqliteStorage.deleteObject("cacheslog", fullCache.geocode)
                // Send list of travelbugs
                var   tbCode;
                var   trackingCode;
                var   logType;
                var dateIso;
                var   text;
                for (var i = 0; i < fastCache.listTbSend.length; i++) {
                    if(fastCache.listTbSend[i].split(',')[2] !== "0"){
                        tbCode = fastCache.listTbSend[i].split(',')[0]
                        trackingCode = fastCache.listTbSend[i].split(',')[1]
                        logType = fastCache.listTbSend[i].split(',')[2]
                        dateIso = fastCache.listTbSend[i].split(',')[3]
                        text = fastCache.listTbSend[i].substring(tbCode.length() + trackingCode.length() + logType.length() + dateIso.length() + 4);
                        sendTravelbugLog.sendRequest(connector.tokenKey , fullCache.geocode , tbCode , trackingCode , logType , dateIso , text);
                    }
                }
                // clears the tbsUser log record
                sqliteStorage.deleteObject("cachestbsuserlog", fullCache.geocode)
            }
        }
        onFoundsChanged: {
            findCount = sendCacheLog.founds;
            fastCache.swipeToPage(3);
        }
        onCodeLogChanged: {
            fastCache.addImagesToLog()
        }
    }

    SendImagesLog {
        id:sendImagesLog
    }

    SendTravelbugLog {
        id:sendTravelbugLog
        onRequestsLengthChanged: {
            if(fullCacheRetriever.requestsLength === 0)
                getTravelbugUser.sendRequest(connector.tokenKey);
        }
        onStateChanged: {
            toast.visible = sendTravelbugLog.state !== "loading";
            if (sendTravelbugLog.state !== "Created") {
                toast.show("Erreur  " + "(" + state + ")");
            } else {
                toast.show("Le log du travelbug a été correctement envoyé ");
                // clears the travelbug log record
                sqliteStorage.deleteObject("tblog", travelbug.tbCode)
            }
        }
    }

    SendUserWaypoint {
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

    GetTravelbugUser {
        id: getTravelbugUser
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

    SQLiteStorage {
        id: sqliteStorage
        Component.onCompleted: {
            // Build database
            sqliteStorage.createTable("fullcache", "(id string primary key, name string, type int, size int, difficulty double,
                                        terrain double, lat double, lon double, found bool, json string )");
            sqliteStorage.createTable("lists", "(id integer primary key default 1  , text string)");
            sqliteStorage.createTable("cacheslists", "(id integer primary key default 1 , list integer , code string , UNIQUE(list, code))");
            sqliteStorage.createTable("cacheslog", "(id string primary key, json string)");
            sqliteStorage.createTable("cachestbsuserlog", "(id string primary key, json string)");
            sqliteStorage.createTable("tblog", "(id string primary key, json string)");

            sqliteStorage.updateLists("lists", 1 , "Enregistrées");
            sqliteStorage.numberCachesInLists("cacheslists");
        }
    }

    Timer {
        id: refeshTokenTimer // every 5 min
        interval: 300000; running: true; repeat: true
        onTriggered:
        {
            if(connector.expiresAt <= Date.parse(new Date()) / 1000)
                connector.connect()
        }
    }

    Component.onCompleted: {
        main.viewState = "map"

        // retrieve settings
        connector.tokenKey = settings.tokenKey
        connector.refreshToken = settings.refreshToken
        connector.expiresAt = settings.expiresAt
        console.log("Token expiresAt: " + new Date(settings.expiresAt*1000))

        // token key is directly managed in the connect function that decides for long (with agree process)
        // or short procedure called refresh should be called
        connector.connect()
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
        connector.expiresAt = 0
        userInfo.name = ""
        userInfo.finds = 0
        userInfo.avatarUrl = ""
        userInfo.premium = ""
    }

    function reconnectAccount() {
        connector.expiresAt = 0
        connector.connect()
    }

    function reloadCaches(){
        if (!cachesActive){
            return;
        }
        if(cachesBBox.state !== "loading")
        {
            cachesBBox.latBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).latitude
            cachesBBox.lonBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).longitude
            cachesBBox.latTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).latitude
            cachesBBox.lonTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).longitude

            cachesBBox.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs() , createFilterExcludeCachesFound() ,
                                          createFilterExcludeCachesArchived() , createFilterKeywordDiscoverOwner() , userInfo.name )
            cachesBBox.sendRequest(connector.tokenKey)
        }
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

    //dynamic changes on list and  map
    function correctedCoordinatesDynamic(listCaches) {
        for (var i = 0; i < listCaches.length; i++) {
            if(listCaches[i].geocode === fullCache.geocode){
                if(fullCache.isCorrectedCoordinates){
                    listCaches[i].lat = fullCache.correctedLat;
                    listCaches[i].lon = fullCache.correctedLon;
                } else {
                    listCaches[i].lat = fullCache.lat;
                    listCaches[i].lon = fullCache.lon;
                }
                fastMap.mapItem.updateCacheOnMap(i);
                return;
            }
        }
    }

    function registeredDynamic(listCaches) {
        for (var i = 0; i < listCaches.length; i++) {
            if(listCaches[i].geocode === fullCache.geocode){
                listCaches[i].registered = fullCache.registered;
                fastMap.mapItem.updateCacheOnMap(i);
                return;
            }
        }
    }

    function foundDynamic(listCaches) {
        for (var i = 0; i < listCaches.length; i++) {
            if(listCaches[i].geocode === fullCache.geocode){
                listCaches[i].found = fullCache.found;
                fastMap.mapItem.updateCacheOnMap(i);
                return;
            }
        }
    }

    function toDoLogDynamic(listCaches) {
        for (var i = 0; i < listCaches.length; i++) {
            if(listCaches[i].geocode === fullCache.geocode){
                listCaches[i].toDoLog = fullCache.toDoLog;
                fastMap.mapItem.updateCacheOnMap(i);
                return;
            }
        }
    }

    // center and zoom level
    function centerMapCaches(listCaches) {
        fastMap.currentZoomlevel = 14.5
        if(listCaches.length === 0)
            return
        fastMap.mapItem.fitViewportToVisibleMapItems()
        fastMap.currentZoomlevel= fastMap.mapItem.zoomLevel
    }
}

