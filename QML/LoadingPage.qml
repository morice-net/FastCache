import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id:loadingPage
    z: 2
    opacity: 0.8

    Rectangle {
        x: 0
        width: main.width
        height: main.height
        color: Palette.greenSea()
        visible: visibleRectangle()

        Text {
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 20
            text: "Loading....\n\n\n"
            color: Palette.white()
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: visibleRectangle()
        }
    }

    function visibleRectangle() {
        if(fullCacheRetriever.timeOutRequest === true)
            return false
        if(sendCacheNote.state === "loading" || sendCacheLog.state === "loading" || fullCacheRetriever.state === "loading" || travelbug.state === "loading"
                || sendTravelbugLog.state === "loading" || fullCachesRecorded.state === "loading" || sendEditUserLog.state === "loading"
                || deleteLogImage.state === "loading")
            return true
        if(userLogImagesLoaded > -1 && userLogImagesLoaded < fastCache.listImagesUrl.length)
            return true
        return false
    }
}
