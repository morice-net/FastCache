import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Column {
    id: mapControls
    visible: opacity > 0
    opacity: 0
    width: parent.height * 0.05
    anchors.margins: 20
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    spacing: 10
    
    Behavior on opacity { NumberAnimation { duration: 300 } }
    
    // Centers
    Rectangle {
        height: parent.width
        width: height
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        
        Image {
            source: "qrc:/Image/tracker.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Tracker clicked")
                map.center = currentPosition.position.coordinate
            }
        }
    }
    
    // Zoom plus
    Rectangle {
        height: parent.width
        width: height
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        
        Image {
            source: "qrc:/Image/add.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 8
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Plus clicked")
                currentZoomlevel += 0.5
            }
        }
    }
    
    // Zoom minus
    Rectangle {
        height: parent.width
        width: height
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        
        Image {
            source: "qrc:/Image/remove.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 8
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Minus clicked")
                currentZoomlevel -= 0.5
            }
        }
    }
    
    Timer {
        id: timer
        interval: 12000
        running: false
        onTriggered: mapControls.hide()
    }
    
    function show() {
        opacity = 1
        timer.start()
    }
    function hide() {
        opacity = 0
        timer.stop()
    }
}
