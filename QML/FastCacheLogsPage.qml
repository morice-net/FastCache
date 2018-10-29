import QtQuick 2.6
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logsPage

    Flickable {
        id: logs
        anchors.fill: parent
        anchors.topMargin: 35
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column{
            spacing:10
            width: logsPage.width

            Repeater{
                model:fullCache.logs.length

                Column{

                    Item {
                        width: logs.width
                        height: 35
                        Text {
                            text: fullCache.findersName[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                            anchors.left: parent.left
                        }

                        Text {
                            text: new Date(fullCache.findersDate[index]).toLocaleDateString(Qt.locale("fr_FR"))
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
                            text: fullCache.logsType[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.silver()
                            wrapMode: Text.Wrap
                            anchors.left: parent.left
                        }

                        Text {
                            text: "Nombre de caches:  " + fullCache.findersCount[index]
                            leftPadding: 15
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.silver()
                            wrapMode: Text.Wrap
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                        }
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
                        text: fullCache.logs[index]
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
}

