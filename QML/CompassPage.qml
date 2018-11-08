import QtQuick 2.6
import QtSensors 5.2 // to use Compass

Item {
        id: compassPage
        anchors.fill: parent

        Item {
            anchors {
                left: parent.left
                leftMargin: 10
                right: parent.right
                rightMargin: 10
                top: parent.top
                topMargin: 10
                bottom: compassStatusLabel.top
                bottomMargin: 10
            }

            Rectangle { // the compass view background
                anchors.centerIn: parent
                radius: Math.min(parent.width, parent.height) / 2
                width: 2 * radius
                height: width
                color: "red"

                Image { // the compass view as a highlighted image
                    source: "qrc:/Image/compass.svg"
                    anchors.fill: parent
                    sourceSize.width: width
                    sourceSize.height: height
                    // the image is rotated according to the compass orientation
                    rotation: compass.reading ? compassPage.orientationAngle - compass.reading.azimuth : 0
                }
            }
        }

        Text {
            id: compassStatusLabel
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            text: {
                var returnedText = ""
                // Trying to read compass
                var compassReading = compass.reading
                if (!compassReading)
                    returnedText = "Compass is not available";
                else if (compassReading.calibrationLevel < 1.0 / 3)
                    returnedText = "Low calibration level";
                else if (compassReading.calibrationLevel < 1.0 / 2)
                    returnedText = "Medium calibration level";
                else if (compassReading.calibrationLevel < 1.0)
                    returnedText = "High calibration level";
                else
                    returnedText = "Compass is calibrated";
                returnedText += " - "
                // Trying to orientation of the screen
                var orientationReadingVar = orientationReading.reading
                if (!orientationReadingVar)
                    returnedText += "No orientation reading"
                else
                    returnedText += orientationReading.orientation
                return returnedText
            }
            color: "black"

        }
}
