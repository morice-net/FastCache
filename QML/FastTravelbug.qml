import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: fastTravelbug
    anchors.fill: parent
    visible: main.viewState === "travelbug"
    color: Palette.greenSea()

    Row {
        id:fastTravelbugHeader
        x: 200
        y: 10
        height: parent.height * 0.02
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
        anchors.fill: parent
        currentIndex: 1
        anchors.top: fastTravelbugHeader.bottom
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
