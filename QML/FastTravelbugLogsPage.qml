import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logsPage

    Flickable {
        id: logs
        anchors.fill: parent
        anchors.topMargin: 70
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column {
            spacing:10
            width: logsPage.width

            Repeater {
                model:displayTbLogsPage()

                Rectangle {
                    x: 15
                    y: 20
                    width: parent.width*0.95
                    height: textLog.height + 10
                    border.width: 4
                    border.color: Palette.silver()
                    radius: 8

                    Column{
                        id: textLog
                        spacing: 15

                        Item {
                            width: parent.width*0.95
                            height: 35

                            Text {
                                topPadding: 10
                                leftPadding: 15
                                anchors.left: parent.left
                                text: travelbug.logsOwnersName[index]
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 15
                                color: Palette.black()
                                wrapMode: Text.Wrap
                            }

                            Text {
                                text: new Date(travelbug.logsDate[index]).toLocaleDateString(Qt.locale("fr_FR"))
                                topPadding: 10
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                font.family: localFont.name
                                font.pointSize: 13
                                color: Palette.black()
                                wrapMode: Text.Wrap
                            }
                        }

                        Text {
                            text: travelbug.logsOwnersCount[index]
                            leftPadding: 15
                            anchors.left: parent.left
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.black()
                            wrapMode: Text.Wrap
                        }

                        Text {
                            visible: travelbug.logsGeocacheCode[index] !== ""
                            text: travelbug.logsGeocacheCode[index] + " : " + travelbug.logsGeocacheName[index]
                            leftPadding: 15
                            anchors.left: parent.left
                            anchors.rightMargin: 10
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.black()
                            wrapMode: Text.Wrap
                        }

                        Text {
                            text: travelbug.logsType[index]
                            leftPadding: 15
                            anchors.left: parent.left
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.black()
                            wrapMode: Text.Wrap
                        }

                        Text {
                            width: logsPage.width*0.95
                            font.family: localFont.name
                            font.pointSize: 15
                            horizontalAlignment: TextEdit.AlignJustify
                            color: Palette.greenSea()
                            textFormat: Qt.RichText
                            wrapMode: TextArea.Wrap
                            leftPadding: 15
                            rightPadding: 15
                            onLinkActivated: Qt.openUrlExternally(link)
                            text: travelbug.logsText[index]
                        }
                    }
                }
            }
        }
    }

    function displayTbLogsPage() {
        if(travelbug.logsText.length === 0){
            fastTravelbug.removePage(logsPage)
            return travelbug.logsText.length
        } else {
            fastTravelbug.addPage(logsPage)

            // reorder pages
            swipeFastTravelbug.moveItem(2,1);
            return travelbug.logsText.length
        }
    }
}
