import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Row {
    id: raterField
    property string ratingName
    property int ratingValue: 0
    
    width: selectedCacheItem.width / 2
    spacing: 2
    
    Text {
        font.family: localFont.name
        font.pixelSize: selectedCacheItem.height * 0.15
        color: Palette.black()
        text: raterField.ratingName
    }
    
    Repeater {
        model: raterField.ratingValue
        Rectangle {
            width: selectedCacheGeocadeField.height
            height: width
            radius: width/2
            color: Palette.greenSea()
        }
    }
    
    Repeater {
        model: 5 - raterField.ratingValue
        Rectangle {
            width: selectedCacheGeocadeField.height
            height: width
            radius: width/2
            border.color: Palette.greenSea()
            color: Palette.white()
        }
    }
}
