import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    property string dateIso: new Date().toISOString()
    property int typeLog: 2
    property string textLog: ""

    onTypeLogChanged: {
        button1.checked = typeLog == 2  // type of log : Found It
        button2.checked = typeLog == 3  // type of log : Didn't find it
        button3.checked = typeLog == 4  // type of log : Write note
        button4.checked = typeLog == 45 // type of log : Needs Maintenance
        button5.checked = typeLog == 7  // type of log : Needs Archived
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
                width: parent.width*0.7

                Column {

                    RadioButton {
                        id:button1
                        text: "Trouvée"
                        checked: true
                        onClicked: typeLog = 2
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

                    FastRadioButton {
                        id:button2
                        text: "Non trouvée"
                        onClicked: typeLog = 3
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

                    FastRadioButton {
                        id:button3
                        text: "Note"
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

                    FastRadioButton {
                        id:button4
                        text: "Nécessite une maintenance"
                        onClicked: typeLog = 45
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

                    FastRadioButton {
                        id:button5
                        text: "Nécessite d'être archivée"
                        onClicked: typeLog = 7
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
                }
            }

            Text {
                id: logDate
                width: parent.width
                font.family: localFont.name
                font.pointSize: 16
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
                id:calendar
                visible: false
            }

            Row {
                spacing: 40

                Button {
                    id: buttonDelete
                    contentItem: Text {
                        text: "Effacer"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.width: buttonDelete.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                    }
                    onClicked:{
                        message.text=""
                    }
                }

                Button {
                    id: buttonAdd
                    contentItem: Text {
                        text: "Ajout de texte"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.width: buttonAdd.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                    }
                    onClicked:{
                        addText.open();
                        textLog = "" ;
                    }
                }

                Button {
                    id:buttonSendLog
                    contentItem: Text {
                        text: "Envoyer le log"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: Palette.greenSea()
                    }
                    background: Rectangle {
                        border.width: buttonSendLog.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: buttonSendLog.pressed ? "#ccc" : "#eee" }
                            GradientStop { position: 1 ; color: buttonSendLog.pressed ? "#aaa" : "#ccc" }
                        }
                    }
                    onClicked:{
                        console.log(connector.tokenKey + " " + fullCache.geocode + " " + typeLog + " " + dateIso   + " " +  message.text + " "
                                    + favorited.checked);
                        if(message.text !== null && message.text !== '')
                            sendCacheLog.sendRequest(connector.tokenKey , fullCache.geocode , typeLog , dateIso  , message.text , favorited.checked );
                    }
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

            CheckBox {
                id :favorited
                x:10
                checked:false
                contentItem: Text {
                    text: "Ajouter cette cache à vos favoris"
                    font.family: localFont.name
                    font.pointSize: 16
                    color: favorited.checked ? Palette.white() : Palette.silver()
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: favorited.indicator.width + favorited.spacing
                }
                indicator: Rectangle {
                    implicitWidth: 25
                    implicitHeight: 25
                    radius: 3
                    border.width: 1
                    y: parent.height / 2 - height / 2
                    Rectangle {
                        anchors.fill: parent
                        visible: favorited.checked
                        color: Palette.greenSea()
                        radius: 3
                        anchors.margins: 4
                    }
                }
            }

            Text {
                id: note
                visible: getTravelbugUser.tbsCode.length !== 0
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "INVENTAIRE"
                color: Palette.silver()
            }

            Column{
                spacing:10
                width: logPage.width

                Repeater{
                    model: getTravelbugUser.tbsCode.length

                    Row {
                        height: logPage.height*0.12

                        Image {
                            y: 10
                            x: 10
                            source: "qrc:/Image/" + "trackable_travelbug.png"
                            horizontalAlignment: Image.AlignHCenter
                            scale: 1.4
                        }

                        Column {

                            Text {
                                text: getTravelbugUser.trackingNumbers[index]
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 14
                                color: Palette.white()

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        travelbug.sendRequest(connector.tokenKey , getTravelbugUser.tbsCode[index]);
                                        main.viewState = "travelbug"
                                    }
                                }
                            }

                            Text {
                                text: getTravelbugUser.tbsName[index]
                                font.family: localFont.name
                                textFormat: Qt.RichText
                                font.bold: true
                                font.pointSize: 14
                                color: Palette.white()
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
            }
        }
    }
}







