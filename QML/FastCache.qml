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

    Text {
        id: fastCacheHeader
        width: parent.width
        font.family: localFont.name
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 18
        text: fullCache.name
        color: Palette.white()
    }

    SwipeView {
        id: swipeFastCache
        visible: fullCache.state != "loading"
        currentIndex: 2
        anchors.top: fastCacheHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Item {
            id: waypoints
            Text {
                id: waypointsText
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Etapes"
                color: Palette.white()
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Item {
            id: description
            Text {
                id: descriptionText
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Description"
                color: Palette.white()

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }

        FastCacheDetailsPage {
            id: detailsPage
        }

        Item {
            id: logs
            Text {
                id: logsText
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Carnet de visite"
                color: Palette.white()

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Item {
            id: images
            Text {
                id: imagesText
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Images"
                color: Palette.white()

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
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