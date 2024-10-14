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

    Flickable {
        id: scrollView
        anchors.fill: parent
        anchors.topMargin: fastTravelbugHeader.height * 2.7
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
                width: logPage.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: logDate
                anchors.horizontalCenter: parent.horizontalCenter
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
                width: logPage.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
                onDateCalendarChanged:{
                    dateIso = dateCalendar.toISOString()
                    logDate.text = "Date  " + new Date(dateIso).toLocaleDateString(Qt.LocaleDate)
                }
            }


            Item {
                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                height: childrenRect.height

                Text {
                    id: logTextTitle
                    font.family: localFont.name
                    font.pointSize: 16
                    text: "Texte du Log du travelbug"
                    color: Palette.silver()
                }

                FastButtonIcon {
                    id: buttonAdd
                    y: logTextTitle.y - buttonAdd.height / 4
                    height: 40
                    width: 30
                    anchors.right: buttonDelete.left
                    anchors.margins: 10
                    source: "../Image/" + "icon_edit.png"
                    onClicked:{
                        addText.open();
                    }
                }

                FastButtonIcon {
                    id: buttonDelete
                    y: logTextTitle.y - buttonDelete.height / 4
                    height: 40
                    width: 30
                    anchors.right: parent.right
                    source: "../Image/" + "icon_erase.png"
                    onClicked: {
                        message.text = ""
                    }
                }
            }

            TextArea {
                id: message
                x: (logPage.width - message.width) / 2
                width: logPage.width * 0.9
                font.family: localFont.name
                font.pointSize: 14
                color: Palette.greenSea()
                wrapMode: Text.Wrap
                background: Rectangle {
                    implicitHeight: 100
                }
            }

            Text {
                visible:(typeLog !== 4 && travelbug.tbStatus !== 0)
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 16
                color: Palette.white()
                text: "Code de suivi:"
            }

            TextField {
                id: trackingCode
                visible:(typeLog !== 4 && travelbug.tbStatus !== 0)
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 17
                color: Palette.greenSea()
                background: Rectangle {
                    implicitHeight: 40
                    implicitWidth: 100
                    color: Palette.white()
                    border.color: Palette.greenSea()
                    radius: 6
                }
            }

            FastButton {
                id:buttonSendLog
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Envoyer le log"
                font.pointSize: 17
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

