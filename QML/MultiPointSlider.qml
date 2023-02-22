import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

RangeSlider {
    id: control
    width: parent.width
    from: 1.0
    to: 5.0
    stepSize: 0.5
    snapMode:Slider.SnapAlways
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: main.width*0.8
        implicitHeight: 4
        width: control.availableWidth
        height: 10
        radius: 5
        color: Palette.silver()

        Rectangle {
            x: control.first.visualPosition * parent.width
            width: control.second.visualPosition * parent.width - x
            height: parent.height
            color: Palette.greenSea()
            radius: 5
        }
    }

    first.handle: Rectangle {
        x: control.leftPadding + first.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 20
        radius: 13
        color: Palette.greenSea()
    }

    second.handle: Rectangle {
        x: control.leftPadding + second.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 20
        radius: 13
        color:  Palette.greenSea()
    }

    Label {
        anchors.left: control.left
        anchors.bottom: control.top
        font.pointSize: 15
        font.italic: true
        text: " Min:"+minValueSlider()
        color: Palette.greenSea()

    }

    Label {
        anchors.right: control.right
        anchors.bottom: control.top
        font.pointSize: 15
        font.italic: true
        text: "Max:"+ maxValueSlider()
        color: Palette.greenSea()
    }

    function minValueSlider() {
        return first.value;

    }

    function maxValueSlider() {
        return second.value;
    }
}


