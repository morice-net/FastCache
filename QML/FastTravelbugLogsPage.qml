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

        Column{
            spacing:10
            width: logsPage.width

            Repeater{
                model:displayTbLogsPage()

                Column{

                    Item {
                        width: logs.width
                        height: 35
                        Text {
                            text: travelbug.logsOwnersName[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                            anchors.left: parent.left
                        }

                        Text {
                            text: new Date(travelbug.logsDate[index]).toLocaleDateString(Qt.locale("fr_FR"))
                            leftPadding: 15
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.silver()
                            wrapMode: Text.Wrap
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                        }
                    }

                    Item {
                        width: logs.width
                        height: 35

                        Text {
                            text: travelbug.logsOwnersCount[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.silver()
                            wrapMode: Text.Wrap
                            anchors.left: parent.left
                        }

                        Text {
                            text: travelbug.logsGeocacheCode[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.silver()
                            wrapMode: Text.Wrap
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                        }
                    }

                    Item {
                        width: logs.width
                        height: 35

                        Text {
                            text: travelbug.logsGeocacheName[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.silver()
                            wrapMode: Text.Wrap
                            textFormat: Qt.RichText
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                        }
                    }

                    Text {
                        text: travelbug.logsType[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.silver()
                        wrapMode: Text.Wrap
                        anchors.left: parent.left
                    }

                    Text {
                        width: logsPage.width
                        font.family: localFont.name
                        font.pointSize: 15
                        horizontalAlignment: TextEdit.AlignJustify
                        color: Palette.white()
                        textFormat: Qt.RichText
                        wrapMode: TextArea.Wrap
                        leftPadding: 15
                        rightPadding: 15
                        onLinkActivated: Qt.openUrlExternally(link)
                        text: travelbug.logsText[index]
                    }

                    Rectangle {
                        height: 1
                        width: parent.width
                        color: Palette.silver()
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
