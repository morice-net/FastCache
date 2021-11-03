import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette

Repeater {
    id: tbList

    property int repeaterIndex

    model: getTravelbugUser.tbsCode.length
    onItemAdded:{
        if(sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache .geocode) === false)
            listTbSend.push(getTravelbugUser.tbsCode[index] + "," + getTravelbugUser.trackingNumbers[index] + "," + "0," +
                            dateIso + "," +  "")
    }

    Column {
        spacing: 5
        visible: updateLog === false // mode create log

        Row {
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: "qrc:/Image/" + "trackable_travelbug.png"
                scale: 1.4
            }

            Text {
                text: getTravelbugUser.trackingNumbers[index]
                font.family: localFont.name
                font.bold: true
                font.pointSize: 14
                color: Palette.silver()

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        travelbug.sendRequest(connector.tokenKey , getTravelbugUser.tbsCode[index]);
                    }
                }
            }
        }

        Row {
            spacing: 10

            Text {
                width: logPage.width*0.5
                text: getTravelbugUser.tbsName[index]
                font.family: localFont.name
                font.bold: true
                font.pointSize: 14
                color: Palette.white()
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            ComboBox {
                id: tbCombo
                model: [tbComboText(0) , tbComboText(75), tbComboText(14)]

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        tbList.repeaterIndex = index
                        tbCombo.popup.open()
                    }
                }
                delegate: ItemDelegate {
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
                    radius: 8
                }
                onActivated: {
                    if(tbCombo.currentText === tbComboText(0)) {
                        title.visible = false;
                        messageTbLog.visible = false;
                        listTbSend[tbList.repeaterIndex] = getTravelbugUser.tbsCode[tbList.repeaterIndex] +
                                "," +getTravelbugUser.trackingNumbers[tbList.repeaterIndex] + "," + tbLogType(currentIndex) + "," +
                                dateIso + "," + "";
                    } else{
                        title.visible = true;
                        messageTbLog.visible = true;
                        listTbSend[tbList.repeaterIndex] = getTravelbugUser.tbsCode[tbList.repeaterIndex] + "," +
                                getTravelbugUser.trackingNumbers[tbList.repeaterIndex] + "," + tbLogType(currentIndex) + "," +
                                dateIso + "," + messageTbLog.text;
                    }
                }
            }
        }

        property string typeTbLog: sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache.geocode)?
                                       tbComboText(Number(listTbSend[tbList.repeaterIndex].split(',')[2])) : tbComboText(0)
        onTypeTbLogChanged: tbCombo.currentIndex = tbCombo.find(typeTbLog)
        Component.onCompleted: tbCombo.currentIndex = tbCombo.find(typeTbLog)

        Text {
            id: title
            visible: tbCombo.currentText === tbComboText(0) ? false : true
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 16
            text: "Texte du Log du travelbug"
            color: Palette.white()
        }

        TextArea {
            id: messageTbLog
            visible: tbCombo.currentText === tbComboText(0) ? false : true
            text: sqliteStorage.isCacheInTable("cachestbsuserlog", fullCache.geocode)?
                      listTbSend[tbList.repeaterIndex].substring(listTbSend[tbList.repeaterIndex].split(',')[0].length
                                                                 + listTbSend[tbList.repeaterIndex].split(',')[1].length  +
                                                                 listTbSend[tbList.repeaterIndex].split(',')[2].length +
                                                                 listTbSend[tbList.repeaterIndex].split(',')[3].length + 4) : ""
            onFocusChanged: {
                if(messageTbLog.focus === false) {
                    tbList.repeaterIndex = index
                    listTbSend[tbList.repeaterIndex] = getTravelbugUser.tbsCode[tbList.repeaterIndex] + "," +
                            getTravelbugUser.trackingNumbers[tbList.repeaterIndex] + "," + tbLogType(tbCombo.currentIndex) + "," +
                            dateIso + "," + messageTbLog.text;
                }
            }
            width: logPage.width*0.9
            font.family: localFont.name
            font.pointSize: 14
            color: Palette.greenSea()
            wrapMode: Text.Wrap
            background: Rectangle {
                implicitHeight: 100
            }
            onVisibleChanged: {
                if (visible)
                    scrollView.scrollToBottom()
            }
        }
    }
}
