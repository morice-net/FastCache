import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: fastTravelbug
    anchors.fill: parent
    opacity: main.viewState === "fullcache" ? 1 : 0
    visible: opacity > 0
    color: Palette.greenSea()

    SwipeView {
        id: swipeFastTravelbug
        currentIndex: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        FastTravelbugDetailsPage {
            id: detailsPage
        }
    }

    PageIndicator {
        id: indicatorFastTravelbug
        count: swipeFastTravelbug.count
        currentIndex: swipeFastTravelBug.currentIndex
        anchors.bottom: fastTravelbug.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
