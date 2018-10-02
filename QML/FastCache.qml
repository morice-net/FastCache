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

    SwipeView {
        id: swipeFastCache
        visible: fullCache.state != "loading"
        currentIndex: 1
        anchors.fill: parent

        Item {
            id: firstPage
            Text {
                id: page1Text
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Page 1"
                color: Palette.white()

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

        }
        Item {
            id: secondPage
            Text {
                id: page2Text
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Page 2"
                color: Palette.white()

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Item {
            id: thirdPage
            Text {
                id: page3Text
                anchors.fill: parent
                font.family: localFont.name
                font.pointSize: 20
                text: "Page 3"
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
