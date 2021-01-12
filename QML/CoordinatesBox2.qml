import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Button {
    y: 10
    contentItem: Text {
        id: box2ButtonNS
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
        border.width: 5
        radius: 10
    }
    onClicked: {
        box2ButtonNS.text === "N" ? box2ButtonNS.text="S":box2ButtonNS.text="N"
    }

    TextField {
        id: box2Degrees
        maximumLength : 2
        validator: IntValidator {bottom: 0; top: 90;}
        font.family: localFont.name
        font.pixelSize: 30
        anchors.left: box2ButtonNS.right
        anchors.leftMargin:15
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/10
            radius: 10
            border.color: box2Degrees.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box2LabelPoint
        text: "."
        font.pixelSize: 30
        anchors.left:box2Degrees.right
        anchors.leftMargin:2
    }

    TextField {
        id: box2Decimal
        maximumLength : 5
        validator: IntValidator {bottom: 0; top: 99999;}
        font.family: localFont.name
        font.pixelSize: 30
        anchors.left: box2LabelPoint.right
        anchors.leftMargin:4
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/7
            radius: 10
            border.color: box2Decimal.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box2LabelDegrees
        text: "°"
        font.pixelSize: 30
        anchors.left:box2Decimal.right
        anchors.leftMargin:2
    }

    Button {
        y:box2ButtonNS.y+box2ButtonNS.height+10
        contentItem: Text {
            id: box2ButtonEO
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
            border.width: 5
            radius: 10
        }
        onClicked: {
            box2ButtonEO.text === "E" ? box2ButtonEO.text="O":box2ButtonEO.text="E"
        }

        TextField {
            id: box2Degrees2
            maximumLength : 3
            validator: IntValidator {bottom: 0; top: 180;}
            font.family: localFont.name
            font.pixelSize: 30
            anchors.left: box2ButtonEO.right
            anchors.leftMargin:15
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/10
                radius: 10
                border.color: box2Degrees2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box2LabelPoint2
            text: "."
            font.pixelSize: 30
            anchors.left:box2Degrees2.right
            anchors.leftMargin:2
        }

        TextField {
            id: box2Decimal2
            maximumLength : 5
            validator: IntValidator {bottom: 0; top: 99999;}
            font.family: localFont.name
            font.pixelSize: 30
            anchors.left: box2LabelPoint2.right
            anchors.leftMargin:4
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/7
                radius: 10
                border.color: box2Decimal2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box2LabelDegrees2
            text: "°"
            font.pixelSize: 30
            anchors.left:box2Decimal2.right
            anchors.leftMargin:2
        }
    }

    function  box2Lat(){
        if(box2Degrees.text === "" || box2Decimal.text === "")
            return ""
        lat = box2Degrees.text + "." + box2Decimal.text
        if(lat > 90) return ""
        if(box2ButtonNS.text==="S") lat = -lat
        console.log("Latitude:   " + lat)
        return lat
    }

    function  box2Lon(){
        if(box2Degrees2.text === "" ||box2Decimal2.text === "")
            return ""
        lon = box2Degrees2.text + "." + box2Decimal2.text
        if(lon > 180) return ""
        if(box2ButtonEO.text==="O") lon = -lon
        console.log("Longitude:   " + lon)
        return lon
    }

    function eraseText() {
        box2Degrees.text=""
        box2Decimal.text=""
        box2Degrees2.text=""
        box2Decimal2.text=""
    }
}
