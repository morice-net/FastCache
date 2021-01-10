import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Popup {
    id: popupItem
    width: main.width*0.8
    height: main.height*0.8

    property alias backgroundWidth: popupItem.width
    property alias backgroundHeight: popupItem.height
    property alias backgroundColor: backgroundRectangle.color
    property alias backgroundRadius: backgroundRectangle.radius
    property alias backgroundBorder: backgroundRectangle.border
    property alias backgroundOpacity: backgroundRectangle.opacity
    property alias closeButtonVisible: closeButton.visible

    opacity: 0

    Behavior on opacity { NumberAnimation { duration: 800 ; easing.type: Easing.OutCurve } }

    background: Rectangle {
        id: backgroundRectangle
        radius: 10
        color: Palette.turquoise()
    }

    Timer {
        id: popupTimer
        interval: 500
        repeat: true
        onTriggered: closeIfMenu()
    }

    Text {
        id: closeButton
        text: "X"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        font.pixelSize: parent.width / 12
        color: backgroundColor === Palette.greenSea() || backgroundColor === Palette.turquoise() ? Palette.white() : Palette.greenSea()

        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }

    // Exit and focus management
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    onVisibleChanged: {
        if (visible) {
            opacity = 1
            popupTimer.running = true
        } else {
            opacity = 0
            popupTimer.running = false
        }
        main.forceActiveFocus()
    }
}
