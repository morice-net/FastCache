import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Button {
    y: 10
    contentItem: Text {
        id: box3ButtonNS
        text: "N"
        font.family: localFont.name
        font.pixelSize: 35
        color: Palette.turquoise()
    }
    background: Rectangle {
        anchors.fill: parent
        opacity: 0.9
        border.color: Palette.greenSea()
        border.width: 5
        radius: 10
    }
    onClicked: {
        box3ButtonNS.text === "N" ? box3ButtonNS.text="S":box3ButtonNS.text="N"
    }

    TextField {
        id: box3Degrees
        maximumLength : 3
        validator: IntValidator {bottom: 0; top: 90;}
        font.family: localFont.name
        font.pixelSize: 35
        anchors.left: box3ButtonNS.right
        anchors.leftMargin: 15
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/10
            radius: 10
            border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box3LabelDegrees
        text: "°"
        font.pixelSize: 35
        anchors.left: box3Degrees.right
        anchors.leftMargin: 2
    }

    TextField {
        id: box3Minutes
        maximumLength : 2
        validator: IntValidator {bottom: 0; top: 59;}
        font.family: localFont.name
        font.pixelSize: 35
        anchors.left: box3LabelDegrees.right
        anchors.leftMargin: 4
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/10
            radius: 10
            border.color: box3Minutes.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box3LabelMinutes
        text: "'"
        font.pixelSize: 35
        anchors.left: box3Minutes.right
        anchors.leftMargin: 2
    }

    TextField {
        id: box3Seconds
        maximumLength : 2
        validator: IntValidator {bottom: 0; top: 59;}
        font.family: localFont.name
        font.pixelSize: 35
        anchors.left: box3LabelMinutes.right
        anchors.leftMargin: 10
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/10
            radius: 10
            border.color: box3Seconds.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box3LabelPoint
        text: "."
        font.pixelSize: 35
        anchors.left: box3Seconds.right
        anchors.leftMargin: 2
    }

    TextField {
        id: box3Decimal
        maximumLength : 3
        validator: IntValidator {bottom: 0; top: 999;}
        font.family: localFont.name
        font.pixelSize: 35
        anchors.left: box3LabelPoint.right
        anchors.leftMargin: 4
        color: Palette.greenSea()
        background: Rectangle {
            implicitWidth: main.width/8
            radius: 10
            border.color: box3Decimal.focus ? Palette.black() :Palette.turquoise()
        }
    }

    Label {
        id: box3LabelSeconds
        text: "''"
        font.pixelSize: 35
        anchors.left: box3Decimal.right
        anchors.leftMargin: 2
    }

    Button {
        y: box3ButtonNS.y + box3ButtonNS.height + 50
        contentItem: Text {
            id: box3ButtonEO
            text:"E"
            font.family: localFont.name
            font.pixelSize: 35
            color: Palette.turquoise()
        }
        background: Rectangle {
            anchors.fill: parent
            opacity: 0.9
            border.color: Palette.greenSea()
            border.width: 5
            radius: 10
        }
        onClicked: {
            box3ButtonEO.text === "E" ? box3ButtonEO.text="O":box3ButtonEO.text="E"
        }

        TextField {
            id: box3Degrees2
            maximumLength : 3
            validator: IntValidator {bottom: 0; top: 180;}
            font.family: localFont.name
            font.pixelSize: 35
            anchors.left: box3ButtonEO.right
            anchors.leftMargin: 15
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/10
                radius: 10
                border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box3LabelDegrees2
            text: "°"
            font.pixelSize: 35
            anchors.left: box3Degrees2.right
            anchors.leftMargin: 2
        }

        TextField {
            id: box3Minutes2
            maximumLength : 2
            validator: IntValidator {bottom: 0; top: 59;}
            font.family: localFont.name
            font.pixelSize: 35
            anchors.left: box3LabelDegrees2.right
            anchors.leftMargin: 4
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/10
                radius: 10
                border.color: box3Minutes2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box3LabelMinutes2
            text: "'"
            font.pixelSize: 35
            anchors.left: box3Minutes2.right
            anchors.leftMargin: 2
        }

        TextField {
            id: box3Seconds2
            maximumLength : 2
            validator: IntValidator {bottom: 0; top: 59;}
            font.family: localFont.name
            font.pixelSize: 35
            anchors.left: box3LabelMinutes2.right
            anchors.leftMargin: 10
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/10
                radius: 10
                border.color: box3Seconds2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box3LabelPoint2
            text: "."
            font.pixelSize: 35
            anchors.left: box3Seconds2.right
            anchors.leftMargin: 2
        }

        TextField {
            id: box3Decimal2
            maximumLength : 3
            validator: IntValidator {bottom: 0; top: 999;}
            font.family: localFont.name
            font.pixelSize: 35
            anchors.left: box3LabelPoint2.right
            anchors.leftMargin: 4
            color: Palette.greenSea()
            background: Rectangle {
                implicitWidth: main.width/8
                radius: 10
                border.color: box3Decimal2.focus ? Palette.black() :Palette.turquoise()
            }
        }

        Label {
            id: box3LabelSeconds2
            text: "''"
            font.pixelSize: 35
            anchors.left: box3Decimal2.right
            anchors.leftMargin: 2
        }
    }

    function  box3Lat(){
        if(box3Degrees.text === "" || box3Minutes.text === "" || box3Seconds.text === "" || box3Decimal.text === "")
            return ""
        lat = parseFloat( box3Degrees.text) + parseFloat(box3Minutes.text)/60 + parseFloat((box3Seconds.text + "." + box3Decimal.text)/3600)
        if(lat > 90) return ""
        if(box3ButtonNS.text==="S") lat = -lat
        console.log("Latitude:   " + lat)
        return lat
    }

    function  box3Lon(){
        if(box3Degrees2.text === "" || box3Minutes2.text === "" || box3Seconds2.text === "" || box3Decimal2.text === "")
            return ""
        lon = parseFloat( box3Degrees2.text) + parseFloat(box3Minutes2.text)/60 + parseFloat((box3Seconds2.text + "." + box3Decimal2.text)/3600)
        if(lon > 180) return ""
        if(box3ButtonEO.text==="O") lon = -lon
        console.log("Longitude:   " + lon)
        return lon
    }

    function eraseText() {
        box3Degrees.text=""
        box3Minutes.text=""
        box3Seconds.text=""
        box3Decimal.text=""
        box3Degrees2.text=""
        box3Minutes2.text=""
        box3Seconds2.text=""
        box3Decimal2.text=""
    }
}
