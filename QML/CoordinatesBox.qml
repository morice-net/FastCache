import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtPositioning 5.3

import "JavaScript/Palette.js" as Palette

Popup {
    id: coordinatesBox

    property double lat:0.0
    property double lon:0.0

    x:50
    y:50
    background: Rectangle {
        implicitWidth: main.width*0.65
        implicitHeight:main.height*0.4
        color:Palette.turquoise()
        border.color: Palette.turquoise()
        radius: 10
        opacity: 0.8
    }

    ColumnLayout {
        id: buttons
        spacing:5

        Button {
            id:button1
            contentItem: Text {
                text:"DDD°MM.MMM'"
                font.family: localFont.name
                font.pixelSize: 30
                color: Palette.turquoise()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                id:back1
                anchors.fill: parent
                anchors.margins: 5
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 1
                radius: 10
            }
            onClicked: {
                back1.border.width = 5
                back2.border.width = 1
                back3.border.width = 1
                box1.visible = true ;
                box2.visible = false ;
                box3.visible = false ;
            }
        }

        Button {
            id:button2
            contentItem: Text {
                text:"DDD.DDDDD°"
                font.family: localFont.name
                font.pixelSize: 30
                color: Palette.turquoise()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                id:back2
                anchors.fill: parent
                anchors.margins: 5
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 1
                radius: 10
            }
            onClicked: {
                back1.border.width = 1
                back2.border.width = 5
                back3.border.width = 1
                box1.visible = false ;
                box2.visible = true ;
                box3.visible = false ;
            }
        }

        Button {
            id:button3
            contentItem: Text {
                text:"DDD°MM'SS.SSS''"
                font.family: localFont.name
                font.pixelSize: 30
                color: Palette.turquoise()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                id:back3
                anchors.fill: parent
                anchors.margins: 5
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 1
                radius: 10
            }
            onClicked: {
                back1.border.width = 1
                back2.border.width = 1
                back3.border.width = 5
                box1.visible = false ;
                box2.visible = false ;
                box3.visible = true ;
            }
        }
    }

    // first box coordinates.

    Item {
        id:box1
        visible: false

        Button {
            y:button3.y+button3.height+10
            contentItem: Text {
                id:box1ButtonNS
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
                font.pixelSize: 30
                anchors.left: box1ButtonNS.right
                anchors.leftMargin:15
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box1Degrees.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box1LabelDegrees
                text: "°"
                font.pixelSize: 30
                anchors.left:box1Degrees.right
                anchors.leftMargin:2
            }

            TextField {
                id:box1Minutes
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pixelSize: 30
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
                font.pixelSize: 30
                anchors.left:box1Minutes.right
                anchors.leftMargin:2
            }

            TextField {
                id:box1Decimal
                maximumLength : 3
                validator: IntValidator{bottom:0 ; top: 999;}
                font.family: localFont.name
                font.pixelSize: 30
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
                font.pixelSize: 30
                anchors.left:box1Decimal.right
                anchors.leftMargin:2
            }

            Button {
                y:box1ButtonNS.y+box1ButtonNS.height+10
                contentItem: Text {
                    id:box1ButtonEO
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
                    font.pixelSize: 30
                    anchors.left: box1ButtonEO.right
                    anchors.leftMargin:15
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box1Degrees2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box1LabelDegrees2
                    text: "°"
                    font.pixelSize: 30
                    anchors.left:box1Degrees2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box1Minutes2
                    maximumLength : 2
                    validator: IntValidator {bottom: 0; top: 59;}
                    font.family: localFont.name
                    font.pixelSize: 30
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
                    font.pixelSize: 30
                    anchors.left:box1Minutes2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box1Decimal2
                    maximumLength : 3
                    validator: IntValidator{bottom:0 ; top: 999;}
                    font.family: localFont.name
                    font.pixelSize: 30
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
                    font.pixelSize: 30
                    anchors.left:box1Decimal2.right
                    anchors.leftMargin:2
                }

                Button {
                    y:box1ButtonEO.y+box1ButtonEO.height+40
                    contentItem: Text {
                        id:box1ButtonOK
                        text:"OK"
                        font.family: localFont.name
                        font.pixelSize: 30
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
                        if(box1Lat() !== "" && box1Lon()  !== "") {
                            coordinatesBox.close()
                            main.state = "coordinates"
                            cachesNear.latPoint = box1Lat()
                            cachesNear.lonPoint = box1Lon()
                            cachesNear.distance = 100000
                            cachesNear.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),
                                                          createFilterExcludeCachesFound(),createFilterExcludeCachesArchived(),
                                                          createFilterKeywordDiscoverOwner() , userInfo.name )
                            cachesNear.sendRequest(connector.tokenKey)

                            fastMap.mapItem.center =QtPositioning.coordinate(box1Lat() , box1Lon())
                        }
                    }
                }

                Button {
                    x:coordinatesBox.width/2
                    y:box1ButtonEO.y+box1ButtonEO.height+40
                    contentItem: Text {
                        id:box1ButtonDel
                        text:"Effacer"
                        font.family: localFont.name
                        font.pixelSize: 30
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
                        box1Degrees.text=""
                        box1Minutes.text=""
                        box1Decimal.text=""
                        box1Degrees2.text=""
                        box1Minutes2.text=""
                        box1Decimal2.text=""

                    }
                }
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

    // second box coordinates.

    Item {
        id:box2
        visible: false

        Button {
            y:button3.y+button3.height+10
            contentItem: Text {
                id:box2ButtonNS
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
                font.pixelSize: 30
                anchors.left: box2ButtonNS.right
                anchors.leftMargin:15
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box2Degrees.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box2LabelPoint
                text: "."
                font.pixelSize: 30
                anchors.left:box2Degrees.right
                anchors.leftMargin:2
            }

            TextField {
                id:box2Decimal
                maximumLength : 5
                validator: IntValidator {bottom: 0; top: 99999;}
                font.family: localFont.name
                font.pixelSize: 30
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
                font.pixelSize: 30
                anchors.left:box2Decimal.right
                anchors.leftMargin:2
            }

            Button {
                y:box2ButtonNS.y+box2ButtonNS.height+10
                contentItem: Text {
                    id:box2ButtonEO
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
                    font.pixelSize: 30
                    anchors.left: box2ButtonEO.right
                    anchors.leftMargin:15
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box2Degrees2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box2LabelPoint2
                    text: "."
                    font.pixelSize: 30
                    anchors.left:box2Degrees2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box2Decimal2
                    maximumLength : 5
                    validator: IntValidator {bottom: 0; top: 99999;}
                    font.family: localFont.name
                    font.pixelSize: 30
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
                    font.pixelSize: 30
                    anchors.left:box2Decimal2.right
                    anchors.leftMargin:2
                }

                Button {
                    y:box2ButtonEO.y+box2ButtonEO.height+40
                    contentItem: Text {
                        id:box2ButtonOK
                        text:"OK"
                        font.family: localFont.name
                        font.pixelSize: 30
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
                        if(box2Lat() !== "" && box2Lon()  !== "") {
                            coordinatesBox.close()
                            main.state = "coordinates"
                            cachesNear.latPoint = box2Lat()
                            cachesNear.lonPoint = box2Lon()
                            cachesNear.distance = 100000
                            cachesNear.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),
                                                          createFilterExcludeCachesFound(),createFilterExcludeCachesArchived(),
                                                          createFilterKeywordDiscoverOwner() , userInfo.name )
                            cachesNear.sendRequest(connector.tokenKey)

                            fastMap.mapItem.center =QtPositioning.coordinate(box2Lat() , box2Lon())
                        }
                    }
                }

                Button {
                    x:coordinatesBox.width/2
                    y:box2ButtonEO.y+box2ButtonEO.height+40
                    contentItem: Text {
                        id:box2ButtonDel
                        text:"Effacer"
                        font.family: localFont.name
                        font.pixelSize: 30
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
                        box2Degrees.text=""
                        box2Decimal.text=""
                        box2Degrees2.text=""
                        box2Decimal2.text=""
                    }
                }

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

    // third box coordinates.

    Item {
        id:box3
        visible: false

        Button {
            y:button3.y+button3.height+10
            contentItem: Text {
                id:box3ButtonNS
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
                radius: 10
            }
            onClicked: {
                box3ButtonNS.text === "N" ? box3ButtonNS.text="S":box3ButtonNS.text="N"
            }

            TextField {
                id:box3Degrees
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 90;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3ButtonNS.right
                anchors.leftMargin:15
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box3LabelDegrees
                text: "°"
                font.pixelSize: 30
                anchors.left:box3Degrees.right
                anchors.leftMargin:2
            }

            TextField {
                id:box3Minutes
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3LabelDegrees.right
                anchors.leftMargin:4
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box3Minutes.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box3LabelMinutes
                text: "'"
                font.pixelSize: 30
                anchors.left:box3Minutes.right
                anchors.leftMargin:2
            }



            TextField {
                id:box3Seconds
                maximumLength : 2
                validator: IntValidator {bottom: 0; top: 59;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3LabelMinutes.right
                anchors.leftMargin:10
                background: Rectangle {
                    implicitWidth: main.width/10
                    radius:10
                    border.color: box3Seconds.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box3LabelPoint
                text: "."
                font.pixelSize: 30
                anchors.left:box3Seconds.right
                anchors.leftMargin:2
            }

            TextField {
                id:box3Decimal
                maximumLength : 3
                validator: IntValidator {bottom: 0; top: 999;}
                font.family: localFont.name
                font.pixelSize: 30
                anchors.left: box3LabelPoint.right
                anchors.leftMargin:4
                background: Rectangle {
                    implicitWidth: main.width/8
                    radius:10
                    border.color: box3Decimal.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id:box3LabelSeconds
                text: "''"
                font.pixelSize: 30
                anchors.left:box3Decimal.right
                anchors.leftMargin:2
            }
            Button {
                y:box3ButtonNS.y+box3ButtonNS.height+10
                contentItem: Text {
                    id:box3ButtonEO
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
                    radius: 10
                }
                onClicked: {
                    box3ButtonEO.text === "E" ? box3ButtonEO.text="O":box3ButtonEO.text="E"
                }

                TextField {
                    id:box3Degrees2
                    maximumLength : 3
                    validator: IntValidator {bottom: 0; top: 180;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3ButtonEO.right
                    anchors.leftMargin:15
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box3Degrees2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box3LabelDegrees2
                    text: "°"
                    font.pixelSize: 30
                    anchors.left:box3Degrees2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box3Minutes2
                    maximumLength : 2
                    validator: IntValidator {bottom: 0; top: 59;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3LabelDegrees2.right
                    anchors.leftMargin:4
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box3Minutes2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box3LabelMinutes2
                    text: "'"
                    font.pixelSize: 30
                    anchors.left:box3Minutes2.right
                    anchors.leftMargin:2
                }



                TextField {
                    id:box3Seconds2
                    maximumLength : 2
                    validator: IntValidator {bottom: 0; top: 59;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3LabelMinutes2.right
                    anchors.leftMargin:10
                    background: Rectangle {
                        implicitWidth: main.width/10
                        radius:10
                        border.color: box3Seconds2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box3LabelPoint2
                    text: "."
                    font.pixelSize: 30
                    anchors.left:box3Seconds2.right
                    anchors.leftMargin:2
                }

                TextField {
                    id:box3Decimal2
                    maximumLength : 3
                    validator: IntValidator {bottom: 0; top: 999;}
                    font.family: localFont.name
                    font.pixelSize: 30
                    anchors.left: box3LabelPoint2.right
                    anchors.leftMargin:4
                    background: Rectangle {
                        implicitWidth: main.width/8
                        radius:10
                        border.color: box3Decimal2.focus ? Palette.black() :Palette.turquoise()
                    }
                }

                Label {
                    id:box3LabelSeconds2
                    text: "''"
                    font.pixelSize: 30
                    anchors.left:box3Decimal2.right
                    anchors.leftMargin:2
                }

                Button {
                    y:box3ButtonEO.y+box3ButtonEO.height+40
                    contentItem: Text {
                        id:box3ButtonOK
                        text:"OK"
                        font.family: localFont.name
                        font.pixelSize: 30
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
                        if(box3Lat() !== "" && box3Lon() !== "") {
                            coordinatesBox.close()
                            main.state = "coordinates"
                            cachesNear.latPoint = box3Lat()
                            cachesNear.lonPoint = box3Lon()
                            cachesNear.distance = 100000
                            cachesNear.updateFilterCaches(createFilterTypesGs(),createFilterSizesGs(),createFilterDifficultyTerrainGs(),
                                                          createFilterExcludeCachesFound(),createFilterExcludeCachesArchived(),
                                                          createFilterKeywordDiscoverOwner() , userInfo.name )
                            cachesNear.sendRequest(connector.tokenKey)

                            fastMap.mapItem.center =QtPositioning.coordinate(box3Lat() , box3Lon())
                        }
                    }
                }

                Button {
                    x:coordinatesBox.width/2
                    y:box3ButtonEO.y+box3ButtonEO.height+40
                    contentItem: Text {
                        id:box3ButtonDel
                        text:"Effacer"
                        font.family: localFont.name
                        font.pixelSize: 30
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
}

