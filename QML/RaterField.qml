import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Row {
    id: raterField

    property string ratingName
    property real ratingValue: 1.0
    property bool reversedColor: false
    property alias ratingTextPixelSize: raterText.font.pixelSize

    width: parent.width / 2
    spacing: 2
    
    Text {
        id: raterText
        font.family: localFont.name
        color: reversedColor ? Palette.white() : Palette.black()
        text: raterField.ratingName
        font.bold: reversedColor
    }

    Repeater {
        model: Math.floor(raterField.ratingValue)

        Rectangle {
            width: parent.height
            height: width
            radius: width/2
            color: reversedColor ? Palette.white() : Palette.greenSea()
        }
    }
    
    Repeater {
        model: Math.ceil(raterField.ratingValue) - Math.floor(raterField.ratingValue)

        Rectangle {
            width: parent.height
            height: width
            radius: width/2
            rotation: 90
            border.color: reversedColor ? Palette.white() : Palette.greenSea()
            gradient: Gradient {
                GradientStop {
                    position: 0.000
                    color: reversedColor ? Palette.silver() : Palette.white()
                }
                GradientStop {
                    position: 0.500
                    color: reversedColor ? Palette.silver() : Palette.white()
                }
                GradientStop {
                    position: 0.501
                    color: reversedColor ? Palette.white() : Palette.greenSea()
                }
                GradientStop {
                    position: 1
                    color: reversedColor ? Palette.white() : Palette.greenSea()
                }
            }
        }
    }
    
    Repeater {
        model: 5 - Math.ceil(raterField.ratingValue)

        Rectangle {
            width: raterField.height
            height: width
            radius: width/2
            border.color: reversedColor ? Palette.white() : Palette.greenSea()
            color: reversedColor ? Palette.silver() : Palette.white()
        }
    }
}
