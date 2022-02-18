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
                id: box2ButtonNS
                implicitWidth: coordinatesBox.width/10
                text: "N"
                font.pointSize: 18
                onClicked: {
                    box2ButtonNS.text === "N" ? box2ButtonNS.text="S":box2ButtonNS.text="N"
                }
            }

            TextField {
                id: box2Degrees
                onTextChanged: {
                    if(text.length === 2) {
                        box2Decimal.focus = true
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
                    border.color: box2Degrees.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box2Degrees.height*0.8
                    running: box2Degrees.activeFocus
                }
            }

            Label {
                id: box2LabelPoint
                text: "."
                font.pointSize: 18
            }

            TextField {
                id: box2Decimal
                onTextChanged: {
                    if(text.length === 5) {
                        box2Degrees2.focus = true
                    }
                }
                maximumLength : 5
                validator: IntValidator {bottom: 0; top: 99999;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/7
                    radius: 10
                    border.color: box2Decimal.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box2Decimal.height*0.8
                    running: box2Decimal.activeFocus
                }
            }

            Label {
                id: box2LabelDegrees
                text: "°"
                font.pointSize: 18
            }
        }

        Row {
            spacing: 10

            FastButton {
                id: box2ButtonEO
                implicitWidth: coordinatesBox.width/10
                text: "E"
                font.pointSize: 18
                onClicked: {
                    box2ButtonEO.text === "E" ? box2ButtonEO.text="O":box2ButtonEO.text="E"
                }
            }

            TextField {
                id: box2Degrees2
                onTextChanged: {
                    if(text.length === 3) {
                        box2Decimal2.focus = true
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
                    border.color: box2Degrees2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box2Degrees2.height*0.8
                    running: box2Degrees2.activeFocus
                }
            }

            Label {
                id: box2LabelPoint2
                text: "."
                font.pointSize: 18
            }

            TextField {
                id: box2Decimal2
                maximumLength : 5
                validator: IntValidator {bottom: 0; top: 99999;}
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/7
                    radius: 10
                    border.color: box2Decimal2.focus ? Palette.black() :Palette.turquoise()
                }
                cursorDelegate : CursorRectangle {
                    height : box2Decimal2.height*0.8
                    running: box2Decimal2.activeFocus
                }
            }

            Label {
                id: box2LabelDegrees2
                text: "°"
                font.pointSize: 18
            }
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

    function rowWidth() {
        return row.width
    }
}
