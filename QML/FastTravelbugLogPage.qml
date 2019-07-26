import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    property string dateIso: new Date().toISOString()
    property int typeLog: 4
    property string textLog: ""

    onTypeLogChanged: {
        button1.checked = typeLog == 13   // type of log: Retrieve It from a Cache
        button2.checked = typeLog == 19   // type of log: Grab It (Not from a Cache)
        button3.checked = typeLog == 4   // type of log: Write Note
        button4.checked = typeLog == 48  // type of log: Discovered It
        button5.checked = typeLog == 75  // type of log: Visited
        button6.checked = typeLog == 14  // type of log: Dropped Off
    }

    onTextLogChanged: message.text = message.text + textLog ;

    AddTextLog{
        id:addText
    }

    Flickable {
        anchors.topMargin: 10
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height

        Column{
            spacing: 10
            x:10
            y:20

            GroupBox {
                id: found
                flat: true
                width: parent.width
                Column {
                    ExclusiveGroup { id: tabPositionGroup }

                    RadioButton {
                        id:button1
                        visible: travelbug.tbStatus === 1 //travelbug in cache
                        checked: false
                        onClicked: typeLog = 13
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Récupéré"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                                anchors.margins: 0
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        id:button2
                        visible: travelbug.tbStatus === 1 //travelbug in cache
                        onClicked: typeLog = 19
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Pris ailleurs"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        id:button3
                        visible:true
                        checked: true
                        onClicked: typeLog = 4
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Note"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        id:button4
                        visible: travelbug.tbStatus === 1 //travelbug in cache
                        onClicked: typeLog = 48
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Découvert"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }


                    RadioButton {
                        id:button5
                        visible: (travelbug.tbStatus === 2 || travelbug.tbStatus === 3) //travelbug in possession of (owner,holder) of the trackable
                        onClicked: typeLog = 75
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Visité"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        id:button6
                        visible: (travelbug.tbStatus === 2 || travelbug.tbStatus === 3) //travelbug in possession of (owner,holder) of the trackable
                        onClicked: typeLog = 14
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Déposé"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                }
            }

            Text {
                id: logDate
                width: parent.width
                font.family: localFont.name
                font.pointSize: 16
                text: "Date  " + new Date().toLocaleDateString(Qt.LocaleDate)
                color: Palette.white()
            }

            Calendar {
                id:calendar
                onClicked:{
                    logDate.text="Date  " + date.toLocaleDateString(Qt.LocaleDate);
                    dateIso = date.toISOString()
                }
                style: CalendarStyle {
                    gridVisible: false
                    background: Rectangle {
                        implicitHeight: fastCache.height / 2.6
                        implicitWidth: fastCache.width - 20
                        color: Palette.greenSea()
                        radius: 15
                    }
                    navigationBar: Item {
                        implicitHeight: fastCache.height * 0.06
                        Item {
                            height: parent.height
                            width: height
                            anchors.left: parent.left
                            Text {
                                anchors.centerIn: parent
                                font.family: localFont.name
                                font.pointSize: 32
                                text: "   <"
                                font.bold: true
                                color: Palette.white()
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: control.showPreviousMonth()
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            font.family: localFont.name
                            font.pointSize: 18
                            text: styleData.title
                            color: Palette.white()
                        }
                        Item {
                            height: parent.height
                            width: height
                            anchors.right: parent.right
                            Text {
                                anchors.centerIn: parent
                                font.family: localFont.name
                                font.pointSize: 32
                                text: ">   "
                                font.bold: true
                                color: Palette.white()
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: control.showNextMonth()
                            }
                        }
                    }

                    dayOfWeekDelegate: Item {
                        implicitHeight: fastCache.height * 0.06
                        Text {
                            anchors.centerIn: parent
                            font.family: localFont.name
                            font.pointSize: 16
                            color: Palette.white()
                            text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                        }
                    }

                    dayDelegate: Rectangle {
                        color: styleData.visibleMonth && styleData.valid ? Palette.turquoise() : Palette.greenSea()
                        Rectangle {
                            width: parent.height
                            height: width
                            radius: height / 2
                            color:  Palette.greenSea()
                            border.color: styleData.selected ? Palette.white() : parent.color
                            border.width: 2
                            anchors.centerIn: parent
                        }

                        Label {
                            text: styleData.date.getDate()
                            anchors.centerIn: parent
                            color: (styleData.visibleMonth && styleData.valid) ? Palette.white() : Palette.turquoise()
                            font.family: localFont.name
                            font.bold: styleData.visibleMonth && styleData.valid
                            font.pointSize: 16
                        }
                    }
                }
            }

            Row {
                spacing: 40

                Button {
                    style: ButtonStyle {
                        label: Text {
                            text: "Effacer"
                            font.family: localFont.name
                            font.pointSize: 16
                            color: Palette.greenSea()
                        }
                        background: Rectangle {
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                        }
                    }
                    onClicked:{
                        message.text=""
                    }
                }

                Button {
                    style: ButtonStyle {
                        label: Text {
                            text: "Ajout de texte"
                            font.family: localFont.name
                            font.pointSize: 16
                            color: Palette.greenSea()
                        }
                        background: Rectangle {
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                        }
                    }
                    onClicked:{
                        addText.open();
                        textLog = "" ;
                    }
                }

                Button {
                    id:sendLog
                    style: ButtonStyle {
                        label: Text {
                            text: "Envoyer le log"
                            font.family: localFont.name
                            font.pointSize: 16
                            color: Palette.greenSea()
                        }
                        background: Rectangle {
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
                    onClicked:{
                        if((typeLog !== 4 && travelbug.tbStatus === 1) || (typeLog !== 4 && travelbug.tbStatus === 3)){
                            sendTravelbugLog.sendRequest(connector.tokenKey , travelbug.tbCode , trackingCode.text , typeLog , dateIso  , message.text);
                        }
                        else if(typeLog !== 4 &&travelbug.tbStatus === 2 ){
                            sendTravelbugLog.sendRequest(connector.tokenKey , travelbug.tbCode , travelbug.trackingNumber , typeLog , dateIso  , message.text);
                        }

                        else if(typeLog === 4 && message.text !==""){
                            sendTravelbugLog.sendRequest(connector.tokenKey , travelbug.tbCode , "" , typeLog , dateIso  , message.text);
                        }
                    }
                }
            }

            TextField {
                id: trackingCode
                visible:((typeLog !== 4 && travelbug.tbStatus === 1) || (typeLog !== 4 && travelbug.tbStatus === 3))
                placeholderText: qsTr("Code de suivi")
                font.family: localFont.name
                font.pointSize: 16
                style: TextFieldStyle {
                    textColor: Palette.greenSea()
                }
            }

            Text {
                width: parent.width
                font.family: localFont.name
                font.pointSize: 16
                text: "Texte du Log"
                color: Palette.white()
            }

            TextArea {
                id: message
                width: logPage.width*0.95
                font.family: localFont.name
                font.pointSize: 14
                textColor: Palette.greenSea()
            }
        }
    }
}
