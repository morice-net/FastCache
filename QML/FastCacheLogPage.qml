import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    property string dateIso
    property string dateInit: sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode) ?
                                  sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "loggedDate")
                                : new Date().toISOString()
    property int typeLog: 2
    property int typeLogCheck
    property int typeLogInit: sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode)?
                                  sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "geocacheLogType") : 2
    property string addLog: ""
    property string textRecorded: sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode)?
                                      sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "text") : ""
    onTypeLogInitChanged: {
        typeLog = typeLogInit
        button1.checked = typeLog == 2;  // type of log : Found It
        button2.checked = typeLog == 3;  // type of log : Didn't find it
        button3.checked = typeLog == 4;  // type of log : Write note
        button4.checked = typeLog == 45; // type of log : Needs Maintenance
        button5.checked = typeLog == 7; // type of log : Needs Archived
        console.log("typeLog: " + typeLog)
    }
    onDateInitChanged:{
        dateIso = dateInit
        logDate.text = "Date  " + new Date(dateIso).toLocaleDateString(Qt.LocaleDate)
    }
    onAddLogChanged: {
        console.log("addLog: " + addLog)
        message.text = message.text + addLog
        addLog = ""
    }
    onTextRecordedChanged: {
        console.log("textRecorded: " + textRecorded)
        message.text = textRecorded
    }

    AddTextLog{
        id:addText
    }

    Flickable {
        anchors.topMargin: 30
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: childrenRect.height
        ScrollBar.vertical: ScrollBar {}

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
                        onClicked: {
                            typeLogCheck = 2
                            typeLog = typeLogCheck
                        }
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
                        text: "Non trouvée"
                        onClicked: {
                            typeLogCheck = 3
                            typeLog = typeLogCheck
                        }
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
                        onClicked: {
                            typeLogCheck = 4
                            typeLog = typeLogCheck
                        }
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
                        text: "Nécessite une maintenance"
                        onClicked: {
                            typeLogCheck = 45
                            typeLog = typeLogCheck
                        }
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
                        text: "Nécessite d'être archivée"
                        onClicked: {
                            typeLogCheck = 7
                            typeLog = typeLogCheck
                        }
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
                font.pointSize: 18
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
                onDateCalendarChanged:{
                    dateIso = dateCalendar.toISOString()
                    logDate.text = "Date  " + new Date(dateIso).toLocaleDateString(Qt.LocaleDate)
                }
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
                        border.color: Palette.silver()
                        radius: 4
                    }
                    onClicked:{
                        message.text = ""
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
                        border.color: Palette.silver()
                        radius: 4
                    }
                    onClicked:{
                        addText.open();
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
                        border.color: Palette.silver()
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: buttonSendLog.pressed ? "#ccc" : "#eee" }
                            GradientStop { position: 1 ; color: buttonSendLog.pressed ? "#aaa" : "#ccc" }
                        }
                    }
                    onClicked:{
                        console.log(connector.tokenKey + " " + fullCache.geocode + " " + typeLog + " " + dateIso   + " " +  message.text + " "
                                    + favorited.checked);
                        if(message.text !== null && message.text !== '') {
                            sqliteStorage.updateObject("cacheslog" , fullCache.geocode , sendCacheLog.makeJsonLog(typeLog,dateIso,message.text,
                                                                                                                  favorited.checked))
                            sqliteStorage.updateObject("cachestbsuserlog" , fullCache.geocode , sendTravelbugLog.makeJsonTbsUserLog(listTbSend))
                            sendCacheLog.sendRequest(connector.tokenKey , fullCache.geocode , typeLog , dateIso  , message.text , favorited.checked)
                        }
                    }
                }
            }

            Text {
                width: parent.width
                font.family: localFont.name
                font.pointSize: 16
                text: "Texte du Log de la cache"
                color: Palette.white()
            }

            TextArea {
                id: message
                width: logPage.width*0.95
                font.family: localFont.name
                font.pointSize: 14
                color: Palette.greenSea()
                wrapMode: Text.Wrap
                background: Rectangle {
                    implicitHeight: 100
                }
            }

            CheckBox {
                id :favorited
                x:10
                checked:sqliteStorage.isCacheInTable("cacheslog", fullCache.geocode) ?
                            sendCacheLog.readJsonProperty(sqliteStorage.readObject("cacheslog" ,fullCache.geocode), "usedFavoritePoint") : false
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
                leftPadding: 10
                font.pointSize: 14
                text: "INVENTAIRE"
                color: Palette.silver()
            }

            Column {
                spacing: 10
                width: logPage.width

                Repeater {
                    id:tbList
                    property int repeaterIndex

                    model: getTravelbugUser.tbsCode.length
                    onItemAdded:{
                        if(sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache.geocode) === false)
                            listTbSend.push(getTravelbugUser.tbsCode[index] + "," + getTravelbugUser.trackingNumbers[index] + "," + "0," +
                                            dateIso + "," +  "")
                    }

                    Row {
                        height: logPage.height*0.5

                        Image {
                            source: "qrc:/Image/" + "trackable_travelbug.png"
                            scale: 1.4
                        }

                        Column {
                            spacing: 10

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

                            ComboBox {
                                id: tbCombo
                                visible:false
                                model: [tbComboText(0) , tbComboText(75), tbComboText(14)]
                                delegate: ItemDelegate {
                                    width: tbCombo.width
                                    contentItem: Text {
                                        text: modelData
                                        color: Palette.turquoise()
                                        font.family: localFont.name
                                        font.pointSize: 15
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                                contentItem: Text {
                                    leftPadding: 10
                                    text: tbCombo.displayText
                                    font.family: localFont.name
                                    font.pointSize: 15
                                    color: Palette.turquoise()
                                    verticalAlignment: Text.AlignVCenter
                                }
                                background: Rectangle {
                                    implicitWidth: 200
                                    implicitHeight: 40
                                    border.color: Palette.silver()
                                    border.width: 1
                                    radius: 5
                                }
                                onActivated:  {
                                    tbLog.text = tbCombo.currentText;
                                    tbCombo.visible = false;
                                    tbLog.visible = true;
                                    title.visible = false;
                                    messageTbLog.visible = false;
                                    if(tbLog.text === tbComboText(0)) {
                                        listTbSend[tbList.repeaterIndex] = getTravelbugUser.tbsCode[tbList.repeaterIndex] +
                                                "," +getTravelbugUser.trackingNumbers[tbList.repeaterIndex] + "," + tbLogType(currentIndex) + "," +
                                                dateIso + "," + "";
                                    } else{
                                        listTbSend[tbList.repeaterIndex] = getTravelbugUser.tbsCode[tbList.repeaterIndex] + "," +
                                                getTravelbugUser.trackingNumbers[tbList.repeaterIndex] + "," + tbLogType(currentIndex) + "," +
                                                dateIso + "," + messageTbLog.text;
                                    }
                                }
                            }

                            property string typeTbLog: sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache.geocode)?
                                                           tbComboText(Number(listTbSend[tbList.repeaterIndex].split(',')[2])) : tbComboText(0)
                            onTypeTbLogChanged: tbLog.text = typeTbLog

                            Text {
                                id: tbLog
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 14
                                color: Palette.silver()

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        tbList.repeaterIndex = index;
                                        tbLog.visible = false
                                        tbCombo.visible = true;
                                        tbCombo.currentIndex = tbCombo.find(tbLog.text)
                                        title.visible = true;
                                        messageTbLog.visible = true;
                                    }
                                }
                            }

                            Text {
                                id: title
                                width: parent.width
                                visible: false
                                font.family: localFont.name
                                font.pointSize: 16
                                text: "Texte du Log du travelbug"
                                color: Palette.white()
                            }

                            TextArea {
                                id: messageTbLog
                                text: sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache.geocode)?
                                          listTbSend[tbList.repeaterIndex].substring(listTbSend[tbList.repeaterIndex].split(',')[0].length
                                                                                     + listTbSend[tbList.repeaterIndex].split(',')[1].length  +
                                                                                     listTbSend[tbList.repeaterIndex].split(',')[2].length +
                                                                                     listTbSend[tbList.repeaterIndex].split(',')[3].length + 4) : ""
                                visible: false
                                width: logPage.width*0.85
                                font.family: localFont.name
                                font.pointSize: 14
                                color: Palette.greenSea()
                                wrapMode: Text.Wrap
                                background: Rectangle {
                                    implicitHeight: 100
                                }
                            }
                        }
                    }
                }
            }
        }
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
}









