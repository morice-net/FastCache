import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebView 1.1
import Qt.labs.settings 1.0


import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Rectangle {
    id: fastMenuHeader
    color: Palette.greenSea()
    width: parent.width
    height: parent.height * 0.08

    Image {
        source: "qrc:/Image/menuIcon.png"
        y: parent.height*0.1
        x: y
        height: parent.height*0.8
        width: height

    }
}
