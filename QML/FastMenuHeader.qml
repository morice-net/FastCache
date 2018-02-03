import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

Item {
    id: fastMenuHeader
    anchors.fill: parent

    Rectangle {
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.07
        width: height
        anchors.margins: 5
        anchors.left: parent.left
        anchors.top: parent.top

        Image {
            id: menuIcon
            source: "qrc:/Image/menuIcon.png"
            y: parent.height*0.1
            x: y
            height: parent.height*0.8
            width: height

            MouseArea {
                anchors.fill: parent
                onClicked: fastMenu.showMenu()
            }
        }
    }

    Rectangle {
        color: cacheFilter.opacity > 0 ? Palette.turquoise() : Palette.turquoise().replace("#","#99")
        radius: 10
        height: parent.height * 0.07
        width: height
        anchors.margins: 5
        anchors.right: parent.right
        anchors.top: parent.top

        Image {
            source: "qrc:/Image/filter.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Filter clicked")
                cacheFilter.opacity = 1 - cacheFilter.opacity
            }
        }
    }

    CacheFilter { id: cacheFilter }
}
