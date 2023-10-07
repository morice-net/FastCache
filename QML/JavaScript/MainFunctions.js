function createFilterDifficultyTerrainGs(){
    var  list = []
    list.push(settings.difficultyMin)
    list.push(settings.difficultyMax)
    list.push(settings.terrainMin)
    list.push(settings.terrainMax)
    return list
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

// center and zoom level
function centerMapCaches(listCaches) {
    if(listCaches.length === 0) {
        fastMap.currentZoomlevel = 13
        return
    }
    if(listCaches.length === 1) {
        fastMap.mapItem.center.latitude = listCaches[0].lat
        fastMap.mapItem.center.longitude = listCaches[0].lon
        fastMap.currentZoomlevel = 13
        return
    }
    fastMap.mapItem.fitViewportToMapItems()
    fastMap.currentZoomlevel= fastMap.mapItem.zoomLevel
}

function toDoLogDynamic(listCaches) {
    if(!fastCache.geocodeInCachesList) //cache not in list
        return
    for (var i = 0; i < listCaches.length; i++) {
        if(listCaches[i].geocode === fullCache.geocode){
            listCaches[i].toDoLog = fullCache.toDoLog;
            return;
        }
    }
}

function foundDynamic(listCaches) {
    if(!fastCache.geocodeInCachesList) //cache not in list
        return
    for (var i = 0; i < listCaches.length; i++) {
        if(listCaches[i].geocode === fullCache.geocode) {
            listCaches[i].found = fullCache.found;
            return;
        }
    }
}

function registeredDynamic(listCaches) {
    if(!fastCache.geocodeInCachesList) //cache not in list
        return
    for (var i = 0; i < listCaches.length; i++) {
        if(listCaches[i].geocode === fullCache.geocode){
            listCaches[i].registered = fullCache.registered;
            return;
        }
    }
}

//dynamic changes on list and  map
function correctedCoordinatesDynamic(listCaches) {


    console.log("Bonjour:  " + listCaches.length)




    if(!fastCache.geocodeInCachesList) //cache not in list
        return
    for (var i = 0; i < listCaches.length; i++) {
        if(listCaches[i].geocode === fullCache.geocode){
            if(fullCache.isCorrectedCoordinates){
                listCaches[i].lat = fullCache.correctedLat;
                listCaches[i].lon = fullCache.correctedLon;
            } else {
                listCaches[i].lat = fullCache.lat;
                listCaches[i].lon = fullCache.lon;
            }
            return;
        }
    }
}

function recordAppSettings() {
    settings.tokenKey = connector.tokenKey
    settings.refreshToken = connector.refreshToken
    fastMenuHeader.recordInSettings()
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

function reloadCachesNear() {
    if(main.state === "near" || main.state === "address" || main.state === "coordinates") {
        // caches
        cachesNear.latPoint = fastMap.mapItem.center.latitude
        cachesNear.lonPoint = fastMap.mapItem.center.longitude
        cachesNear.distance = 100
        cachesNear.updateFilterCaches(listTypes, listSizes, createFilterDifficultyTerrainGs(), excludeFound,
                                      excludeArchived, createFilterKeywordDiscoverOwner(), userInfo.name)
        cachesNear.indexMoreCaches = 0
        cachesNear.sendRequest(connector.tokenKey)

        //lab caches
        if(settings.labCache === false) {
            adventureLabCachesRetriever.cachesActive = false
            adventureLabCachesRetriever.latPoint = fastMap.mapItem.center.latitude
            adventureLabCachesRetriever.lonPoint = fastMap.mapItem.center.longitude
            adventureLabCachesRetriever.distance = 100
            adventureLabCachesRetriever.excludeOwnedCompleted = main.excludeFound
            adventureLabCachesRetriever.indexMoreLabCaches = 0
            adventureLabCachesRetriever.sendRequest(connector.tokenKey)
        }
    }
}

function reloadCachesBBox() {
    if(main.state === "cachesActive" && cachesBBox.state !== "loading" && fastMap.compassMapButton === false) {
        // caches
        cachesBBox.latBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).latitude
        cachesBBox.lonBottomRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).longitude
        cachesBBox.latTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).latitude
        cachesBBox.lonTopLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).longitude
        cachesBBox.updateFilterCaches(listTypes , listSizes , createFilterDifficultyTerrainGs(), excludeFound,
                                      excludeArchived, createFilterKeywordDiscoverOwner() , userInfo.name )
        cachesBBox.sendRequest(connector.tokenKey)

        //lab caches
        if(settings.labCache === false) {
            adventureLabCachesRetriever.cachesActive = true
            adventureLabCachesRetriever.latPoint = (cachesBBox.latBottomRight + cachesBBox.latTopLeft) / 2
            adventureLabCachesRetriever.lonPoint = (cachesBBox.lonBottomRight + cachesBBox.lonTopLeft) / 2

            // radius in km
            adventureLabCachesRetriever.distance = Math.round(adventureLabCachesRetriever.distTo(cachesBBox.latBottomRight , cachesBBox.lonBottomRight ,
                                                                                                 cachesBBox.latTopLeft , cachesBBox.lonTopLeft))
            adventureLabCachesRetriever.excludeOwnedCompleted = main.excludeFound
            adventureLabCachesRetriever.indexMoreLabCaches = 0
            adventureLabCachesRetriever.sendRequest(connector.tokenKey)
        }
    }
}

