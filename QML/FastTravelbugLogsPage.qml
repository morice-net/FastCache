import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: logsPage

    Text {
        visible: travelbug.logsText.length === 0
        anchors.centerIn: parent
        text: "La page des logs est vide"
        font.family: localFont.name
        font.bold: true
        font.pointSize: 17
        color: Palette.white()
    }

    Flickable {
        id: logs
        anchors.fill: parent
        anchors.topMargin: fastTravelbugHeader.height * 2.7
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        clip:true

        Column {
            spacing: 10
            width: logsPage.width

            Repeater {
                model: travelbug.logsText.length

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.95
                    height: textLog.height + 10
                    border.width: 2
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
                            text: "Nombre de caches: " + travelbug.logsOwnersCount[index]
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
                            width: logsPage.width * 0.95
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
}
