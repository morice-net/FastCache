import QtQuick 2.6
import QtQuick.Controls 2.5
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
        anchors.topMargin: 50
        anchors.fill: logPage
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column{
            spacing: 10
            x:10
            y:40

            GroupBox {
                width: parent.width*0.7

                Column {

                    RadioButton {
                        id:button1
                        text: "Récupéré"
                        visible: travelbug.tbStatus === 1 //travelbug in cache
                        checked: false
                        onClicked: typeLog = 13
                        contentItem: Text {
                            text: button1.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button1.checked ? Palette.white() : Palette.silver()
                            leftPadding: button1.indicator.width + button1.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button1.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button2
                        text: "Pris ailleurs"
                        visible: travelbug.tbStatus === 1 //travelbug in cache
                        checked: false
                        onClicked: typeLog = 19
                        contentItem: Text {
                            text: button2.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button2.checked ? Palette.white() : Palette.silver()
                            leftPadding: button2.indicator.width + button2.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button2.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button3
                        text: "Note"
                        visible:true
                        checked: true
                        onClicked: typeLog = 4
                        contentItem: Text {
                            text: button3.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button3.checked ? Palette.white() : Palette.silver()
                            leftPadding: button3.indicator.width + button3.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button3.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button4
                        text: "Découvert"
                        visible: travelbug.tbStatus === 1 //travelbug in cache
                        checked: false
                        onClicked: typeLog = 48
                        contentItem: Text {
                            text: button4.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button4.checked ? Palette.white() : Palette.silver()
                            leftPadding: button4.indicator.width + button4.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button4.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button5
                        text: "Visité"
                        visible: false
                        onClicked: typeLog = 75
                        checked: false
                        contentItem: Text {
                            text: button5.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button5.checked ? Palette.white() : Palette.silver()
                            leftPadding: button5.indicator.width + button5.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button5.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }

                    RadioButton {
                        id:button6
                        text: "Déposé"
                        visible: false
                        checked: false
                        onClicked: typeLog = 14
                        contentItem: Text {
                            text: button6.text
                            font.family: localFont.name
                            font.pointSize: 16
                            color: button6.checked ? Palette.white() : Palette.silver()
                            leftPadding: button6.indicator.width + button6.spacing
                        }
                        indicator: Rectangle {
                            y:10
                            implicitWidth: 25
                            implicitHeight: 25
                            radius: 10
                            border.width: 1
                            Rectangle {
                                anchors.fill: parent
                                visible: button6.checked
                                color: Palette.greenSea()
                                radius: 10
                                anchors.margins: 4
                            }
                        }
                    }
                }
            }

            Text {
                id: logDate
                width: parent.width
                font.family: localFont.name
                font.pointSize: 18
                text: "Date  " + new Date().toLocaleDateString(Qt.LocaleDate)
                color: Palette.white()

                MouseArea {
                    anchors.fill: logDate
                    onClicked: {
                        calendar.visible = !calendar.visible
                    }
                }
            }

            FastCalendar {
                id: calendar
                visible: false
            }

            Row {
                spacing: 40
                Button {
                    contentItem: Text {
                        text: "Effacer"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.color: "#888"
                        radius: 4
                    }
                    onClicked: {
                        message.text=""
                    }
                }

                Button {
                    contentItem: Text {
                        text: "Ajout de texte"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.color: "#888"
                        radius: 4
                    }
                    onClicked:{
                        addText.open();
                        textLog = "" ;
                    }
                }

                Button {
                    id:sendLog
                    contentItem: Text {
                        text: "Envoyer le log"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.color: "#888"
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: sendLog.pressed ? "#ccc" : "#eee" }
                            GradientStop { position: 1 ; color: sendLog.pressed ? "#aaa" : "#ccc" }
                        }
                    }
                    onClicked:{
                        if(typeLog !== 4 && travelbug.tbStatus === 1) {
                            sendTravelbugLog.sendRequest(connector.tokenKey , "" , travelbug.tbCode , trackingCode.text , typeLog , dateIso  , message.text);
                        } else if(typeLog === 4 && message.text !==""){
                            sendTravelbugLog.sendRequest(connector.tokenKey , "" , travelbug.tbCode , "" , typeLog , dateIso  , message.text);
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
                color: Palette.greenSea()
                background: Rectangle {
                    implicitHeight: 40
                    color: Palette.white()
                    border.color: Palette.greenSea()
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
                color: Palette.greenSea()
                background: Rectangle {
                    implicitHeight: 100
                }
            }
        }
    }
}
