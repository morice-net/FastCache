import QtQuick
import QtLocation
import QtPositioning

import "JavaScript/Palette.js" as Palette

Row {
    id: raterField

    property string ratingName
    property real ratingValue: 1.0
    property bool reversedColor: false
    property alias ratingTextPointSize: raterText.font.pointSize

    spacing: 4

    Text {
        id: raterText
        font.family: localFont.name
        color: reversedColor ? Palette.white() : Palette.black()
        text: raterField.ratingName
        font.bold: reversedColor
    }

    Repeater {
        model: 5

        Rectangle {
            anchors.verticalCenter: raterText.verticalCenter
            width: parent.height * 0.6
            height: width
            radius: width/2
            border.color: reversedColor ? Palette.white() : Palette.greenSea()
            rotation: rectangleType(index) === 2 ? 90 : 0   // semi-full rectangle or not
            gradient: Gradient {
                GradientStop {
                    position: 0.000
                    color: gradientColorBeginning(index)
                }
                GradientStop {
                    position: 0.500
                    color: gradientColorBeginning(index)
                }
                GradientStop {
                    position: 0.501
                    color: gradientColorEnd(index)
                }
                GradientStop {
                    position: 1
                    color: gradientColorEnd(index)
                }
            }
        }
    }

    function rectangleType(indexModel) {
        if((raterField.ratingValue - indexModel) >= 1) // solid rectangle
            return 1
        if((raterField.ratingValue - indexModel) < 1 && (raterField.ratingValue - indexModel) > 0) // semi-full rectangle
            return 2
        if((raterField.ratingValue - indexModel ) <= 0) // empty rectangle
            return 3
    }

    function gradientColorBeginning(indexModel) {
        if((raterField.ratingValue - indexModel) >= 1) // solid rectangle
            return reversedColor ? Palette.white() : Palette.greenSea()
        return reversedColor ? Palette.silver() : Palette.white() // not solid rectangle
    }

    function gradientColorEnd(indexModel) {
        if((raterField.ratingValue - indexModel ) <= 0) // empty rectangle
            return reversedColor ? Palette.silver() : Palette.white()
        return reversedColor ? Palette.white() : Palette.greenSea() // not empty rectangle
    }
}
