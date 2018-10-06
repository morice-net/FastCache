import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: fastCache
    anchors.fill: parent
    opacity: main.viewState == "fullcache" ? 1 : 0
    visible: opacity > 0
    color: Palette.greenSea()
    
    Text {
        id: loadingText
        visible: fullCache.state == "loading"
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
        running: fullCache.state == "loading"
    }

    Row {
        id:fastCacheHeader
        height: parent.height * 0.05
        width: parent.width - parent.height * 0.075
        anchors.right: parent.right
        spacing: 10

        AnimatedSprite {
            id: fastCacheHeaderIcon
            scale: 1.3
            paused: true
            source: "qrc:/Image/cacheList.png"
            frameCount: 15
            currentFrame: main.cacheMarkerId(fullCache.type) % 15
        }

        Text {
            width: parent.width
            font.family: localFont.name
            font.bold: true
            font.pointSize: 18
            text: fullCache.name + " (" + fullCache.geocode +  ")"
            color: Palette.white()
        }
    }

    SwipeView {
        id: swipeFastCache
        visible: fullCache.state != "loading"
        currentIndex: 2
        anchors.top: fastCacheHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        
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
    }
    
    PageIndicator {
        id: indicatorFastCache
        visible: fullCache.state != "loading"
        
        count: swipeFastCache.count
        currentIndex: swipeFastCache.currentIndex
        
        anchors.bottom: fastCache.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
