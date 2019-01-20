import QtQuick 2.6

import "JavaScript/Palette.js" as Palette

Item {
    id: compassMapSwipeButton
    height: parent.height * 0.12
    width: parent.width * 0.3

    opacity: 0.75

    property string buttonText

    Rectangle {
        id: compassMapSwipeButtonRectangle
        radius: 20
        anchors.fill: parent
        color: Palette.turquoise()
        
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
            font.pointSize: 24
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
