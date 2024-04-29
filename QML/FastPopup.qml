import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Popup {
    id: popupItem
    width: main.width
    height: main.height

    property alias backgroundColor: backgroundRectangle.color
    property alias backgroundRadius: backgroundRectangle.radius
    property alias backgroundBorder: backgroundRectangle.border
    property alias backgroundOpacity: backgroundRectangle.opacity
    property alias closeButtonVisible: closeButton.visible

    enter: Transition {
        NumberAnimation { properties: "opacity"; from: 0 ; to: backgroundOpacity ; duration: 900 }
    }
    background: Rectangle {
        id: backgroundRectangle
        color: Palette.turquoise()
    }

    Text {
        id: closeButton
        text: "X"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        font.pointSize: 20
        color: Palette.black()

        MouseArea {
            anchors.fill: parent
            onClicked: close()
        }
    }

    // Exit and focus management
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
}
