import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastTravelbug
    anchors.fill: parent
    visible: main.viewState === "travelbug"
    color: Palette.greenSea()

    LoadingPage {
        id: loadingPage
    }

    Row {
        id:fastTravelbugHeader
        x: main.width / 3
        y: 10
        spacing: 10

        Image {
            source: travelbug.iconUrl
            scale: 0.8
        }

        Text {
            font.family: localFont.name
            font.bold: true
            font.pointSize: 17
            text: "Objet voyageur"
            color: Palette.white()
        }
    }

    SwipeView {
        id: swipeFastTravelbug
        visible: travelbug.state !== "loading"
        anchors.fill: parent
        currentIndex: 1
        anchors.top: fastTravelbugHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        FastTravelbugDetailsPage { id: fastTravelbugDetailsPage }

        FastTravelbugLogsPage{ id: fastTravelbugLogsPage }

        FastTravelbugLogPage{ id: fastTravelbugLogPage }
    }

    PageIndicator {
        id: indicatorFastTravelbug
        anchors.top: fastTravelbugHeader.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        count: swipeFastTravelbug.count
        visible: travelbug.state !== "loading"
        interactive: true
        currentIndex: swipeFastTravelbug.currentIndex
        onCurrentIndexChanged: swipeToPage(currentIndex)
        delegate:
            Text {
            font.pointSize: 14
            text: pageIndicatorMenu(index)
            color: index === indicatorFastTravelbug.currentIndex ? Palette.white() : Palette.black()
        }

    }

    function swipeToPage(pageNumber) {
        swipeFastTravelbug.setCurrentIndex(pageNumber)
    }

    function pageIndicatorMenu(index) {
        if(index === 0)
            return "Détails   "
        if(index ===  1 )
            return "Logs   "
        if(index === 2 )
            return "Loguer  "
    }
}
