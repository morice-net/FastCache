import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

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
        x: 200
        y: 10
        spacing: 10

        Image {
            source: travelbug.iconUrl
            scale: 1.2
        }

        Text {
            font.family: localFont.name
            font.bold: true
            font.pointSize: 18
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
        anchors.topMargin: 15
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

    function addPage(page) {
        swipeFastTravelbug.addItem(page);
        page.visible = true ;
    }

    function removePage(page) {
        for (var n = 0; n < indicatorFastTravelbug.count; n++) {
            if (page === swipeFastTravelbug.itemAt(n)) {
                swipeFastTravelbug.removeItem(n) ;
                page.visible = false ;
                return ;
            }
        }
        page.visible = false ;
        return ;
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
