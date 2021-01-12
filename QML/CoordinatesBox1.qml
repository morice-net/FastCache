import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Button {
    contentItem: Text {
        id: box1ButtonNS
        text:"N"
        font.family: localFont.name
        font.pixelSize: 30
        color: Palette.turquoise()
    }
    background: Rectangle {
        implicitWidth: 45
        anchors.fill: parent
        opacity: 0.9
        border.color: Palette.greenSea()
        border.width: 2
        radius: 5
    }
    onClicked: {
        box1ButtonNS.text === "N" ? box1ButtonNS.text="S":box1ButtonNS.text="N"
    }

    TextField {
        id: box1Degrees
        maximumLength : 2
        validator: IntValidator {bottom: 0; top: 90;}
        font.family: localFont.name
        font.pixelSize: 30
        anchors.left: box1ButtonNS.right
        anchors.leftMargin:15
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/10
            radius: 5
            border.color: box1Degrees.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box1LabelDegrees
        text: "°"
        font.pixelSize: 30
        anchors.left:box1Degrees.right
        anchors.leftMargin:2
    }

    TextField {
        id: box1Minutes
        maximumLength : 2
        validator: IntValidator {bottom: 0; top: 59;}
        font.family: localFont.name
        font.pixelSize: 30
        anchors.left: box1LabelDegrees.right
        anchors.leftMargin:4
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/10
            radius: 5
            border.color: box1Minutes.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box1LabelPoint
        text: "."
        font.pixelSize: 30
        anchors.left:box1Minutes.right
        anchors.leftMargin:2
    }

    TextField {
        id: box1Decimal
        maximumLength : 3
        validator: IntValidator{bottom:0 ; top: 999;}
        font.family: localFont.name
        font.pixelSize: 30
        anchors.left: box1LabelPoint.right
        anchors.leftMargin:4
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/8
            radius: 5
            border.color: box1Decimal.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box1LabelMinute
        text: "'"
        font.pixelSize: 30
        anchors.left:box1Decimal.right
        anchors.leftMargin:2
    }

    Button {
        y:box1ButtonNS.y+box1ButtonNS.height+10
        contentItem: Text {
            id: box1ButtonEO
            text:"E"
            font.family: localFont.name
            font.pixelSize: 30
            color: Palette.turquoise()

        }
        background: Rectangle {
            implicitWidth: 45
            anchors.fill: parent
            opacity: 0.9
            border.color: Palette.greenSea()
            border.width: 2
            radius: 5
        }
        onClicked: {
            box1ButtonEO.text === "E" ? box1ButtonEO.text="O":box1ButtonEO.text="E"
        }

        TextField {
            id: box1Degrees2
            maximumLength : 3
            validator: IntValidator {bottom: 0; top: 180;}
            font.family: localFont.name
            font.pixelSize: 30
            anchors.left: box1ButtonEO.right
            anchors.leftMargin:15
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/10
                radius: 5
                border.color: box1Degrees2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box1LabelDegrees2
            text: "°"
            font.pixelSize: 30
            anchors.left:box1Degrees2.right
            anchors.leftMargin:2
        }

        TextField {
            id: box1Minutes2
            maximumLength : 2
            validator: IntValidator {bottom: 0; top: 59;}
            font.family: localFont.name
            font.pixelSize: 30
            anchors.left: box1LabelDegrees2.right
            anchors.leftMargin:4
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/10
                radius: 5
                border.color: box1Minutes2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box1LabelPoint2
            text: "."
            font.pixelSize: 30
            anchors.left:box1Minutes2.right
            anchors.leftMargin:2
        }

        TextField {
            id: box1Decimal2
            maximumLength : 3
            validator: IntValidator{bottom:0 ; top: 999;}
            font.family: localFont.name
            font.pixelSize: 30
            anchors.left: box1LabelPoint2.right
            anchors.leftMargin:4
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/8
                radius: 5
                border.color: box1Decimal2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box1LabelMinute2
            text: "'"
            font.pixelSize: 30
            anchors.left:box1Decimal2.right
            anchors.leftMargin:2
        }
    }

    function  box1Lat(){
        if(box1Degrees.text === "" || box1Minutes.text === "" ||box1Decimal.text === "")
            return ""
        lat = parseFloat( box1Degrees.text) + parseFloat((box1Minutes.text + "." + box1Decimal.text)/60)
        if(lat > 90) return ""
        if(box1ButtonNS.text==="S") lat = -lat
        console.log("Latitude:   " + lat)
        return lat
    }

    function  box1Lon(){
        if(box1Degrees2.text === "" || box1Minutes2.text === "" ||box1Decimal2.text === "")
            return ""
        lon = parseFloat( box1Degrees2.text) + parseFloat((box1Minutes2.text + "." + box1Decimal2.text)/60)
        if(lon > 180) return ""
        if(box1ButtonEO.text==="O") lon = -lon
        console.log("Longitude:   " + lon)
        return lon
    }

    function eraseText() {
        box1Degrees.text=""
        box1Minutes.text=""
        box1Decimal.text=""
        box1Degrees2.text=""
        box1Minutes2.text=""
        box1Decimal2.text=""
    }
}


