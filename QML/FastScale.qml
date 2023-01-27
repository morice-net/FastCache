import QtQuick

import "JavaScript/helper.js" as Helper
import "JavaScript/Palette.js" as Palette

Item {
    z: map.z + 3
    anchors.bottom: parent.bottom;
    anchors.left: parent.left
    anchors.margins: 30
    height: scaleText.height * 2
    width: scaleImage.width

    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]
    property int imageSourceWidth :scaleImage.sourceSize.width

    Image {
        id: scaleImageLeft
        source: "qrc:/Image/scaleEnd.png"
        anchors.bottom: parent.bottom
        anchors.right: scaleImage.left
    }

    Image {
        id: scaleImage
        source: "qrc:/Image/scale.png"
        anchors.bottom: parent.bottom
        anchors.right: scaleImageRight.left
    }

    Image {
        id: scaleImageRight
        source: "qrc:/Image/scaleEnd.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    Text {
        id: scaleText
        color: Palette.black()
        anchors.centerIn: parent
        text: "0 m"
    }

    function updateScale(coord1, coord2) {
        var dist, text, f;
        f = 0;
        dist = Math.round(coord1.distanceTo(coord2));

        if (dist === 0) {
            // not visible
        } else {
            for (var i = 0; i < scaleLengths.length-1; i++) {
                if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                    f = scaleLengths[i] / dist;
                    dist = scaleLengths[i];
                    break;
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i];
                dist = scaleLengths[i];
            }
        }

        text = Helper.formatDistance(dist);
        scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width;
        scaleText.text = text;
    }

}
