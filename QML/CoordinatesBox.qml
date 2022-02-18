import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: coordinatesBox
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
        y: 80
        anchors.horizontalCenter: parent.horizontalCenter
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
    CoordinatesBox1 {
        id: box1
        visible: true
        x: (coordinatesBox.width - box1.rowWidth())/2
        y: parent.height*0.4
    }

    // second box coordinates.
    CoordinatesBox2 {
        id: box2
        visible: false
        x: (coordinatesBox.width - box2.rowWidth())/2
        y: parent.height*0.4
    }

    // third box coordinates.
    CoordinatesBox3 {
        id: box3
        visible: false
        x: (coordinatesBox.width - box3.rowWidth())/2
        y: parent.height*0.4
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height*0.7
        spacing: 60

        // button OK
        FastButton {
            id: goButton
            text: "Ok"
            font.pointSize: 18
            onClicked: {
                if (gpsFormatCombo.currentIndex == 0)
                    if(box1.box1Lat() !== "" && box1.box1Lon()  !== "") {
                        resultLat =  box1.box1Lat()
                        resultLon =  box1.box1Lon()
                        main.state = "coordinates"
                        // signal
                        okCoordinatesClicked()
                        coordinatesBox.close()
                    }

                if (gpsFormatCombo.currentIndex == 1)
                    if(box2.box2Lat() !== "" && box2.box2Lon()  !== "") {
                        resultLat =  box2.box2Lat()
                        resultLon =  box2.box2Lon()
                        main.state = "coordinates"
                        // signal
                        okCoordinatesClicked()
                        coordinatesBox.close()
                    }

                if (gpsFormatCombo.currentIndex === 2)
                    if(box3.box3Lat() !== "" && box3.box3Lon() !== "") {
                        resultLat =  box3.box3Lat()
                        resultLon =  box3.box3Lon()
                        main.state = "coordinates"
                        // signal
                        okCoordinatesClicked()
                        coordinatesBox.close()
                    }
            }
        }

        // erase button
        FastButton {
            id: clearButton
            font.pointSize: 18
            text: "Effacer"
            onClicked: {
                box1.eraseText()
                box2.eraseText()
                box3.eraseText()
            }
        }

    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}

