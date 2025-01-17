import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions

Rectangle {
    id: fastCache

    property int compassPageIndex: 0
    property int waypointsPageIndex: 1
    property int descriptionPageIndex: 2
    property int detailsPageIndex: 3
    property int imagesPageIndex: 4
    property int logsPageIndex: 5
    property int logPageIndex: 6
    property int tbsPageIndex: 7
    property int userLogsPageIndex: 8

    property alias swipeLogPage: logPage

    // updateLog to false for a log creation, to true for a log update
    property bool updateLog: false
    property int updateLogIndex: 0

    // userLogImages to true for a list of images from a user log, false otherwise
    property bool userLogImages: false

    // use to allow overlap of the web view by the menu
    property bool webViewDescriptionPageVisible: (main.listState !== "recorded" || main.listState === "cachesActive")

    // used to send images to a log
    property var listImagesUrl: sqliteStorage.isCacheInTable("cachesimageslog", fullCache.geocode) ?
                                    createListParameterImagesLog(
                                        sendImagesLog.readJsonArray(sqliteStorage.readColumnJson(
                                                                        "cachesimageslog" , fullCache.geocode)), "imageUrl") : []
    property var listImagesDescription: sqliteStorage.isCacheInTable("cachesimageslog", fullCache.geocode) ?
                                            createListParameterImagesLog(
                                                sendImagesLog.readJsonArray(sqliteStorage.readColumnJson(
                                                                                "cachesimageslog" , fullCache.geocode)), "imageDescription") : []
    property var listImagesRotation: sqliteStorage.isCacheInTable("cachesimageslog", fullCache.geocode) ?
                                         createListParameterImagesLog(
                                             sendImagesLog.readJsonArray(sqliteStorage.readColumnJson(
                                                                             "cachesimageslog" , fullCache.geocode)), "imageRotation") : []

    // used to save images sent to a log
    property var listImagesLog: createListImagesLog()

    // used by compassPage
    property string wptName
    property double goalLat
    property double goalLon

    property bool allVisible: true
    property int userWptIndex: 0

    // Add(true) or update(false) userWaypoint
    property bool userWptAdd: true

    property string userWptCode: ""

    // modification of coordinates
    property bool userCorrectedCoordinates: false

    // Delete userWaypoint or delete modification of coordinates
    property bool deleteUserWpt: true

    // List of travelbugs that can be sent: tbCode,trackingNumber,typeLog,dateIso,logText
    property var listTbSend: sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache.geocode)?
                                 sendTravelbugLog.readJsonArray(sqliteStorage.readColumnJson("cachestbsuserlog" , fullCache.geocode)) : []

    // Is geocode on list of caches?
    property bool geocodeInCachesList: fastMap.isGeocodeInCachesList(fullCache.geocode)

    anchors.fill: parent
    opacity: main.viewState === "fullcache" ? 1 : 0
    visible: opacity > 0
    color: Palette.greenSea()

    LoadingPage {
        id: loadingPage
    }

    Row {
        id:fastCacheHeader
        y: fullCache.type === "labCache" ? 15 : 5
        property int xGoal: 0
        x: -100
        spacing: 10

        AnimatedSprite {
            id: fastCacheHeaderIcon
            visible: fullCache.type !== "labCache"   // geocode GC...
            anchors.verticalCenter: parent.verticalCenter
            running: false
            source: "../Image/cacheList.png"
            frameCount: 15
            currentFrame: fullCache.typeIndex
        }

        Image {
            id: fastLabCacheHeaderIcon
            visible: fullCache.type === "labCache"   // lab cache
            width: 25
            height: 25
            anchors.verticalCenter: parent.verticalCenter
            source: "../Image/labCache.png"
        }

        Text {
            id: fastCacheHeaderName
            anchors.verticalCenter: parent.verticalCenter
            font.family: localFont.name
            font.bold: true
            font.pointSize: 18
            text: fullCache.name
            color: Palette.white()
            onTextChanged: {
                parent.x = fastCache.width * 0.31
                if(fastCacheHeaderIcon.width + fastCacheHeaderName.width <= fastCache.width - parent.x - fastCache.width * 0.1)  {
                    parent.xGoal = parent.x
                } else {
                    parent.xGoal = Math.min(fastCache.width - parent.x - fastCacheHeaderIcon.width - fastCacheHeaderName.width - fastCache.width * 0.1 ,
                                            parent.x)
                }
                headerAnimation.restart()
            }
        }

        SequentialAnimation {
            id: headerAnimation
            running: true
            loops: Animation.Infinite

            PauseAnimation { duration: 3000 }
            NumberAnimation { target: fastCacheHeader; property: "x"; to: fastCacheHeader.xGoal; duration: 5000 }
            PauseAnimation { duration: 500 }
            NumberAnimation { target: fastCacheHeader; property: "x"; to: fastCacheHeader.x ; duration: 800 }
        }
    }

    SwipeView {
        id: swipeFastCache

        property int swipeViewCountCache: 9
        property int swipeViewCountLabCache: 5
        property string cacheGeocode: fullCache.geocode

        onCacheGeocodeChanged: {
            if(cacheGeocode.substring(0,2) !== "GC" && swipeFastCache.count === swipeViewCountCache ) {   // lab cache
                swipeFastCache.takeItem(5)
                swipeFastCache.takeItem(5)
                swipeFastCache.takeItem(5)
                swipeFastCache.takeItem(5)
            } else if(cacheGeocode.substring(0,2) === "GC" && swipeFastCache.count === swipeViewCountLabCache) {  // GC.. cache
                swipeFastCache.addItem(logsPage)
                swipeFastCache.addItem(logPage)
                swipeFastCache.addItem(tbsPage)
                swipeFastCache.addItem(userLogsPage)
            }
        }
        visible: fullCacheRetriever.state !== "loading"
        currentIndex: detailsPageIndex
        anchors.top: fastCacheHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        onCurrentIndexChanged :{
            if( allVisible === false){
                imagesTrue() ;
                allVisible = true ;
            }
        }

        CompassPage { id: compassPage }

        FastCacheWaypointsPage { id: waypointsPage }

        FastCacheDescriptionPage { id: descriptionPage }

        FastCacheDetailsPage { id: detailsPage }

        FastCacheImagesPage { id: imagesPage }

        FastCacheLogsPage { id: logsPage  }

        FastCacheLogPage {id: logPage }

        FastCacheTBsPage { id: tbsPage }

        FastCacheUserLogsPage { id: userLogsPage }
    }

    Flickable {
        anchors.top: fastCacheHeader.bottom
        width: main.width
        contentWidth: swipeFastCache.count === swipeFastCache.swipeViewCountCache ? width * 1.75 : width
        height: fastCacheHeader.height + 2
        flickableDirection: Flickable.HorizontalFlick

        PageIndicator {
            id: indicatorFastCache
            anchors.horizontalCenter: parent.horizontalCenter
            visible: fullCacheRetriever.state !== "loading"
            interactive: true
            count: swipeFastCache.count
            currentIndex: swipeFastCache.currentIndex
            onCurrentIndexChanged: swipeToPage(currentIndex)
            delegate:
                Text {
                font.pointSize: 14
                text: pageIndicatorMenu(index)
                color: index === indicatorFastCache.currentIndex ? Palette.white() : Palette.black()
            }
        }
    }

    function imagesTrue() {
        var visible =[];
        for (var i = 0; i < fullCache.imagesName.length; i++) {
            visible.push(true) ;
        }
        fullCache.setListVisibleImages(visible);
    }

    function swipeToPage(pageNumber) {
        swipeFastCache.setCurrentIndex(pageNumber)
    }

    function compassPageInit(title , lat , lon) {
        wptName = title;
        goalLat = lat;
        goalLon = lon;
    }

    function compassPageTitleFullCache() {
        var cachetype = "Cache: "
        var cacheGeocode = ""
        if(fullCache.geocode.substring(0,2) !== "GC" ) { // lab cache
            cachetype = "Lab Cache: "
            cacheGeocode = fullCache.geocode.substring(0,10) + "..."
        } else {
            cacheGeocode = fullCache.geocode // cache GC..
        }
        return cachetype + cacheGeocode
    }

    function addImagesToLog() {
        var code
        if(updateLog === false) {
            code = sendCacheLog.codeLog
        } else {
            code = sendEditUserLog.codeLog
        }
        console.log("CODE LOG:  " + code)
        console.log("DESCRIPTION:  " + listImagesDescription)
        console.log("URL:  " + listImagesUrl)
        console.log("ROTATION:  " + listImagesRotation)
        if(code === "" || listImagesUrl.length === 0)
            return
        for (var i = 0; i <listImagesUrl.length; i++) {
            sendImagesLog.sendRequest(connector.tokenKey, code , listImagesDescription[i], listImagesUrl[i], listImagesRotation[i])
        }
    }

    function createListImagesLog() {
        var list = []
        for (var i = 0; i < listImagesDescription.length; i++) {
            list.push(listImagesUrl[i] + "," + listImagesRotation[i] + "," + listImagesDescription[i])
        }
        return list
    }

    function createListParameterImagesLog(listImages, parameter) {
        var url = []
        var rotation = []
        var description = []
        var listUrl = []
        var listRotation = []
        var listDescription = []
        for (var i = 0; i < listImages.length; i++) {
            url = listImages[i].split(',')[0]
            rotation = listImages[i].split(',')[1]
            description = listImages[i].substring(url.length + rotation.length + 2)
            listUrl.push(url)
            listRotation.push(rotation)
            listDescription.push(description)
        }
        if(parameter === "imageUrl")
            return listUrl
        if(parameter === "imageRotation")
            return listRotation
        if(parameter === "imageDescription")
            return listDescription
    }

    function pageIndicatorMenu(index)  {
        if(index === compassPageIndex)
            return "Boussole   "
        if(index ===  waypointsPageIndex)
            return "Etapes   "
        if(index === descriptionPageIndex)
            return "Description  "
        if(index === detailsPageIndex)
            return "Détails  "
        if(index === imagesPageIndex)
            return "Images  "
        if(index === logsPageIndex)
            return "Logs   "
        if(index === logPageIndex)
            return "Loguer  "
        if(index === tbsPageIndex)
            return "TravelBug   "
        if(index === userLogsPageIndex)
            return "Logs-utilisateur"
    }

    function formatLatText(format , lat) {
        if(format)  {
            return Functions.formatLat(lat)
        } else {
            return lat
        }
    }

    function formatLonText(format , lon) {
        if(format)  {
            return Functions.formatLon(lon)
        } else {
            return lon
        }
    }
}

