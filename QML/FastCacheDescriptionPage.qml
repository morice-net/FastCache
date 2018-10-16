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

        TextArea.flickable: TextArea {
            font.family: localFont.name
            font.pointSize: 12
            color: Palette.white()
            textFormat: Qt.RichText
            wrapMode: TextArea.Wrap
            readOnly: true
            persistentSelection: true
            leftPadding: 10
            rightPadding: 10
            topPadding: 30
            bottomPadding: 0
            onLinkActivated: Qt.openUrlExternally(link)
            text: fullCache.longDescription;
        }
        ScrollBar.vertical: ScrollBar {}
    }
}




