import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import "JavaScript/Palette.js" as Palette

Popup {
    id: coordinatesBox
    x:50
    y:50
    background: Rectangle {
        implicitWidth: main.width*0.8
        implicitHeight:main.height*0.8
        color:Palette.turquoise()
        border.color: Palette.turquoise()
        radius: 10
        opacity: 0.5
    }

    ColumnLayout {
        id: buttons
        spacing:5

        Button {
            id:button1
            contentItem: Text {
                text:"DDD°MM.MMM'"
                font.family: localFont.name
                font.pixelSize: 20
                color: Palette.turquoise()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                anchors.fill: parent
                anchors.margins: 5
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 2
                radius: 10
            }
            onClicked: {  }
        }

        Button {
            id:button2
            contentItem: Text {
                text:"DDD.DDDDD°"
                font.family: localFont.name
                font.pixelSize: 20
                color: Palette.turquoise()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                anchors.fill: parent
                anchors.margins: 5
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 2
                radius: 10
            }
            onClicked: {  }
        }

        Button {
            id:button3
            contentItem: Text {
                text:"DDD°MM'SS.SSS''"
                font.family: localFont.name
                font.pixelSize: 20
                color: Palette.turquoise()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                anchors.fill: parent
                anchors.margins: 5
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 2
                radius: 10
            }
            onClicked: {  }
        }
    }

    // first box coordinates.

    Item {
        id:box1
        visible: false

        Button {
            y:coordinatesBox.height/2
            contentItem: Text {
                id:box1ButtonNS
                text:"N"
                font.family: localFont.name
                font.pixelSize: 20
                color: Palette.turquoise()
            }
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 2
                radius: 10
            }
            onClicked: {
                box1ButtonNS.text === "N" ? box1ButtonNS.text="S":box1ButtonNS.text="N"
            }

            TextField {
                id:box1Degrees
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 90;}
                font.family: localFont.name
                font.pixelSize: 20
                anchors.left: box1ButtonNS.right
                anchors.leftMargin:10
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box1Degrees.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box1LabelDegrees
                text: "°"
                font.pixelSize: 20
                anchors.left:box1Degrees.right
                anchors.leftMargin:2
            }

            TextField {
                id:box1Minutes
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pixelSize: 20
                anchors.left: box1LabelDegrees.right
                anchors.leftMargin:4
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box1Minutes.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box1LabelPoint
                text: "."
                font.pixelSize: 20
                anchors.left:box1Minutes.right
                anchors.leftMargin:2
            }

            TextField {
                id:box1Decimal
                maximumLength : 3
                validator: IntValidator{bottom:0 ; top: 999;}
                font.family: localFont.name
                font.pixelSize: 20
                anchors.left: box1LabelPoint.right
                anchors.leftMargin:4
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius:10
                    border.color: box1Decimal.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box1LabelMinute
                text: "'"
                font.pixelSize: 20
                anchors.left:box1Decimal.right
                anchors.leftMargin:2
            }

            Button {
                y:box1ButtonNS.y+box1ButtonNS.height+10
                contentItem: Text {
                    id:box1ButtonEO
                    text:"E"
                    font.family: localFont.name
                    font.pixelSize: 20
                    color: Palette.turquoise()

                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.greenSea()
                    border.width: 2
                    radius: 10
                }
                onClicked: {
                    box1ButtonEO.text === "E" ? box1ButtonEO.text="O":box1ButtonEO.text="E"
                }

                TextField {
                    id:box1Degrees2
                    maximumLength : 3
                    validator: IntValidator {bottom: 0; top: 180;}
                    font.family: localFont.name
                    font.pixelSize: 20
                    anchors.left: box1ButtonEO.right
                    anchors.leftMargin:10
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box1Degrees2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box1LabelDegrees2
                    text: "°"
                    font.pixelSize: 20
                    anchors.left:box1Degrees2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box1Minutes2
                    maximumLength : 2
                    validator: IntValidator {bottom: 0; top: 59;}
                    font.family: localFont.name
                    font.pixelSize: 20
                    anchors.left: box1LabelDegrees2.right
                    anchors.leftMargin:4
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box1Minutes2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box1LabelPoint2
                    text: "."
                    font.pixelSize: 20
                    anchors.left:box1Minutes2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box1Decimal2
                    maximumLength : 3
                    validator: IntValidator{bottom:0 ; top: 999;}
                    font.family: localFont.name
                    font.pixelSize: 20
                    anchors.left: box1LabelPoint2.right
                    anchors.leftMargin:4
                    background: Rectangle {
                        implicitWidth: main.width/8
                        radius:10
                        border.color: box1Decimal2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box1LabelMinute2
                    text: "'"
                    font.pixelSize: 20
                    anchors.left:box1Decimal2.right
                    anchors.leftMargin:2
                }
            }
        }
    }

    // second box coordinates.

    Item {
        id:box2
        visible: true

        Button {
            y:coordinatesBox.height/2
            contentItem: Text {
                id:box2ButtonNS
                text:"N"
                font.family: localFont.name
                font.pixelSize: 20
                color: Palette.turquoise()
            }
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 2
                radius: 10
            }
            onClicked: {
                box2ButtonNS.text === "N" ? box2ButtonNS.text="S":box2ButtonNS.text="N"
            }

            TextField {
                id:box2Degrees
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 90;}
                font.family: localFont.name
                font.pixelSize: 20
                anchors.left: box2ButtonNS.right
                anchors.leftMargin:10
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box2Degrees.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box2LabelPoint
                text: "."
                font.pixelSize: 20
                anchors.left:box2Degrees.right
                anchors.leftMargin:2
            }

            TextField {
                id:box2Decimal
                maximumLength : 5
                validator: IntValidator {bottom: 0; top: 99999;}
                font.family: localFont.name
                font.pixelSize: 20
                anchors.left: box2LabelPoint.right
                anchors.leftMargin:4
                background: Rectangle {
                    implicitWidth: main.width/7
                    radius:10
                    border.color: box2Decimal.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box2LabelDegrees
                text: "°"
                font.pixelSize: 20
                anchors.left:box2Decimal.right
                anchors.leftMargin:2
            }

            Button {
                y:box2ButtonNS.y+box2ButtonNS.height+10
                contentItem: Text {
                    id:box2ButtonEO
                    text:"E"
                    font.family: localFont.name
                    font.pixelSize: 20
                    color: Palette.turquoise()

                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.greenSea()
                    border.width: 2
                    radius: 10
                }
                onClicked: {
                    box2ButtonEO.text === "E" ? box2ButtonEO.text="O":box2ButtonEO.text="E"
                }

                TextField {
                    id:box2Degrees2
                    maximumLength : 3
                    validator: IntValidator {bottom: 0; top: 180;}
                    font.family: localFont.name
                    font.pixelSize: 20
                    anchors.left: box2ButtonEO.right
                    anchors.leftMargin:10
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box2Degrees2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box2LabelPoint2
                    text: "."
                    font.pixelSize: 20
                    anchors.left:box2Degrees2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box2Decimal2
                    maximumLength : 5
                    validator: IntValidator {bottom: 0; top: 99999;}
                    font.family: localFont.name
                    font.pixelSize: 20
                    anchors.left: box2LabelPoint2.right
                    anchors.leftMargin:4
                    background: Rectangle {
                        implicitWidth: main.width/7
                        radius:10
                        border.color: box2Decimal2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box2LabelDegrees2
                    text: "°"
                    font.pixelSize: 20
                    anchors.left:box2Decimal2.right
                    anchors.leftMargin:2
                }

            }
        }
    }
}

