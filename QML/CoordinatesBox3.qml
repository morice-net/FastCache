import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Item {

    Column {
        spacing: 20

        Row {
            id: row
            spacing: 10

            FastButton {
                id: box3ButtonNS
                implicitWidth: coordinatesBox.width/10
                text: "N"
                font.pointSize: 18
                onClicked: {
                    box3ButtonNS.text === "N" ? box3ButtonNS.text="S":box3ButtonNS.text="N"
                }
            }

            TextField {
                id: box3Degrees
                onTextChanged: {
                    if(text.length === 2) {
                        box3Minutes.focus = true
                    }
                }
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 90;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 10
                    border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Degrees.height*0.8
                    running: box3Degrees.activeFocus
                }
            }

            Label {
                id: box3LabelDegrees
                text: "°"
                font.pointSize: 18
            }

            TextField {
                id: box3Minutes
                onTextChanged: {
                    if(text.length === 2) {
                        box3Seconds.focus = true
                    }
                }
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 10
                    border.color: box3Minutes.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Minutes.height*0.8
                    running: box3Minutes.activeFocus
                }
            }

            Label {
                id: box3LabelMinutes
                text: "'"
                font.pointSize: 18
            }

            TextField {
                id: box3Seconds
                onTextChanged: {
                    if(text.length === 2) {
                        box3Decimal.focus = true
                    }
                }
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 10
                    border.color: box3Seconds.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Seconds.height*0.8
                    running: box3Seconds.activeFocus
                }
            }

            Label {
                id: box3LabelPoint
                text: "."
                font.pointSize: 18
            }

            TextField {
                id: box3Decimal
                onTextChanged: {
                    if(text.length === 3) {
                        box3Degrees2.focus = true
                    }
                }
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 999;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius: 10
                    border.color: box3Decimal.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Decimal.height*0.8
                    running: box3Decimal.activeFocus
                }
            }

            Label {
                id: box3LabelSeconds
                text: "''"
                font.pointSize: 18
            }
        }

        Row {
            spacing: 10

            FastButton {
                id: box3ButtonEO
                implicitWidth: coordinatesBox.width/10
                font.pointSize: 18
                text:"E"
                onClicked: {
                    box3ButtonEO.text === "E" ? box3ButtonEO.text="O":box3ButtonEO.text="E"
                }
            }

            TextField {
                id: box3Degrees2
                onTextChanged: {
                    if(text.length === 3) {
                        box3Minutes2.focus = true
                    }
                }
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 180;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 10
                    border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Degrees2.height*0.8
                    running: box3Degrees2.activeFocus
                }
            }

            Label {
                id: box3LabelDegrees2
                text: "°"
                font.pointSize: 18
            }

            TextField {
                id: box3Minutes2
                onTextChanged: {
                    if(text.length === 2) {
                        box3Seconds2.focus = true
                    }
                }
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 10
                    border.color: box3Minutes2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Minutes2.height*0.8
                    running: box3Minutes2.activeFocus
                }
            }

            Label {
                id: box3LabelMinutes2
                text: "'"
                font.pointSize: 18
            }

            TextField {
                id: box3Seconds2
                onTextChanged: {
                    if(text.length === 2) {
                        box3Decimal2.focus = true
                    }
                }
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 10
                    border.color: box3Seconds2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Seconds2.height*0.8
                    running: box3Seconds2.activeFocus
                }
            }

            Label {
                id: box3LabelPoint2
                text: "."
                font.pointSize: 18
            }

            TextField {
                id: box3Decimal2
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 999;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius: 10
                    border.color: box3Decimal2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box3Decimal2.height*0.8
                    running: box3Decimal2.activeFocus
                }
            }

            Label {
                id: box3LabelSeconds2
                text: "''"
                font.pointSize: 18
            }
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

    function rowWidth() {
        return row.width
    }
}
