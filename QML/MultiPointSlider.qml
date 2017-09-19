import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: multiPointSlider
    width: parent.width - 40
    height: 60
    anchors.horizontalCenter: parent.horizontalCenter


    property int minValue: 1
    property int maxValue: 5

    Rectangle {
        id: slider
        height: 8
        radius: 5
        width: parent.width
        color: Palette.black()
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: point1.width/2

    }

    Rectangle {
        id: point1
        height: 25
        radius: height/2
        width: height
        color: Palette.greenSea()
        anchors.verticalCenter: parent.verticalCenter
        x: -width/2
        MouseArea {
            anchors.fill: parent

            drag {
                target: point1
                minimumX: 0
                minimumY: 0
                maximumX: (slider.width - point1.width)
                maximumY: 0
            }

            onReleased: point1.x = slider.width * (minValue - 1 + Math.round((maxValue + 1) * point1.x / slider.width) / maxValue ) - point1.width/2
        }
    }


    Rectangle {
        id: point2
        height: 25
        radius: height/2
        width: height
        color: Palette.greenSea()
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width - width/2

        MouseArea {
            anchors.fill: parent

            drag {
                target: point2
                minimumX: 0
                minimumY: 0
                maximumX: (slider.width - point2.width)
                maximumY: 0
            }

            onReleased: point2.x = slider.width * (minValue - 1 + Math.round((maxValue + 1) * point2.x / slider.width) / maxValue ) - point2.width/2
        }
    }

    Rectangle {
        height: 8
        x: Math.min(point1.x, point2.x) + point1.width/2
        y: slider.y
        width: Math.abs(point2.x - point1.x)
        color: Palette.greenSea()
    }

    Repeater {
        model: maxValue
        delegate: Rectangle {
            color: Palette.silver()
            width: 1
            height: slider.height
            anchors.verticalCenter: slider.verticalCenter
            x: Math.round(maxValue * index / (maxValue - minValue + 1)) / (maxValue - minValue + 1) * slider.width
        }
    }

    function pointValue(item) {
        return Math.round(maxValue * ((item.x + item.width/2) / slider.width - minValue + 1));
    }

    function pointCurrentMinValue() {
        return Math.min(pointValue(point1), pointValue(point2))
    }

    function pointCurrentMaxValue() {
        return Math.max(pointValue(point1), pointValue(point2))
    }
}
