import QtQuick

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
            source: "../Image/tracker.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 5
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Tracker clicked")
                map.center = locationSource
            }
        }
    }
    
    // Zoom plus
    Rectangle {
        visible: currentZoomlevel < maximumZoomLevel
        height: parent.width
        width: height
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        
        Image {
            source: "../Image/add.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 8
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Plus clicked")
                currentZoomlevel += 1.0
            }
        }
    }
    
    // Zoom minus
    Rectangle {
        visible: currentZoomlevel > minimumZoomLevel
        height: parent.width
        width: height
        color: Palette.turquoise().replace("#","#99")
        radius: 10
        
        Image {
            source: "../Image/remove.png"
            fillMode: Image.PreserveAspectFit
            anchors.fill: parent
            anchors.margins: 8
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Minus clicked")
                currentZoomlevel -= 1.0
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
