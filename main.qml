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
import "QML/JavaScript/MainFunctions.js" as Functions
import "QML"
import com.mycompany.connecting 1.0

Item {
    id: main
    anchors.fill: parent
    visible: true
    focus: true

    // Used for downloading a full cache by geocode
    property string previousGeocode: ""

    // main.state can take "near" "address" "coordinates" "recorded" "pocketQuery" "cachesActive" or ""
    property string annexMainState: ""

    property string viewState: "" // "map" or "list" or "fullcache" or"travelbug"
    onViewStateChanged: {
        if(main.viewState !== "list")
            fastMenuHeader.clearBoxSorting()
    }

    // Previous viewstate used when downloading a fullcache or a travel bug
    property var previousViewState: ["" , ""]

    property var listTypes : [settings.traditional , settings.mystery , settings.multi , settings.earth , settings.cito,
        settings.ape , settings.event , settings.giga , settings.letterbox , settings.mega , settings.virtual ,
        settings.webcam , settings.wherigo , settings.gchq]

    property var listSizes : [settings.micro , settings.small , settings.regular , settings.large , settings.notChosen,
        settings.virtualSize , settings.other]

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
    property int sortGeocode: 0
    property int sortName: 1
    property int sortType: 2
    property int sortSize: 3
    property int sortDifficulty: 4
    property int sortTerrain: 5
    property int sortDistance: 6

    property int sortingBy: sortDistance // sorting by distance.

    property int userLogImagesLoaded: - 1 // number of images of a user log downloaded

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
            // dynamically sort the list by distance if necessary
            fastList.sortByDistance()
        }
    }

    CachesSingleList {
        id:cachesSingleList
        onCachesChanged: {
            main.annexMainState = main.state
            if(main.state !== "")
                fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
        }
    }

    CachesBBox {
        id: cachesBBox
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement de la carte active");
            }
        }
        onClearMapRequested: {
            fastMap.clearMap();
        }
        Component.onCompleted:  listCachesObject(cachesSingleList)
    }

    CachesNear {
        id: cachesNear
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement des caches proches");
            }
        }
        onClearMapRequested: {
            fastMap.currentZoomlevel = 14
            fastMap.clearMap()
        }
        Component.onCompleted: listCachesObject(cachesSingleList)
    }

    CachesRecorded {
        id: cachesRecorded
        onClearMapRequested: {
            fastMap.clearMap()
        }
        Component.onCompleted: listCachesObject(cachesSingleList)
    }

    CachesPocketqueries {
        id: cachesPocketqueries
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement des pockets queries");
            }
        }
        onClearMapRequested: {
            fastMap.clearMap()
        }
        onStateChanged: {
            if(cachesPocketqueries.state !== "OK" && cachesPocketqueries.state !== "loading") {
                toast.visible = true
                toast.show("Erreur de chargement de la pocket " + "(" + state + ")");
            }
        }
        onParsingCompletedChanged: {
            // center and zoom level
            Functions.centerMapCaches(cachesSingleList.caches)
        }
        Component.onCompleted: listCachesObject(cachesSingleList)
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

    UserSettingsPopup { id: userSettingsPopup }

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
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement des informations de l'utilisateur");
            }
        }
    }

    CacheAttributes {
        id: cacheAttributes
    }

    FullCache {
        id: fullCache
        onIsCorrectedCoordinatesChanged: Functions.correctedCoordinatesDynamic(cachesSingleList.caches)
        onRegisteredChanged: Functions.registeredDynamic(cachesSingleList.caches)
        onFoundChanged: {
            Functions.foundDynamic(cachesSingleList.caches)

            fastCache.updateLog = false
            getUserGeocacheLogs.sendRequest(connector.tokenKey , fullCache.geocode)
            fastCache.swipeLogPage.typeLog = fastCache.swipeLogPage.initTypeLog()
        }
        onToDoLogChanged: Functions.toDoLogDynamic(cachesSingleList.caches)
    }

    FullCacheRetriever {
        id: fullCacheRetriever
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement de la cache");
            }
        }
        onStateChanged: {
            if(fullCacheRetriever.state === "loading")
                previousViewState[0] = viewState
            if(fullCacheRetriever.state !== "loading" && fullCacheRetriever.state === "OK")
                viewState = "fullcache"
            if(fullCacheRetriever.state !== "loading" && fullCacheRetriever.state !== "OK") {
                toast.visible = true;
                toast.show("Erreur de téléchargement  " + "(" + state + ")");
                if(viewState === "fullcache")
                    fullCache.geocode = previousGeocode
            }
        }
        Component.onCompleted: updateFullCache(fullCache)
    }

    FullCachesRecorded {
        id: fullCachesRecorded
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour l'enregistrement des caches");
            }
        }
        onStateChanged: {
            // User name in fullcachesrecorded
            fullCachesRecorded.userName = userInfo.name
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
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement du travel bug");
            }
        }
        onStateChanged: {
            if(travelbug.state === "loading")
                previousViewState[1] = viewState
            if(travelbug.state !== "loading" && travelbug.state === "OK")
                viewState = "travelbug"
            if(travelbug.state !== "loading" && travelbug.state !== "OK")
            {
                toast.visible = true;
                toast.show("Erreur de téléchargement   " + "(" + state + ")");
            }
        }
    }

    SendCacheNote {
        id:sendCacheNote
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour l'envoi de la note");
            }
        }
        onStateChanged: {
            toast.visible = sendCacheNote.state !== "loading";
            if(sendCacheNote.state !== "OK" && sendCacheNote.state !== "No Content")
                toast.show("Erreur d'envoi de la note " + "(" + state + ")");
            if (sendCacheNote.state === "OK"){
                toast.show("La note personnelle a été correctement envoyée");
            } else {
                toast.show("La note personnelle a été supprimée ")
            }
        }
    }

    DeleteLogImage {
        id: deleteLogImage
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour la suppression de l'image");
            }
        }
        onStateChanged: {
            toast.visible = deleteLogImage.state !== "loading";
            if(deleteLogImage.state !== "No Content")
                toast.show("Erreur de supression de l'image  " + "(" + state + ")");
            else {
                toast.show("L'image a été supprimée");
                getGeocacheLogImages.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[fastCache.updateLogIndex])
                getUserGeocacheLogs.imagesCount[fastCache.updateLogIndex] = getUserGeocacheLogs.imagesCount[fastCache.updateLogIndex] -1
            }
        }
    }

    SendEditUserLog {
        id: sendEditUserLog
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour la modification ou suppression du log");
            }
        }
        onStateChanged: {
            toast.visible = sendEditUserLog.state !== "loading";
            if(sendEditUserLog.state !== "OK" && sendEditUserLog.state !== "No Content")
                toast.show("Erreur de modification du log  " + "(" + state + ")");
            if(sendEditUserLog.state === "OK") {
                toast.show("Le log de la cache a été correctement modifié");
                if(fastCache.listImagesUrl.length !== 0)
                    userLogImagesLoaded = 0
            }
            if(sendEditUserLog.state === "No Content") {
                toast.show("Le log de la cache a été supprimé");
                getUserGeocacheLogs.sendRequest(connector.tokenKey , fullCache.geocode)
                if(fullCache.found) {
                    fullCache.found = false
                    // update manually because groundspeak does not give the number of caches fast enough
                    findCount = findCount -1
                }
            }
        }
        onParsingCompletedChanged: {
            if(sendEditUserLog.logTypeResponse !== 2 && sendEditUserLog.parsingCompleted === true) {
                if(fullCache.found) {
                    fullCache.found = false
                    // update manually because groundspeak does not give the number of caches fast enough
                    findCount = findCount - 1
                }
            } else if(sendEditUserLog.logTypeResponse === 2 && sendEditUserLog.parsingCompleted === true){
                if(!fullCache.found) {
                    fullCache.found = true
                    // update manually because groundspeak does not give the number of caches fast enough
                    findCount = findCount + 1
                }
            }
            // if it is a registered cache and logType=2(found), mark found on list and map.
            if(fullCache.registered && sendEditUserLog.logTypeResponse === 2 && sendEditUserLog.parsingCompleted === true) {
                var fav = sendEditUserLog.favorited
                sqliteStorage.updateFullCacheColumnsFoundJson("fullcache", fullCache.geocode, true, fullCachesRecorded.markFoundInJson(
                                                                  sqliteStorage.readObject("fullcache", fullCache.geocode), new Date().toISOString(), fav))
                fullCache.favorited = fav
            }
        }
        onCodeLogChanged: {
            fastCache.addImagesToLog()
        }
    }

    SendCacheLog {
        id:sendCacheLog
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour l'envoi du log");
            }
        }
        onStateChanged: {
            toast.visible = sendCacheLog.state !== "loading";
            if (sendCacheLog.state !== "Created") {
                toast.show("Erreur d'envoi du log  " + "(" + state + ")");
            } else {
                toast.show("Le log de la cache a été correctement envoyé ");
                if(fastCache.listImagesUrl.length !== 0)
                    userLogImagesLoaded = 0
                fullCache.toDoLog = false

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
        onParsingCompletedChanged: {
            if(sendCacheLog.logTypeResponse !== 2 && sendCacheLog.parsingCompleted === true) {
                fullCache.found = false
            } else if(sendCacheLog.logTypeResponse === 2 && sendCacheLog.parsingCompleted === true){
                fullCache.found = true
            }
            // if it is a registered cache and logType=2(found), mark found on list and map.
            if(fullCache.registered && sendCacheLog.logTypeResponse === 2 && sendCacheLog.parsingCompleted === true) {
                var fav = sendCacheLog.favorited
                sqliteStorage.updateFullCacheColumnsFoundJson("fullcache", fullCache.geocode, true, fullCachesRecorded.markFoundInJson(
                                                                  sqliteStorage.readObject("fullcache", fullCache.geocode), new Date().toISOString(), fav))
                fullCache.favorited = fav
            }
        }
        onFoundsChanged: {
            findCount = sendCacheLog.founds;
            fastCache.swipeToPage(fastCache.detailsPageIndex);
        }
        onCodeLogChanged: {
            fastCache.addImagesToLog()
        }
    }

    SendImagesLog {
        id: sendImagesLog
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour l'envoi des images du log");
            }
        }
        onStateChanged: {
            if (sendImagesLog.state !== "loading" && sendImagesLog.state !== "Created") {
                userLogImagesLoaded  = userLogImagesLoaded  + 1
                if(userLogImagesLoaded === fastCache.listImagesUrl.length)
                    userLogImagesLoaded = -1
                toast.visible = true
                toast.show("Erreur d'envoi de l'image  " + "(" + state + ")");
            } else if (sendImagesLog.state !== "loading" && sendImagesLog.state === "Created") {
                userLogImagesLoaded  = userLogImagesLoaded  + 1
                if(userLogImagesLoaded === fastCache.listImagesUrl.length)
                    userLogImagesLoaded = -1
                toast.visible = true
                toast.show("L'image a été rajoutée au log.");

                // clears the images log record
                sqliteStorage.deleteObject("cachesimageslog", fullCache.geocode)

                // Increments imagesCount when adding an image to a user log
                if(fastCache.updateLog === true)
                    getUserGeocacheLogs.imagesCount[fastCache.updateLogIndex] = getUserGeocacheLogs.imagesCount[fastCache.updateLogIndex] + 1
            }
        }
    }

    SendTravelbugLog {
        id:sendTravelbugLog
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour l'envoi du log du travelbug");
            }
        }
        onRequestsLengthChanged: {
            if(fullCacheRetriever.requestsLength === 0)
                getTravelbugUser.sendRequest(connector.tokenKey);
        }
        onStateChanged: {
            toast.visible = sendTravelbugLog.state !== "loading";
            if (sendTravelbugLog.state !== "Created") {
                toast.show("Erreur d'envoi du travelbug  " + "(" + state + ")");
            } else {
                toast.show("Le log du travelbug a été correctement envoyé ");
                // clears the travelbug log record
                sqliteStorage.deleteObject("tblog", travelbug.tbCode)
            }
        }
    }

    SendUserWaypoint {
        id: sendUserWaypoint
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour l'envoi des étapes personnelles");
            }
        }
        onStateChanged: {
            toast.visible = sendUserWaypoint.state !== "loading";
            if (sendUserWaypoint.state !== "Created" && sendUserWaypoint.state !== "No Content" && sendUserWaypoint.state !== "OK") {
                toast.show("Erreur  " + "(" + state + ")");
            } else if (sendUserWaypoint.state === "Created"){
                toast.show("L'étape personnelle a été crée ");
            } else if (sendUserWaypoint.state === "No Content" && fastCache.deleteUserWpt === true){
                fullCache.removeUserWpt(fastCache.userWptIndex);
                toast.show("L'étape personnelle a été supprimée");
            } else if (sendUserWaypoint.state === "No Content" && fastCache.deleteUserWpt === false){
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
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement des travel bugs de l'utilisateur ");
            }
        }
    }

    GetPocketsqueriesList {
        id: getPocketsqueriesList
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement de la liste des pockets queries");
            }
        }
        onStateChanged: {
            if(getPocketsqueriesList.state !== "OK" && getPocketsqueriesList.state !== "loading") {
                toast.visible = true
                toast.show("Erreur de chargement de la pocket " + "(" + state + ")");
            }
        }
    }

    GetUserGeocacheLogs {
        id: getUserGeocacheLogs
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement des logs de l'utilisateur");
            }
        }
    }

    GetGeocacheLogImages {
        id: getGeocacheLogImages
        onTimeOutRequestChanged: {
            if(timeOutRequest) {
                toast.visible = true;
                toast.show("Délai de connexion dépassé pour le chargement des images du log");
            }
        }
        onStateChanged: {
            if(getGeocacheLogImages.state !== "OK" && getGeocacheLogImages.state !== "loading") {
                toast.visible = true
                toast.show("Erreur de chargement des images " + "(" + state + ")");
            }
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

    SQLiteStorage {
        id: sqliteStorage
        Component.onCompleted: {
            // Build database
            sqliteStorage.createTable("fullcache", "(id string primary key, name string, type int, size int, difficulty double,
                                        terrain double, lat double, lon double, found bool, own bool, json string )");
            sqliteStorage.createTable("lists", "(id integer primary key default 1  , text string)");
            sqliteStorage.createTable("cacheslists", "(id integer primary key default 1 , list integer , code string , UNIQUE(list, code))");
            sqliteStorage.createTable("cacheslog", "(id string primary key, json string)");
            sqliteStorage.createTable("cachestbsuserlog", "(id string primary key, json string)");
            sqliteStorage.createTable("tblog", "(id string primary key, json string)");
            sqliteStorage.createTable("cachesimageslog", "(id string primary key, json string)");

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
        main.state = ""
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
        Functions.recordAppSettings()
    }

    Keys.onPressed: {
        event.accepted = true
        if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
            if (webEngine.visible) {
                webEngine.visible = false
            } else if (coordinatesBox.opened) {
                coordinatesBox.close()
            } else if (geocode.opened) {
                geocode.close()
            } else if (fastMenu.isMenuVisible()) {
                fastMenu.hideMenu()
            } else if (fastMenuHeader.isFiltersVisible()) {
                fastMenuHeader.changeFiltersVisibility()
            } else if (main.viewState == "fullcache") {
                main.viewState = previousViewState[0]
            } else if (main.viewState == "travelbug") {
                main.viewState = previousViewState[1]
            } else {
                sureQuit.visible = true
            }
        }
    }
}

