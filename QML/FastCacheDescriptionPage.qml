import QtQuick 2.6
import QtQuick.Controls 2.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: descriptionPage

    Flickable {
        id: longDescription
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        TextArea.flickable:
            TextArea {
            font.family: localFont.name
            font.pointSize: 14
            color: Palette.white()
            textFormat: Qt.AutoText
            wrapMode: TextArea.Wrap
            readOnly: true
            persistentSelection: true
            leftPadding: 15
            rightPadding: 15
            topPadding: 15
            onLinkActivated: Qt.openUrlExternally(link)
            text: fullCache.longDescription;

            Rectangle {
                id: separator
                y:parent.height+20
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id:ind
                width: parent.width
                y:separator.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
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
                text: fullCache.hints
            }
        }

        Rectangle {
            id: separator1
            y:hint.y + hint.height + 10
            width: parent.width
            height: 2
            color: Palette.white()
            radius:10
        }

    }
}




