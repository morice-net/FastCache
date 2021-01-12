import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: coordinatesBox

    // The box gives latitude and longitude in resultLat and resultLon.
    property double resultLat: 0.0
    property double resultLon: 0.0
    property double lat: 0.0
    property double lon: 0.0

    signal  okCoordinatesClicked

    ComboBox {
        id: gpsFormatCombo
        y: 80
        width: parent.width - 20
        model: ["DDD°MM.MMM'", "DDD.DDDDD°", "DDD°MM'SS.SSS''"]
        delegate: ItemDelegate {
            width: gpsFormatCombo.width
            contentItem: Text {
                text: modelData
                color: Palette.turquoise()
                font.family: localFont.name
                font.pointSize: 15
                verticalAlignment: Text.AlignVCenter
            }
            highlighted: gpsFormatCombo.highlightedIndex === index
        }
        contentItem: Text {
            leftPadding: 10
            text: gpsFormatCombo.displayText
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.turquoise()
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 50
            border.color: Palette.silver()
            border.width: 1
            radius: 5
        }

        onCurrentIndexChanged: {
            box1.visible = false
            box2.visible = false
            box3.visible = false
            if (currentIndex == 1) {
                box2.visible = true
            } else if (currentIndex == 2) {
                box3.visible = true
            } else {
                box1.visible = true
            }
        }
    }

    // first box coordinates.
    Item {
        id: box1
        visible: true
        width: parent.width - 20
        anchors.top: gpsFormatCombo.bottom
        anchors.margins: 10
        anchors.topMargin: 30

        CoordinatesBox1 {
            id: coordinatesBox1
        }
    }

    // second box coordinates.
    Item {
        id: box2
        visible: false
        width: parent.width - 20
        anchors.top: gpsFormatCombo.bottom
        anchors.margins: 10

        CoordinatesBox2 {
            id: coordinatesBox2
        }
    }

    // third box coordinates.
    Item {
        id: box3
        visible: false
        width: parent.width - 20
        anchors.top: gpsFormatCombo.bottom
        anchors.margins: 10

        Button {
            y: 10
            contentItem: Text {
                id: box3ButtonNS
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
                box3ButtonNS.text === "N" ? box3ButtonNS.text="S":box3ButtonNS.text="N"
            }

            TextField {
                id: box3Degrees
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 90;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3ButtonNS.right
                anchors.leftMargin:15
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 5
                    border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: box3LabelDegrees
                text: "°"
                font.pixelSize: 30
                anchors.left:box3Degrees.right
                anchors.leftMargin:2
            }

            TextField {
                id: box3Minutes
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3LabelDegrees.right
                anchors.leftMargin:4
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 5
                    border.color: box3Minutes.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: box3LabelMinutes
                text: "'"
                font.pixelSize: 30
                anchors.left:box3Minutes.right
                anchors.leftMargin:2
            }

            TextField {
                id: box3Seconds
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3LabelMinutes.right
                anchors.leftMargin:10
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius: 5
                    border.color: box3Seconds.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: box3LabelPoint
                text: "."
                font.pixelSize: 30
                anchors.left:box3Seconds.right
                anchors.leftMargin:2
            }

            TextField {
                id: box3Decimal
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 999;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3LabelPoint.right
                anchors.leftMargin:4
                color: Palette.greenSea()
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius: 5
                    border.color: box3Decimal.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: box3LabelSeconds
                text: "''"
                font.pixelSize: 30
                anchors.left:box3Decimal.right
                anchors.leftMargin:2
            }

            Button {
                y:box3ButtonNS.y+box3ButtonNS.height+10
                contentItem: Text {
                    id: box3ButtonEO
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
                    box3ButtonEO.text === "E" ? box3ButtonEO.text="O":box3ButtonEO.text="E"
                }

                TextField {
                    id: box3Degrees2
                    maximumLength : 3
                    validator: IntValidator {bottom: 0; top: 180;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3ButtonEO.right
                    anchors.leftMargin:15
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius: 5
                        border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id: box3LabelDegrees2
                    text: "°"
                    font.pixelSize: 30
                    anchors.left:box3Degrees2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id: box3Minutes2
                    maximumLength : 2
                    validator: IntValidator {bottom: 0; top: 59;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3LabelDegrees2.right
                    anchors.leftMargin:4
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius: 5
                        border.color: box3Minutes2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id: box3LabelMinutes2
                    text: "'"
                    font.pixelSize: 30
                    anchors.left:box3Minutes2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id: box3Seconds2
                    maximumLength : 2
                    validator: IntValidator {bottom: 0; top: 59;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3LabelMinutes2.right
                    anchors.leftMargin:10
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius: 5
                        border.color: box3Seconds2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id: box3LabelPoint2
                    text: "."
                    font.pixelSize: 30
                    anchors.left:box3Seconds2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id: box3Decimal2
                    maximumLength : 3
                    validator: IntValidator {bottom: 0; top: 999;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3LabelPoint2.right
                    anchors.leftMargin:4
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/8
                        radius: 5
                        border.color: box3Decimal2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id: box3LabelSeconds2
                    text: "''"
                    font.pixelSize: 30
                    anchors.left:box3Decimal2.right
                    anchors.leftMargin:2
                }

            }
        }
    }

    //////////////////////////////////////////////////////////////////////
    ///        OK
    //////////////////////////////////////////////////////////////////////

    Button {
        id: goButton
        text: qsTr("Ok")
        x: 0.5 * coordinatesBox.width
        y: parent.height - height - 10
        contentItem: Text {
            text: goButton.text
            font: goButton.font
            opacity: enabled ? 1.0 : 0.3
            color: Palette.greenSea()
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

        }
        background: Rectangle {
            anchors.fill: parent
            opacity: 0.9
            color: Palette.white()
            border.color: Palette.greenSea()
            border.width: 1
            radius: 5
        }
        font.family: localFont.name
        onClicked: {
            if (gpsFormatCombo.currentIndex == 0)
                if(coordinatesBox1.box1Lat() !== "" && coordinatesBox1.box1Lon()  !== "") {
                    resultLat =  coordinatesBox1.box1Lat()
                    resultLon =  coordinatesBox1.box1Lon()
                    main.state = "coordinates"
                    // signal
                    okCoordinatesClicked()
                    coordinatesBox.close()
                }

            if (gpsFormatCombo.currentIndex == 1)
                if(coordinatesBox2.box2Lat() !== "" && coordinatesBox2.box2Lon()  !== "") {
                    resultLat =  coordinatesBox2.box2Lat()
                    resultLon =  coordinatesBox2.box2Lon()
                    main.state = "coordinates"
                    // signal
                    okCoordinatesClicked()
                    coordinatesBox.close()
                }

            if (gpsFormatCombo.currentIndex == 2)
                if(box3Lat() !== "" && box3Lon() !== "") {
                    resultLat =  box3Lat()
                    resultLon =  box3Lon()
                    main.state = "coordinates"
                    // signal
                    okCoordinatesClicked()
                    coordinatesBox.close()
                }
        }
    }

    //////////////////////////////////////////////////////////////////////
    ///        Erase button
    //////////////////////////////////////////////////////////////////////
    Button {
        id: clearButton
        x: 0.65 * coordinatesBox.width
        y: parent.height - height - 10
        text: qsTr("Effacer")
        contentItem: Text {
            text: clearButton.text
            font: clearButton.font
            opacity: enabled ? 1.0 : 0.3
            color: Palette.greenSea()
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

        }
        background: Rectangle {
            anchors.fill: parent
            opacity: 0.9
            color: Palette.white()
            border.color: Palette.greenSea()
            border.width: 1
            radius: 5
        }
        font.family: localFont.name
        onClicked: {
            coordinatesBox1.eraseText()
            coordinatesBox2.eraseText()

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

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}

