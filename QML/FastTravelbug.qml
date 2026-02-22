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
        id: fastTravelbugHeader
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
        anchors.top: fastTravelbugHeader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 1

        FastTravelbugDetailsPage { id: fastTravelbugDetailsPage }

        FastTravelbugLogsPage{ id: fastTravelbugLogsPage }

        FastTravelbugLogPage{ id: fastTravelbugLogPage }
    }

    // When the menu is open, it allows you to darken the background.
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Palette.black()
        opacity: fastMenu.isMenuVisible() ? 0.8 : 0
        visible: fastMenu.isMenuVisible()

        Behavior on opacity {
            NumberAnimation { duration: 200 }
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
