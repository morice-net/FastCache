import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Column {
    id: groupBox
    spacing: -15

    property alias button1Checked: button1.checked
    property alias button2Checked: button2.checked
    property alias button3Checked: button3.checked
    property alias button4Checked: button4.checked

    RadioButton {
        id:button1
        text: "Récupéré"
        visible: travelbug.tbStatus === 1 //travelbug in cache
        checked: false
        onClicked: typeLog = 13
        contentItem: Text {
            text: button1.text
            font.family: localFont.name
            font.pointSize: 16
            color: button1.checked ? Palette.white() : Palette.silver()
            leftPadding: button1.indicator.width + button1.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 25
            implicitHeight: 25
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button1.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    RadioButton {
        id:button2
        text: "Pris ailleurs"
        //travelbug in possession of owner or holder of the trackable and not in possession of user
        visible: (travelbug.tbStatus === 2 || travelbug.tbStatus === 3) && travelbug.located !== userInfo.name
        checked: false
        onClicked: typeLog = 19
        contentItem: Text {
            text: button2.text
            font.family: localFont.name
            font.pointSize: 16
            color: button2.checked ? Palette.white() : Palette.silver()
            leftPadding: button2.indicator.width + button2.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 25
            implicitHeight: 25
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button2.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    RadioButton {
        id:button3
        text: "Note"
        visible:true
        checked: true
        onClicked: typeLog = 4
        contentItem: Text {
            text: button3.text
            font.family: localFont.name
            font.pointSize: 16
            color: button3.checked ? Palette.white() : Palette.silver()
            leftPadding: button3.indicator.width + button3.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 25
            implicitHeight: 25
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button3.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    RadioButton {
        id:button4
        text: "Découvert"
        visible: ((travelbug.tbStatus === 2 || travelbug.tbStatus === 3) && travelbug.located !== userInfo.name) ||
                 travelbug.tbStatus === 1
        checked: false
        onClicked: typeLog = 48
        contentItem: Text {
            text: button4.text
            font.family: localFont.name
            font.pointSize: 16
            color: button4.checked ? Palette.white() : Palette.silver()
            leftPadding: button4.indicator.width + button4.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 25
            implicitHeight: 25
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button4.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }
}

