import QtQuick 2.6
import QtSensors 5.2 // to use Compass
import "JavaScript/Palette.js" as Palette

Item {
    id: compassPage

    Rectangle { // the compass view background
        id: compassBackground
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) - 20
        height: width
        radius: width / 2
        color: Palette.white()

        Image { // the compass view as a highlighted image
            id: compassImage
            source: "qrc:/Image/compass.svg"
            anchors.fill: parent

            Rectangle {
                id: compassNeedle
                height: parent.height
                width: 10
                color: Palette.greenSea()
                anchors.centerIn: parent
            }
        }
    }

    function updateRotation() {
        console.log("Updating BIG compass...")
        if (typeof currentPosition.direction !== 'undefined')
            compassImage.rotation = -1. * currentPosition.direction
        compassNeedle.rotation = currentPosition.position.coordinate.azimuthTo(fullCacheLocation.coordinate)
    }


    Component.onCompleted: {
        main.positionUpdated.connect(updateRotation)
    }
}