function downloadTiles() {
    var latTop = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).latitude
    var latBottom = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).latitude
    var lonLeft = fastMap.mapItem.toCoordinate(Qt.point(main.x , main.y)).longitude
    var lonRight = fastMap.mapItem.toCoordinate(Qt.point(main.x + main.width , main.y + main.height)).longitude
    var zoom = fastMap.mapItem.zoomLevel
    //osm
    if(settings.namePlugin === settings.listPlugins[0]) {
        tilesDownloader.downloadTilesOsm(latTop , latBottom , lonLeft , lonRight , zoom)
        if(zoom < 19)
            tilesDownloader.downloadTilesOsm(latTop , latBottom , lonLeft , lonRight , zoom + 1)
        if(zoom < 18)
            tilesDownloader.downloadTilesOsm(latTop , latBottom , lonLeft , lonRight , zoom + 2)
    }
    //googlemaps road map
    else  if(settings.namePlugin === settings.listPlugins[1] && settings.sat === false) {
        tilesDownloader.downloadTilesGooglemaps(latTop , latBottom , lonLeft , lonRight , zoom , 0)
        if(zoom < 19)
            tilesDownloader.downloadTilesGooglemaps(latTop , latBottom , lonLeft , lonRight , zoom + 1 , 0)
        if(zoom < 18)
            tilesDownloader.downloadTilesGooglemaps(latTop , latBottom , lonLeft , lonRight , zoom + 2 , 0)
    }
    //googlemaps Sat
    else if(settings.namePlugin === settings.listPlugins[1] && settings.sat === true) {
        tilesDownloader.downloadTilesGooglemaps(latTop , latBottom , lonLeft , lonRight , zoom , 3)
        if(zoom < 19)
            tilesDownloader.downloadTilesGooglemaps(latTop , latBottom , lonLeft , lonRight , zoom + 1 , 3)
        if(zoom < 18)
            tilesDownloader.downloadTilesGooglemaps(latTop , latBottom , lonLeft , lonRight , zoom + 2 , 3)
    }
    //cyclOsm
    else if(settings.namePlugin === settings.listPlugins[2]) {
        tilesDownloader.downloadTilesCyclOsm(latTop , latBottom , lonLeft , lonRight , zoom)
        if(zoom < 19)
            tilesDownloader.downloadTilesCyclOsm(latTop , latBottom , lonLeft , lonRight , zoom + 1)
        if(zoom < 18)
            tilesDownloader.downloadTilesCyclOsm(latTop , latBottom , lonLeft , lonRight , zoom + 2)
    }
}
