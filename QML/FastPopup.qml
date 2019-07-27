import QtQuick 2.6
import QtQuick.Controls 2.2

Popup {

    opacity: 0
    Behavior on opacity { NumberAnimation { duration: 800 ; easing.type: Easing.OutCurve } }

    Timer {
        id: popupTimer
        interval: 500
        repeat: true
        onTriggered: closeIfMenu()
    }

    // Exit and focus management
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
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
