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
                id: box1ButtonNS
                implicitWidth: coordinatesBox.width/10
                text: "N"
                font.pointSize: 18
                onClicked: {
                    box1ButtonNS.text === "N" ? box1ButtonNS.text="S":box1ButtonNS.text="N"
                }
            }

            TextField {
                id: box1Degrees
                onTextChanged: {
                    if(text.length === 2) {
                        box1Minutes.focus = true
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
                    border.color: box1Degrees.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box1Degrees.height*0.8
                    running: box1Degrees.activeFocus
                }
            }

            Label {
                id: box1LabelDegrees
                text: "°"
                font.pointSize: 18
            }

            TextField {
                id: box1Minutes
                onTextChanged: {
                    if(text.length === 2) {
                        box1Decimal.focus = true
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
                    border.color: box1Minutes.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box1Minutes.height*0.8
                    running: box1Minutes.activeFocus
                }
            }

            Label {
                id: box1LabelPoint
                text: "."
                font.pointSize: 18
            }

            TextField {
                id: box1Decimal
                onTextChanged: {
                    if(text.length === 3) {
                        box1Degrees2.focus = true
                    }
                }
                maximumLength : 3
                validator: IntValidator{bottom:0 ; top: 999;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius: 10
                    border.color: box1Decimal.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box1Decimal.height*0.8
                    running: box1Decimal.activeFocus
                }
            }

            Label {
                id: box1LabelMinute
                text: "'"
                font.pointSize: 18
            }
        }

        Row {
            spacing: 10

            FastButton {
                id: box1ButtonEO
                implicitWidth: coordinatesBox.width/10
                text:"E"
                font.pointSize: 18
                onClicked: {
                    box1ButtonEO.text === "E" ? box1ButtonEO.text="O":box1ButtonEO.text="E"
                }
            }

            TextField {
                id: box1Degrees2
                onTextChanged: {
                    if(text.length === 3) {
                        box1Minutes2.focus = true
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
                    border.color: box1Degrees2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box1Degrees2.height*0.8
                    running: box1Degrees2.activeFocus
                }
            }

            Label {
                id: box1LabelDegrees2
                text: "°"
                font.pointSize: 18
            }

            TextField {
                id: box1Minutes2
                onTextChanged: {
                    if(text.length === 2) {
                        box1Decimal2.focus = true
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
                    border.color: box1Minutes2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box1Minutes2.height*0.8
                    running: box1Minutes2.activeFocus
                }
            }

            Label {
                id: box1LabelPoint2
                text: "."
                font.pointSize: 18
            }

            TextField {
                id: box1Decimal2
                maximumLength : 3
                validator: IntValidator{bottom:0 ; top: 999;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius: 10
                    border.color: box1Decimal2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box1Decimal2.height*0.8
                    running: box1Decimal2.activeFocus
                }
            }

            Label {
                id: box1LabelMinute2
                text: "'"
                font.pointSize: 18
            }
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

    function rowWidth() {
        return row.width
    }
}


