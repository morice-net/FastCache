import QtQuick 2.6
import QtQuick.Controls 2.2

Popup {

    opacity: 0
    Behavior on opacity { NumberAnimation { duration: 1000 ; easing.type: Easing.OutCurve } }

    // Exit and focus management
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    onVisibleChanged: {
        if (visible)
            opacity = 1
        else
            opacity = 0
        main.forceActiveFocus()
    }
}
