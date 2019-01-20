import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    Text {
        anchors.centerIn: parent
        text: "Log Page"
        font.family: localFont.name
        textFormat: Qt.RichText
        font.pointSize: 15
        color: Palette.white()
        wrapMode: Text.Wrap
    }
}
