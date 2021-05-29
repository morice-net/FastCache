import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: compassMapSwipeButton
    height: parent.height * 0.10
    width: parent.width * 0.2
    opacity: 0.85

    property string buttonText

    Rectangle {
        id: compassMapSwipeButtonRectangle
        radius: 20
        anchors.fill: parent
        color: Palette.silver()
        
        SequentialAnimation on opacity {
            id: compassMapSwipeButtonAnimation
            running: false
            loops: 3
            NumberAnimation { to: 0; duration: 200 }
            NumberAnimation { to: 1; duration: 200 }
        }
        
        Text {
            id: compassMapSwipeButtonName
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 18
            text: buttonText
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: Palette.white()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                compassMapSwipeButtonAnimation.start()
                buttonClicked()
            }
        }
    }
}
