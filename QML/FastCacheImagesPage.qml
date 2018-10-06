import QtQuick 2.6
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0


Item {
    id: imagesPage
    Text {
        id: imagesText
        anchors.fill: parent
        font.family: localFont.name
        font.pointSize: 20
        text: "Images"
        color: Palette.white()

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
