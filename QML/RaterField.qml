import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Row {
    id: raterField
    property string ratingName
    property real ratingValue: 1.0
    width: selectedCacheItem.width / 2
    spacing: 2
    
    Text {
        font.family: localFont.name
        font.pixelSize: selectedCacheItem.height * 0.15
        color: Palette.black()
        text: raterField.ratingName
    }

    Repeater {
        model: Math.floor(raterField.ratingValue)
        Rectangle {
            width: selectedCacheGeocodeField.height
            height: width
            radius: width/2
            color: Palette.greenSea()
        }
    }
    
    Repeater {
        model: Math.ceil(raterField.ratingValue) - Math.floor(raterField.ratingValue)
        Rectangle {
            width: selectedCacheGeocodeField.height
            height: width
            radius: width/2
            rotation: 90
            border.color: Palette.greenSea()
            gradient: Gradient {
                GradientStop {
                     position: 0.000
                     color: Palette.white()
                  }
                GradientStop {
                     position: 0.500
                     color: Palette.white()
                  }
                  GradientStop {
                     position: 0.501
                     color: Palette.greenSea()
                  }
                  GradientStop {
                     position: 1
                     color: Palette.greenSea()
                  }
            }
        }
    }
    
    Repeater {
        model: 5 - Math.ceil(raterField.ratingValue)
        Rectangle {
            width: selectedCacheGeocodeField.height
            height: width
            radius: width/2
            border.color: Palette.greenSea()
            color: Palette.white()
        }
    }
}
