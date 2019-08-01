import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

RangeSlider {
    id: control
    width: parent.width
    from: 1
    to: 5
    first.value: 1
    second.value: 5
    stepSize: 0.5
    snapMode:Slider.SnapAlways

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: 11
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
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: Palette.greenSea()
    }

    second.handle: Rectangle {
        x: control.leftPadding + second.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color:  Palette.greenSea()
    }

    Label {
        anchors.left: control.left
        anchors.bottom: control.top
        font.pointSize: 15
        font.italic: true
        text: " Min:"+minValueSlider()

    }

    Label {
        anchors.right: control.right
        anchors.bottom: control.top
        font.pointSize: 15
        font.italic: true
        text: "Max:"+ maxValueSlider()
    }

    function minValueSlider() {
        return first.value;

    }
    function maxValueSlider() {
        return second.value;
    }
}


