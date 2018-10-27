import QtQuick 2.6
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logsPage

    Flickable {
        id: logs
        anchors.fill: parent
        anchors.topMargin: 25
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column{
            spacing:10
            width: logsPage.width

            Repeater{
                model:fullCache.logs.length

                Column{

                    Text {
                        text: fullCache.findersName[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 15
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Text {
                        text: new Date(fullCache.findersDate[index]).toLocaleDateString(Qt.locale("fr_FR"))
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Text {
                        text: fullCache.logsType[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Text {
                        text: "Nombre de caches:  " + fullCache.findersCount[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 13
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    TextArea {
                        width: logsPage.width
                        font.family: localFont.name
                        font.pointSize: 15
                        horizontalAlignment: TextEdit.AlignJustify
                        color: Palette.white()
                        textFormat: Qt.RichText
                        wrapMode: TextArea.Wrap
                        readOnly: true
                        persistentSelection: true
                        leftPadding: 15
                        rightPadding: 15
                        onLinkActivated: Qt.openUrlExternally(link)
                        text: fullCache.logs[index]
                    }
                }
            }
        }
    }
}

