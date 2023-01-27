import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    property string dateIso
    property string dateInit: sqliteStorage.isCacheInTable("tblog", travelbug.tbCode) ?
                                  sendTravelbugLog.readJsonProperty(sqliteStorage.readColumnJson("tblog" ,travelbug.tbCode), "loggedDate")
                                : new Date().toISOString()
    property int typeLog: 4
    property int typeLogInit: sqliteStorage.isCacheInTable("tblog" , travelbug.tbCode)?
                                  sendTravelbugLog.readJsonProperty(sqliteStorage.readColumnJson("tblog" , travelbug.tbCode), "logType") :4
    property string addLog: ""
    property string textRecorded: sqliteStorage.isCacheInTable("tblog", travelbug.tbCode)?
                                      sendTravelbugLog.readJsonProperty(sqliteStorage.readColumnJson("tblog" , travelbug.tbCode), "text") : ""

    property string tracking: sqliteStorage.isCacheInTable("tblog", travelbug.tbCode) ?
                                  sendTravelbugLog.readJsonProperty(sqliteStorage.readColumnJson("tblog" ,travelbug.tbCode), "trackingCode") : ""

    onDateInitChanged:{
        dateIso = dateInit
        logDate.text = "Date  " + new Date(dateIso).toLocaleDateString(Qt.LocaleDate)
    }
    onTypeLogInitChanged: {
        typeLog = typeLogInit
        logTypesTravelbug.button1Checked = typeLog == 13   // type of log: Retrieve It from a Cache
        logTypesTravelbug.button2Checked = typeLog == 19   // type of log: Grab It (Not from a Cache)
        logTypesTravelbug.button3Checked = typeLog == 4   // type of log: Write Note
        logTypesTravelbug.button4Checked = typeLog == 48  // type of log: Discovered It
        console.log("typeLog: " + typeLog)
    }
    onAddLogChanged: {
        console.log("addLog: " + addLog)
        if(addLog !== "") {
            message.insert(message.cursorPosition , addLog)
            addLog = ""
        }
    }
    onTextRecordedChanged: {
        console.log("textRecorded: " + textRecorded)
        message.text = textRecorded
    }
    onTrackingChanged: {
        trackingCode.text = tracking
    }

    AddTextLog{
        id:addText
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.topMargin: fastTravelbugHeader.height * 3
        anchors.bottomMargin: 30
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        contentHeight: column.height
        clip : true

        Column {
            id: column
            spacing: 10
            width: parent.width

            LogTypesTravelbug {
                id: logTypesTravelbug
                width: logPage.width*0.9
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: logDate
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 18
                text: "Date  " + new Date().toLocaleDateString(Qt.LocaleDate)
                color: Palette.silver()

                MouseArea {
                    anchors.fill: logDate
                    onClicked: {
                        calendar.visible = !calendar.visible
                    }
                }
            }

            FastCalendar {
                id: calendar
                width: logPage.width*0.9
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
                onDateCalendarChanged:{
                    dateIso = dateCalendar.toISOString()
                    logDate.text = "Date  " + new Date(dateIso).toLocaleDateString(Qt.LocaleDate)
                }
            }


            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: logTextTitle
                    font.family: localFont.name
                    font.pointSize: 16
                    text: "Texte du Log du travelbug"
                    color: Palette.white()
                }

                Item {
                    id: spacer
                    height: 2
                    width: logPage.width*0.9 - logTextTitle.width - buttonDelete.width - buttonAdd.width - 40
                }

                FastButton {
                    id: buttonAdd
                    contentItem: Image {
                        source: "qrc:/Image/" + "icon_edit.png"
                    }
                    onClicked:{
                        addText.open();
                    }
                }

                FastButton {
                    id: buttonDelete
                    contentItem: Image {
                        source: "qrc:/Image/" + "icon_erase.png"
                    }
                    onClicked: {
                        message.text = ""
                    }
                }
            }

            TextArea {
                id: message
                anchors.horizontalCenter: parent.horizontalCenter
                width: logPage.width*0.9
                font.family: localFont.name
                font.pointSize: 14
                color: Palette.greenSea()
                wrapMode: Text.Wrap
                background: Rectangle {
                    implicitHeight: 100
                }
            }

            TextField {
                id: trackingCode
                visible:(typeLog !== 4 && travelbug.tbStatus !== 0)
                anchors.horizontalCenter: parent.horizontalCenter
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

            FastButton {
                id:buttonSendLog
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Envoyer le log"
                font.pointSize: 18
                onClicked:{
                    if(typeLog !== 4 && travelbug.tbStatus !== 0 && message.text !== "") {
                        sqliteStorage.updateObject("tblog" , travelbug.tbCode , sendTravelbugLog.makeJsonTbLog(trackingCode.text , typeLog ,
                                                                                                               dateIso , message.text))
                        sendTravelbugLog.sendRequest(connector.tokenKey , "" , travelbug.tbCode , trackingCode.text , typeLog , dateIso  , message.text);
                    } else if(typeLog === 4 && message.text !== ""){
                        sqliteStorage.updateObject("tblog" , travelbug.tbCode , sendTravelbugLog.makeJsonTbLog("" , typeLog , dateIso , message.text))
                        sendTravelbugLog.sendRequest(connector.tokenKey , "" , travelbug.tbCode , "" , typeLog , dateIso  , message.text);
                    }
                }
            }
        }
    }
}

