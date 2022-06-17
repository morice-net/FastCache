import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import "JavaScript/MainFunctions.js" as Functions
import com.mycompany.connecting 1.0

Rectangle {
    id: fastCache

    property int compassPageIndex: 0
    property int waypointsPageIndex: 1
    property int descriptionPageIndex: 2
    property int detailsPageIndex: 3
    property int logsPageIndex: 4
    property int imagesPageIndex: 5
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
    property bool webViewDescriptionPageVisible: (main.state !== "recorded" || main.state === "cachesActive")

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
    property string ifFullCache: compassPageFullCache()
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
        y: 20
        property int xGoal: 0
        x: -100
        spacing: 10

        AnimatedSprite {
            id: fastCacheHeaderIcon
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            scale: 1.6
            running: false
            source: "qrc:/Image/cacheList.png"
            frameCount: 15
            currentFrame: fullCache.typeIndex
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
                parent.x = fastCache.width * 0.21
                if(fastCacheHeaderIcon.width + fastCacheHeaderName.width <= fastCache.width - parent.x - fastCache.width * 0.1)  {
                    parent.xGoal = parent.x
                } else {
                    parent.xGoal = Math.min(fastCache.width - parent.x - fastCacheHeaderIcon.width - fastCacheHeaderName.width - fastCache.width * 0.1 ,
                                            parent.x)
                }
                fastCacheHeaderIcon.visible = true
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
        visible: fullCacheRetriever.state !== "loading"
        currentIndex: 3
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

        FastCacheLogsPage { id: logsPage }

        FastCacheImagesPage { id: imagesPage }

        FastCacheLogPage {id: logPage }

        FastCacheTBsPage { id: tbsPage }

        FastCacheUserLogsPage { id: userLogsPage }
    }

    ScrollView {
        width: main.width
        anchors.top: fastCacheHeader.bottom
        anchors.topMargin: 15
        ScrollBar.horizontal.policy: ScrollBar.SnapOnRelease

        PageIndicator {
            id: indicatorFastCache
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

    function addPage(page) {
        swipeFastCache.addItem(page)
        page.visible = true
    }

    function removePage(page) {
        for (var n = 0; n < indicatorFastCache.count; n++) {
            if (page === swipeFastCache.itemAt(n)) {
                swipeFastCache.removeItem(n)
                page.visible = false
                return
            }
        }
    }

    function compassPageInit(title , lat , lon) {
        wptName = title;
        goalLat = lat;
        goalLon = lon;
    }

    function compassPageFullCache() {
        wptName = "Cache   " + fullCache.geocode
        goalLat = fullCache.isCorrectedCoordinates ? fullCache.correctedLat : fullCache.lat
        goalLon = fullCache.isCorrectedCoordinates ? fullCache.correctedLon : fullCache.lon
        return fullCache.geocode
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

    function pageIndicatorMenu(index) {
        if(index === compassPageIndex)
            return "Boussole   "
        if(index ===  waypointsPageIndex)
            return "Etapes   "
        if(index === descriptionPageIndex)
            return "Description  "
        if(index === detailsPageIndex)
            return "Détails  "
        if(index === logsPageIndex)
            return "Logs   "
        if(index === imagesPageIndex)
            return "Images  "
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

