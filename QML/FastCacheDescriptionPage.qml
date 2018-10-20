import QtQuick 2.6
import QtQuick.Controls 2.1

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: descriptionPage
    height: swipeFastCache.height

    SendCacheNote{
        id:sendCacheNote
    }

    Flickable {
        id: longDescription
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column {
            width: descriptionPage.width
            TextArea {
                width: parent.width
                font.family: localFont.name
                font.pointSize: 14
                color: Palette.white()
                textFormat: Qt.AutoText
                wrapMode: TextArea.Wrap
                readOnly: true
                persistentSelection: true
                leftPadding: 15
                rightPadding: 15
                topPadding: 25
                onLinkActivated: Qt.openUrlExternally(link)
                text: fullCache.longDescription
            }

            Rectangle {
                id: separator1
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            TextArea {
                id:ind
                width: parent.width
                y:separator1.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                readOnly: true
                text: "INDICE"
                color: Palette.silver()
            }

            TextArea {
                id:hint
                width: parent.width
                y:ind.y + 30
                font.family: localFont.name
                color: Palette.white()
                leftPadding: 15
                rightPadding: 15
                textFormat: Text.AutoText
                wrapMode: Text.Wrap
                font.pointSize: 14
                onLinkActivated: Qt.openUrlExternally(link)
                text: "****** *** ****** ********** *** ******** **********"

                MouseArea {
                    id: hintArea
                    anchors.fill: parent
                    onClicked: {
                        if (hint.text == "****** *** ****** ********** *** ******** **********")
                            hint.text = fullCache.hints
                        else
                            hint.text = "****** *** ****** ********** *** ******** **********"
                    }
                }

                onVisibleChanged: text = "****** *** ****** ********** *** ******** **********"
            }

            Rectangle {
                id: separator2
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            TextArea {
                id: note
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "NOTE PERSONNELLE "
                readOnly: true
                color: Palette.silver()
            }

            TextArea {
                id: personalNote
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: fullCache.note
                color: Palette.white()
            }

            Button {
                id:buttonDel
                contentItem: Text {
                    text:"Effacer"
                    font.family: localFont.name
                    font.pixelSize: 28
                    color: Palette.turquoise()
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    anchors.fill: parent
                    anchors.margins: 5
                    opacity: 0.9
                    border.color: Palette.greenSea()
                    border.width: 1
                    radius: 10
                }
                onClicked: {
                    personalNote.text = ""
                }

                Button {
                    id:buttonSend
                    anchors.left: buttonDel.right
                    contentItem: Text {
                        text:"Envoyer"
                        font.family: localFont.name
                        font.pixelSize: 28
                        color: Palette.turquoise()
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 5
                        opacity: 0.9
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 10
                    }
                    onClicked: {

                        sendCacheNote.updateCacheNote(connector.tokenKey , fullCache.geocode ,personalNote.text )

                    }
                }
            }
        }
    }
}
