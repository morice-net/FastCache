import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: coordinatesBox
    x:20
    y:20
    backgroundWidth: parent.width*0.9
    backgroundHeight: parent.height*0.8
    backgroundRadius: 10
    backgroundOpacity: 0.9

    // The box gives latitude and longitude in resultLat and resultLon.
    property double resultLat: 0.0
    property double resultLon: 0.0
    property double lat: 0.0
    property double lon: 0.0

    signal  okCoordinatesClicked

    ComboBox {
        id: gpsFormatCombo
        x: 20
        y: 80
        width: parent.width*0.9
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
            leftPadding: 20
            text: gpsFormatCombo.displayText
            font.family: localFont.name
            font.pointSize: 15
            color: Palette.turquoise()
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 80
            border.color: Palette.silver()
            border.width: 5
            radius: 10
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
        x:20
        y: parent.height*0.4

        CoordinatesBox1 {
            id: coordinatesBox1
        }
    }

    // second box coordinates.
    Item {
        id: box2
        visible: false
        x: 20
        y: parent.height*0.4

        CoordinatesBox2 {
            id: coordinatesBox2
        }
    }

    // third box coordinates.
    Item {
        id: box3
        visible: false
        x: 20
        y: parent.height*0.4

        CoordinatesBox3 {
            id: coordinatesBox3
        }

    }

    //////////////////////////////////////////////////////////////////////
    ///        OK
    //////////////////////////////////////////////////////////////////////

    Button {
        id: goButton
        text: qsTr("Ok")
        x: 20
        y: parent.height*0.7
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

            if (gpsFormatCombo.currentIndex === 2)
                if(coordinatesBox3.box3Lat() !== "" && coordinatesBox3.box3Lon() !== "") {
                    resultLat =  coordinatesBox3.box3Lat()
                    resultLon =  coordinatesBox3.box3Lon()
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
        x: 40 +goButton.width
        y: parent.height*0.7
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
            coordinatesBox3.eraseText()
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}

