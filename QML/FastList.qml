import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: fastList
    anchors.fill: parent
    opacity: main.viewState == "list" ? 1 : 0
    visible: opacity > 0
    color: Palette.white()


    ListView {
        id: fastListColumn
        width: parent.width
        height: main.state == "near" ? parent.height - fastListHeader.height - fastListBottom.height -10 : parent.height - fastListHeader.height -10
        y: main.state == "near" ? fastListHeader.height + fastListBottom.height +10 : fastListHeader.height + 10
        spacing: 5
        model: modelState()
        delegate: SelectedCacheItem {
            x: (fastList.width - width ) / 2
            Component.onCompleted: show(modelData)
        }        
        ScrollBar.vertical: ScrollBar {}
    }

    Rectangle {
        id: fastListHeader
        width: parent.width
        height: parent.height * 0.07
        color: Palette.white()

        Text {
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.family: localFont.name
            font.pixelSize: parent.height * 0.65
            color: Palette.greenSea()
            text: textHeader()
        }
    }

    Rectangle {
        id: fastListBottom
        width: parent.width
        height: parent.height * 0.05
        color: Palette.turquoise()
        radius:10
        anchors.top: fastListHeader.bottom
        visible:main.state == "near" ? true : false

        Text {            
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pointSize: 20
            font.family: localFont.name
            text: "Rechercher d'autres caches.."
            color: Palette.black()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                cachesNear.sendRequestMore(connector.tokenKey)
            }
        }
    }


    function modelState() {
        if(main.state == "bbox" ){
            return  cachesBBox.caches
        } else if(main.state == "near" ){
            return  cachesNear.caches
        }
    }

    function textHeader() {
        if(main.state == "bbox" ){
            return "Liste de caches(" + fastListColumn.count + ")"
        } else if(main.state == "near" ){
            return  "Caches proches(" + fastListColumn.count + ")"
        }
    }
}
