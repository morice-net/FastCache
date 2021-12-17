import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    property string dateIso
    property string dateInit: initDate()
    property int typeLog: initTypeLog()
    property string addLog: ""
    property string textRecorded: initTextRecorded()

    onTypeLogChanged: {
        logTypes.button1Checked = typeLog == 2;  // type of log : Found It
        logTypes.button2Checked = typeLog == 3;  // type of log : Didn't find it
        logTypes.button3Checked = typeLog == 4;  // type of log : Write note
        logTypes.button4Checked = typeLog == 45; // type of log : Needs Maintenance
        logTypes.button5Checked = typeLog == 7; // type of log : Needs Archived
        logTypes.button6Checked = typeLog == 46;  // type of log : Owner Maintenance
        logTypes.button7Checked = typeLog == 22; // type of log : Temporarily Disable Listing
        logTypes.button8Checked = typeLog == 5; // type of log : Archive
        console.log("typeLog: " + typeLog)
    }
    onDateInitChanged: {
        dateIso = dateInit
        logDate.text = "Date  " + new Date(dateIso).toLocaleDateString(Qt.LocaleDate)
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

    ImagesBrowser {
        id: imagesBrowser
        visible: false
    }

    AddTextLog {
        id: addText
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.topMargin: 40
        anchors.bottomMargin: 30
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        contentHeight: column.height
        clip : true

        Column {
            id: column
            spacing: 10
            width: parent.width

            LogTypes {
                id: logTypes
                width: logPage.width*0.9
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: logDate
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 18
                color: Palette.silver()

                MouseArea {
                    anchors.fill: logDate
                    onClicked: {
                        calendar.visible = !calendar.visible
                    }
                }
            }

            FastCalendar {
                id:calendar
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
                    text: "Texte du Log de la cache"
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
                    onClicked:{
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
                textFormat: Qt.RichText
                wrapMode: TextArea.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
                background: Rectangle {
                    implicitHeight: 100
                }
            }

            CheckBox {
                id :favorited
                visible: typeLog === 2 // found
                checked: initFavorited()
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

            FastButton {
                id: buttonAddImages
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Cliquer pour ajouter des images ( " + imagesBrowser.repeaterCount + " )"
                font.pointSize: 10
                onClicked:{
                    imagesBrowser.visible = true
                }
            }

            FastButton {
                id: buttonSendLog
                anchors.horizontalCenter: parent.horizontalCenter
                text: updateLog === false ? "Envoyer le log" : "Mettre à jour le log"
                font.pointSize: 10
                onClicked: {
                    console.log(fullCache.geocode + " " + typeLog + " " + dateIso   + " " +  message.text + " "
                                + favorited.checked);
                    if(message.length !== 0) {
                        if(updateLog === false) {
                            // create log
                            sqliteStorage.updateObject("cacheslog" , fullCache.geocode , sendCacheLog.makeJsonLog(typeLog,dateIso,message.text,
                                                                                                                  favorited.checked))
                            sqliteStorage.updateObject("cachestbsuserlog" , fullCache.geocode , sendTravelbugLog.makeJsonTbsUserLog(listTbSend))
                            sqliteStorage.updateObject("cachesimageslog" , fullCache.geocode , sendImagesLog.makeJsonSendImagesLog(createListImagesLog()))
                            fullCache.toDoLog = true
                            sendCacheLog.sendRequest(connector.tokenKey , fullCache.geocode , typeLog , dateIso  , message.text , favorited.checked)
                        } else {
                            // updatelog
                            sendEditUserLog.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[updateLogIndex] ,fullCache.geocode ,
                                                        typeLog , dateIso , message.text , favorited.checked)
                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: getTravelbugUser.tbsCode.length !== 0 && updateLog === false
                font.family: localFont.name
                font.pointSize: 14
                text: "INVENTAIRE"
                color: Palette.white()
            }

            TravelsbugUser {
                id: travelsbugUser
            }
        }

        function scrollToBottom() { ScrollBar.vertical.position = 1. }
    }

    function tbLogType(comboIndex) {
        if(comboIndex === 0)
            return 0;  // Nothing
        else if(comboIndex === 1)
            return 75;  // Visited
        else if(comboIndex === 2)
            return 14  // Dropped Off
    }

    function tbComboText(type) {
        if(type === 0)
            return "Ne rien faire"   // Nothing
        else if(type === 75)
            return "Visité"   // Visited
        else if(type === 14)
            return "Déposé"  // Dropped Off
    }

    function initDate() {
        if(sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode))
            return sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "loggedDate")
        if(updateLog) {
            return new Date(getUserGeocacheLogs.loggedDates[updateLogIndex]).toISOString()
        } else {
            return new Date().toISOString()
        }
    }

    function initTypeLog() {
        if(sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode))
            return sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "geocacheLogType")
        if(updateLog)
            return getUserGeocacheLogs.logsTypeId[updateLogIndex]
        if(fullCache.found || fullCache.owner === userInfo.name) {
            return 4
        } else {
            return 2
        }
    }

    function initTextRecorded() {
        if(sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode))
            return sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "text")
        if(updateLog)
            return getUserGeocacheLogs.logs[updateLogIndex]
        return ""
    }

    function initFavorited() {
        if(sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode))
            return sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "usedFavoritePoint")
        if(updateLog)
            return fullCache.favorited
        return false
    }
}
