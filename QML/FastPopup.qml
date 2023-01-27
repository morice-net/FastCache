import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Popup {
    id: popupItem
    width: main.width
    height: main.height

    property alias backgroundWidth: popupItem.width
    property alias backgroundHeight: popupItem.height
    property alias backgroundColor: backgroundRectangle.color
    property alias backgroundRadius: backgroundRectangle.radius
    property alias backgroundBorder: backgroundRectangle.border
    property alias backgroundOpacity: backgroundRectangle.opacity
    property alias closeButtonVisible: closeButton.visible

    opacity: 0

    Behavior on opacity { NumberAnimation { duration: 1000 ; easing.type: Easing.OutCurve } }

    background: Rectangle {
        id: backgroundRectangle
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
        font.pointSize: parent.width / 22
        color: Palette.black()

        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }

    // Exit and focus management
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    onVisibleChanged: {
        if (visible) {
            opacity = backgroundOpacity
            popupTimer.running = true
        } else {
            opacity = 0
            popupTimer.running = false
        }
        main.forceActiveFocus()
    }
}
