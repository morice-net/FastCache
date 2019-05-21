import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: detailsPage
     height: swipeFastTravelbug.height

    Column {
        spacing: 5
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.05
        clip: true

        Row {
            width: parent.width
            spacing: 15
            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Nom"
                color: Palette.silver()
            }
            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: travelbug.name
                color: Palette.white()
            }
        }
    }
}
