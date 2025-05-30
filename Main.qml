import QtQuick
import QtQuick.Window
import QtPositioning
import QtWebView
import QtSensors
import FastCache

import "QML/JavaScript/MainFunctions.js" as Functions
import "QML"

Window {
    id: main
    height: 800
    width: 510
    visible: true

    // Used for downloading a full cache by geocode
    property string previousGeocode: ""
    property string annexMainState: ""

    property string listState: ""  // "near" or "address" or "coordinates" or "recorded" or "pocketQuery" or "cachesActive" or ""
    property string viewState: "" // "map" or "list" or "fullcache" or "travelbug"
    onViewStateChanged: {
        if(main.viewState !== "list")
            fastMenuHeader.clearBoxSorting()
    }

    // Previous viewstate used when downloading a fullcache or a travel bug
    property list <string> previousViewState: ["" , ""]
    property list <bool> listTypes : [settings.traditional , settings.mystery , settings.multi , settings.earth , settings.cito,
        settings.ape , settings.event , settings.giga , settings.letterbox , settings.mega , settings.virtual ,
        settings.webcam , settings.wherigo , settings.gchq]
    property list <bool> listSizes : [settings.micro , settings.small , settings.regular , settings.large , settings.notChosen,
        settings.virtualSize , settings.other]
    property list <string> listKeywordDiscoverOwner : [settings.keyWord , settings.discover , settings.owner]
    property bool excludeFound : settings.excludeCachesFound
    property bool excludeArchived: settings.excludeCachesArchived

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
    property bool externalSource: false  // gps bluetooth
    property double externalLatitude: 0.0
    property double externalLongitude: 0.0
    property var locationSource: externalSource ? externalLocation.coordinate : currentPosition.position.coordinate
    property int azimutDevice: 0  // used by magnetic compass

    Item {
        id: mainItem
        focus: true
        anchors.fill: parent

        FastSettings { id: settings }

        Location {
            id: externalLocation
            coordinate {
                latitude: externalLatitude
                longitude: externalLongitude
            }
            onCoordinateChanged: {
                main.positionUpdated()
                fastList.sortByDistance() // dynamically sort the list by distance if necessary
                if(!fastMap.mapNorth)  // map not oriented to north
                    fastMap.mapItem.bearing = externalLocation.coordinate.azimuthTo(QtPositioning.coordinate(fastCache.goalLat , fastCache.goalLon))
            }
        }

        PositionSource {
            id: currentPosition
            updateInterval: 1000
            active: true
            onPositionChanged: {
                main.positionUpdated()
                fastList.sortByDistance() // dynamically sort the list by distance if necessary
                if(!fastMap.mapNorth)  // map not oriented to north
                    fastMap.mapItem.bearing = currentPosition.position.coordinate.azimuthTo(QtPositioning.coordinate(fastCache.goalLat , fastCache.goalLon))
            }
        }

        CachesSingleList {
            id: cachesSingleList
            onCachesChanged: {
                main.annexMainState = main.listState
                if(main.listState !== "")
                    fastMap.mapItem.updateCachesOnMap(cachesSingleList.caches)
            }
        }

        CachesBBox {
            id: cachesBBox
            onStateChanged: {
                if(cachesBBox.state !== "OK" && cachesBBox.state !== "loading") {
                    toast.visible = true
                    if(cachesBBox.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement de la carte active");
                    } else {
                        toast.show("Erreur de chargement de la carte active " + "(" + state + ")")
                    }
                }
            }
            Component.onCompleted: listCachesObject(cachesSingleList)
        }

        AdventureLabCachesRetriever{
            id: adventureLabCachesRetriever
            onStateChanged: {
                if(adventureLabCachesRetriever.state !== "OK" && adventureLabCachesRetriever.state !== "loading") {
                    toast.visible = true
                    if(adventureLabCachesRetriever.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des adventurelab caches");
                    } else {
                        toast.show("Erreur de chargement des adventurelab caches " + "(" + state + ")")
                    }
                }
            }
            onClearMapRequested: {
                fastMap.clearMap();
            }
            Component.onCompleted: listCachesObject(cachesSingleList)
        }

        CachesNear {
            id: cachesNear
            onStateChanged: {
                if(cachesNear.state !== "OK" && cachesNear.state !== "loading") {
                    toast.visible = true
                    if(cachesNear.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des caches proches");
                    } else {
                        toast.show("Erreur de chargement des caches proches " + "(" + state + ")")
                    }
                }
            }
            onClearMapRequested: {
                fastMap.currentZoomlevel = 13
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
            onClearMapRequested: {
                fastMap.clearMap()
            }
            onStateChanged: {
                if(cachesPocketqueries.state !== "OK" && cachesPocketqueries.state !== "loading") {
                    toast.visible = true
                    if(cachesPocketqueries.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des pocket queries");
                    } else {
                        toast.show("Erreur de chargement des pocket queries " + "(" + state + ")")
                    }
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
            x: (main.width - width) / 2
            y: 10
        }

        FastMap { id: fastMap }

        FastList { id: fastList }

        FastCache { id: fastCache }

        FastTravelbug { id: fastTravelbug }

        FastMenuHeader { id: fastMenuHeader }

        FastMenu { id: fastMenu }

        Geocode { id: geocode }

        UserSettings { id: userSettings }

        SatelliteInfo { id: satelliteInfo }

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
                if(url.toString().indexOf(connector.redirectUri + "?") === 0) {
                    connector.oauthAuthorizeCode(url)
                    webEngine.visible = false
                }
            }
        }

        OwnerProfile {
            id: ownerProfile
            leftPadding: 0
        }

        SureQuit {
            id: sureQuit
        }

        FontLoader { id: localFont; source: "Ressources/DellaRespira-Regular.ttf" }

        Connector {
            id: connector
            onLogOn: (url) => {
                         console.log("\n\n***\nDownloading... " + url);
                         webEngine.url = url;
                         webEngine.visible = true;
                     }
            onLoginProcedureDone: userInfo.sendRequest(connector.tokenKey, getTravelbugUser)
            onExpiresAtChanged: settings.expiresAt = expiresAt
        }

        UserInfo {
            id: userInfo
            onStateChanged: {
                if(userInfo.state !== "OK" && userInfo.state !== "loading") {
                    toast.visible = true
                    if(userInfo.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des informations de l'utilisateur");
                    } else {
                        toast.show("Erreur de chargement des informations de l'utilisateur " + "(" + state + ")")
                    }
                }
            }
        }

        FullCache {
            id: fullCache
            onIsCorrectedCoordinatesChanged: Functions.correctedCoordinatesDynamic()
            onRegisteredChanged: Functions.registeredDynamic()
            onFoundChanged: {
                Functions.foundDynamic()
                fastCache.updateLog = false
                if(listState !== "recorded" || !registered)  {
                    getUserGeocacheLogs.sendRequest(connector.tokenKey , fullCache.geocode)
                } else {
                    getUserGeocacheLogs.parseJson(sqliteStorage.readColumnUserlogs("fullcache" , fullCache.geocode ))
                }
                fastCache.swipeLogPage.typeLog = fastCache.swipeLogPage.initTypeLog()
            }
            onToDoLogChanged: Functions.toDoLogDynamic()
        }

        FullCacheRetriever {
            id: fullCacheRetriever
            onStateChanged: {
                if(fullCacheRetriever.state === "loading")
                    previousViewState[0] = viewState
                if(fullCacheRetriever.state !== "loading" && fullCacheRetriever.state === "OK")
                    viewState = "fullcache"
                if(fullCacheRetriever.state !== "loading" && fullCacheRetriever.state !== "OK") {
                    toast.visible = true;
                    if(fullCacheRetriever.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement de la cache");
                    } else {
                        toast.show("Erreur de chargement de la cache " + "(" + state + ")")
                    }
                    if(viewState === "fullcache")
                        fullCache.geocode = previousGeocode
                }
            }
            Component.onCompleted: {
                fullCacheRetriever.updateFullCache(fullCache)
                fullCacheRetriever.updateReplaceImageInText(replaceImageInText)
                fullCacheRetriever.updateGetUserGeocacheLogs(getUserGeocacheLogs)
            }
        }

        FullLabCacheRetriever {
            id: fullLabCacheRetriever
            onStateChanged: {
                if(fullLabCacheRetriever.state === "loading")
                    previousViewState[0] = viewState
                if(fullLabCacheRetriever.state !== "loading" && fullLabCacheRetriever.state === "OK")
                    viewState = "fullcache"
                if(fullLabCacheRetriever.state !== "loading" && fullLabCacheRetriever.state !== "OK") {
                    toast.visible = true;
                    if(fullLabCacheRetriever.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement de la lab cache");
                    } else {
                        toast.show("Erreur de chargement de la lab cache " + "(" + state + ")")
                    }
                    if(viewState === "fullcache")
                        fullCache.geocode = previousGeocode
                }
            }
            Component.onCompleted: {
                fullLabCacheRetriever.updateFullCache(fullCache)
                listCachesObject(cachesSingleList)
                fullLabCacheRetriever.updateReplaceImageInText(replaceImageInText)
            }
        }

        FullCachesRecorded {
            id: fullCachesRecorded
            onStateChanged: {
                // User name in fullcachesrecorded
                fullCachesRecorded.userName = userInfo.name
                toast.visible = fullCachesRecorded.state !== "loading";
                if(fullCachesRecorded.state !== "OK") {
                    if(fullCachesRecorded.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'enregistrement des caches");
                    } else {
                        toast.show("Erreur de chargement des caches " + "(" + state + ")")
                    }
                }
                if (fullCachesRecorded.state === "OK"){
                    fastMap.markedCachesRegistered()
                    toast.show("Les caches ont été enregistrées");
                }
            }
            Component.onCompleted: fullCachesRecorded.updateReplaceImageInText(replaceImageInText)
        }

        FullLabCachesRecorded {
            id: fullLabCachesRecorded
            onStateChanged: {
                toast.visible = fullLabCachesRecorded.state !== "loading";
                if(fullLabCachesRecorded.state !== "OK") {
                    if(fullLabCachesRecorded.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'enregistrement des lab caches");
                    } else {
                        toast.show("Erreur de chargement des lab caches " + "(" + state + ")")
                    }
                }
                if (fullLabCachesRecorded.state === "OK"){
                    fastMap.markedCachesRegistered()
                    toast.show("Les lab caches ont été enregistrées");
                }
            }
            Component.onCompleted: fullLabCachesRecorded.updateReplaceImageInText(replaceImageInText)
        }

        Travelbug {
            id: travelbug
            onStateChanged: {
                if(travelbug.state === "loading")
                    previousViewState[1] = viewState
                if(travelbug.state !== "loading" && travelbug.state === "OK")
                    viewState = "travelbug"
                if(travelbug.state !== "loading" && travelbug.state !== "OK")
                {
                    toast.visible = true;
                    if(travelbug.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement du travel bug");
                    } else {
                        toast.show("Erreur de chargement du travel bug " + "(" + state + ")")
                    }
                }
            }
        }

        SendCacheNote {
            id:sendCacheNote
            onStateChanged: {
                toast.visible = sendCacheNote.state !== "loading";
                if(sendCacheNote.state !== "OK" && sendCacheNote.state !== "No Content") {
                    if(sendCacheNote.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'envoi de la note");
                    } else {
                        toast.show("Erreur d'envoi de la note " + "(" + state + ")")
                    }
                }
                if (sendCacheNote.state === "OK"){
                    toast.show("La note personnelle a été correctement envoyée");
                } else {
                    toast.show("La note personnelle a été supprimée ")
                }
            }
        }

        DeleteLogImage {
            id: deleteLogImage
            onStateChanged: {
                toast.visible = deleteLogImage.state !== "loading";
                if(deleteLogImage.state !== "No Content") {
                    if(deleteLogImage.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour la suppression de l'image");
                    } else {
                        toast.show("Erreur de supression de l'image  " + "(" + state + ")")
                    }
                }
                else {
                    toast.show("L'image a été supprimée");
                    getGeocacheLogImages.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[fastCache.updateLogIndex])
                    getUserGeocacheLogs.imagesCount[fastCache.updateLogIndex] = getUserGeocacheLogs.imagesCount[fastCache.updateLogIndex] -1
                }
            }
        }

        SendEditUserLog {
            id: sendEditUserLog
            onStateChanged: {
                toast.visible = sendEditUserLog.state !== "loading";
                if(sendEditUserLog.state !== "OK" && sendEditUserLog.state !== "No Content") {
                    if(sendEditUserLog.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour la modification ou suppression du log");
                    } else {
                        toast.show("Erreur de modification du log  " + "(" + state + ")")
                    }
                }
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
                if(sendEditUserLog.logTypeResponse !== 2 && sendEditUserLog.parsingCompleted) {
                    if(fullCache.found) {
                        fullCache.found = false
                        // update manually because groundspeak does not give the number of caches fast enough
                        findCount = findCount - 1
                    }
                } else if(sendEditUserLog.logTypeResponse === 2 && sendEditUserLog.parsingCompleted){
                    if(!fullCache.found) {
                        fullCache.found = true
                        // update manually because groundspeak does not give the number of caches fast enough
                        findCount = findCount + 1
                    }
                }
                // if it is a registered cache and logType=2(found), mark found on list and map.
                if(fullCache.registered && sendEditUserLog.logTypeResponse === 2 && sendEditUserLog.parsingCompleted) {
                    var fav = sendEditUserLog.favorited
                    sqliteStorage.updateFullCacheColumnsFoundJson("fullcache", fullCache.geocode, true, fullCachesRecorded.markFoundInJson(
                                                                      sqliteStorage.readColumnJson("fullcache", fullCache.geocode), new Date().toISOString(), fav))
                    fullCache.favorited = fav
                }
            }
            onCodeLogChanged: {
                fastCache.addImagesToLog()
            }
        }

        SendCacheLog {
            id:sendCacheLog
            onStateChanged: {
                toast.visible = sendCacheLog.state !== "loading";
                if (sendCacheLog.state !== "Created") {
                    if(sendCacheLog.state === "Unprocessable Entity" )
                        fullCache.toDoLog = false
                    if(sendCacheLog.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'envoi du log")
                    } else {
                        toast.show("Erreur d'envoi du log  " + "(" + state + ")")
                    }
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
                fastCache.swipeToPage(fastCache.detailsPageIndex);

                if(sendCacheLog.logTypeResponse !== 2 && sendCacheLog.parsingCompleted) {
                    fullCache.found = false
                } else if(sendCacheLog.logTypeResponse === 2 && sendCacheLog.parsingCompleted){
                    fullCache.found = true
                    findCount = findCount + 1
                }
                // if it is a registered cache and logType=2(found), mark found on list and map.
                if(fullCache.registered && sendCacheLog.logTypeResponse === 2 && sendCacheLog.parsingCompleted) {
                    var fav = sendCacheLog.favorited
                    sqliteStorage.updateFullCacheColumnsFoundJson("fullcache", fullCache.geocode, true, fullCachesRecorded.markFoundInJson(
                                                                      sqliteStorage.readColumnJson("fullcache", fullCache.geocode), new Date().toISOString(), fav))
                    fullCache.favorited = fav
                }
            }
            onCodeLogChanged: {
                fastCache.addImagesToLog()
            }
        }

        SendImagesLog {
            id: sendImagesLog
            onStateChanged: {
                if (sendImagesLog.state !== "loading" && sendImagesLog.state !== "Created") {
                    userLogImagesLoaded  = userLogImagesLoaded  + 1
                    if(userLogImagesLoaded === fastCache.listImagesUrl.length)
                        userLogImagesLoaded = -1
                    toast.visible = true
                    if(sendImagesLog.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'envoi de l'image du log")
                    } else {
                        toast.show("Erreur d'envoi de l'image  " + "(" + state + ")")
                    }
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
            onRequestsLengthChanged: {
                if(fullCacheRetriever.requestsLength === 0)
                    getTravelbugUser.sendRequest(connector.tokenKey);
            }
            onStateChanged: {
                toast.visible = sendTravelbugLog.state !== "loading";
                if (sendTravelbugLog.state !== "Created") {
                    if(sendTravelbugLog.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'envoi du log du travelbug")
                    } else {
                        toast.show("Erreur d'envoi du travelbug  " + "(" + state + ")")
                    }
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
                    if(sendUserWaypoint.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour l'envoi des étapes personnelles")
                    } else {
                        toast.show("Erreur d'envoi des étapes personnelles  " + "(" + state + ")")
                    }
                } else if (sendUserWaypoint.state === "Created"){
                    toast.show("L'étape personnelle a été créee ");
                } else if (sendUserWaypoint.state === "No Content" && fastCache.deleteUserWpt === true){
                    fullCache.removeUserWpt(fastCache.userWptIndex);
                    toast.show("L'étape personnelle a été supprimée");
                    fastCache.compassPageInit("Cache: " + fullCache.geocode , fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat
                                              , fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon)
                } else if (sendUserWaypoint.state === "No Content" && fastCache.deleteUserWpt === false){
                    fullCache.removeCorrectedcoordinates();
                    toast.show("La correction de coordonnées a été supprimée");
                } else if (sendUserWaypoint.state === "OK"){
                    toast.show("L'étape personnelle a été modifiée");
                }
            }
            Component.onCompleted: updateFullCache(fullCache)
        }

        GetTravelbugUser {
            id: getTravelbugUser
            onStateChanged: {
                if(getTravelbugUser.state !== "OK" && getTravelbugUser.state !== "loading") {
                    toast.visible = true
                    if(getTravelbugUser.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des travel bugs de l'utilisateur")
                    } else {
                        toast.show("Erreur d'envoi des travel bugs de l'utilisateur  " + "(" + state + ")")
                    }
                }
            }
        }

        GetPocketsqueriesList {
            id: getPocketsqueriesList
            onStateChanged: {
                if(getPocketsqueriesList.state !== "OK" && getPocketsqueriesList.state !== "loading") {
                    toast.visible = true
                    if(getPocketsqueriesList.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement de la liste des pockets queries")
                    } else {
                        toast.show("Erreur de chargement de la liste des pockets queries "  + "(" + state + ")")
                    }
                }
            }
        }

        GetUserGeocacheLogs {
            id: getUserGeocacheLogs
            onStateChanged: {
                if(getUserGeocacheLogs.state !== "OK" && getUserGeocacheLogs.state !== "loading") {
                    toast.visible = true
                    if(getUserGeocacheLogs.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des logs de l'utilisateur")
                    } else {
                        toast.show("Erreur de chargement des logs de l'utilisateur "  + "(" + state + ")")
                    }
                }
            }
        }

        GetGeocacheLogImages {
            id: getGeocacheLogImages
            onStateChanged: {
                if(getGeocacheLogImages.state !== "OK" && getGeocacheLogImages.state !== "loading") {
                    toast.visible = true
                    if(getGeocacheLogImages.state === "timeOutConnection") {
                        toast.show("Délai de connexion dépassé pour le chargement des images du log")
                    } else {
                        toast.show("Erreur de chargement des images "   + "(" + state + ")")
                    }
                }
            }
        }

        Compass { // the compass sensor object
            id: compass
            active: true // turn the compass on
            dataRate: 1
            onReadingChanged: {
                azimutDevice = reading.azimuth !== undefined ? reading.azimuth.toFixed(0) : 0
            }
        }

        OrientationSensor {
            id: orientationReading
            active: false
        }

        Toast { id: toast }

        TilesDownloader {
            id: tilesDownloader
            onStateChanged: {
                if(tilesDownloader.state !== "OK" && tilesDownloader.state !== "loading") {
                    toast.visible = true
                    toast.show(state)
                }
            }
        }

        ReplaceImageInText {
            id: replaceImageInText
            onStateChanged: {
                if(replaceImageInText.state !== "OK" && replaceImageInText.state !== "loading") {
                    toast.visible = true
                    toast.show("Erreur de chargement des images "   + "(" + state + ")")
                }
            }
        }

        SQLiteStorage {
            id: sqliteStorage
            Component.onCompleted: {
                // Build database
                sqliteStorage.createTable("fullcache", "(id string primary key, name string, type int, size int, difficulty double,
                                        terrain double, lat double, lon double, found bool, own bool, json string, userlogs string )");
                sqliteStorage.createTable("lists", "(id integer primary key default 1  , text string)");
                sqliteStorage.createTable("cacheslists", "(id integer primary key default 1 , list integer , code string , UNIQUE(list, code))");
                sqliteStorage.createTable("cacheslog", "(id string primary key, json string)");
                sqliteStorage.createTable("cachestbsuserlog", "(id string primary key, json string)");
                sqliteStorage.createTable("tblog", "(id string primary key, json string)");
                sqliteStorage.createTable("cachesimageslog", "(id string primary key, json string)");

                sqliteStorage.updateLists("lists", 1 , "Enregistrées");
                sqliteStorage.numberCachesInLists("cacheslists");

                sqliteStorage.updateReplaceImageInText(replaceImageInText)
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

        CacheMapTiles {
            id: cacheMapTiles
        }
        Component.onCompleted: {
            main.listState = ""
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
        Keys.onPressed: (event) => {
                            event.accepted = true
                            if (event.key === Qt.Key_Escape || event.key === Qt.Key_Back) {
                                if (webEngine.visible) {
                                    webEngine.visible = false
                                } else if (coordinatesBox.opened) {
                                    coordinatesBox.close()
                                } else if (userWaypoint.opened) {
                                    userWaypoint.close()
                                } else if (cachesRecordedLists.opened) {
                                    cachesRecordedLists.close()
                                } else if (geocode.opened) {
                                    geocode.geocodeResponseVisible = false
                                    geocode.close()
                                } else if (ownerProfile.opened) {
                                    ownerProfile.close()
                                } else if (fastMenu.isMenuVisible()) {
                                    fastMenu.hideMenu()
                                } else if (satelliteInfo.isMenuVisible()) {
                                    satelliteInfo.hideMenu()
                                } else if (userSettings.isMenuVisible()) {
                                    userSettings.hideMenu()
                                } else if (fastMenuHeader.isFiltersVisible()) {
                                    fastMenuHeader.changeFiltersVisibility()
                                } else if (main.viewState === "fullcache") {
                                    main.viewState = previousViewState[0]
                                } else if (main.viewState === "travelbug") {
                                    main.viewState = previousViewState[1]
                                } else {
                                    sureQuit.visible = true
                                }
                            }
                        }
    }
}


