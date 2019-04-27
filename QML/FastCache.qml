import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: fastCache

    property bool allVisible: true

    anchors.fill: parent
    opacity: main.viewState === "fullcache" ? 1 : 0
    visible: opacity > 0
    color: Palette.greenSea()

    Text {
        id: loadingText
        visible: fullCache.state === "loading"
        anchors.fill: parent
        font.family: localFont.name
        font.pointSize: 20
        text: "Loading....\n\n\n"
        color: Palette.white()
        
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    
    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: fullCache.state === "loading"
    }

    Row {
        id:fastCacheHeader
        y: 10
        height: parent.height * 0.02
        property int xGoal: 0
        x: -100
        spacing: 10

        AnimatedSprite {
            id: fastCacheHeaderIcon
            visible: false
            scale: 1.6
            y: 8
            paused: true
            source: "qrc:/Image/cacheList.png"
            frameCount: 15
            currentFrame: main.cacheMarkerId(fullCache.type) % 15
        }

        Text {
            id: fastCacheHeaderName
            font.family: localFont.name
            font.bold: true
            font.pointSize: 18
            text: fullCache.name
            color: Palette.white()
            onTextChanged: {
                parent.x = parent.height + fastCacheHeaderIcon.width * 2
                parent.xGoal = Math.min(+ fastCache.width - width - fastCacheHeaderIcon.width * 4, parent.x)
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
            NumberAnimation { target: fastCacheHeader; property: "x"; to: fastCacheHeader.height + fastCacheHeaderIcon.width * 2; duration: 800 }
        }
    }

    SwipeView {
        id: swipeFastCache
        visible: fullCache.state !== "loading"
        currentIndex: 3
        anchors.top: fastCacheHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        onCurrentIndexChanged :{
            if(swipeFastCache.currentIndex !== 6  && allVisible === false){
                imagesTrue() ;
                allVisible = true ;
            }
        }

        CompassPage {
            id: compassPage
        }

        FastCacheWaypointsPage {
            id: waypointsPage
        }
        
        FastCacheDescriptionPage {
            id: descriptionPage
        }
        
        FastCacheDetailsPage {
            id: detailsPage
        }
        
        FastCacheLogsPage {
            id: logsPage
        }
        
        FastCacheImagesPage {
            id: imagesPage
        }

        FastCacheLogPage {
            id: logPage
        }
    }
    
    PageIndicator {
        id: indicatorFastCache
        visible: fullCache.state !== "loading"
        
        count: swipeFastCache.count
        currentIndex: swipeFastCache.currentIndex
        
        anchors.bottom: fastCache.bottom
        anchors.horizontalCenter: parent.horizontalCenter
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
}
