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
    property alias button5Checked: button5.checked
    property alias button6Checked: button6.checked
    property alias button7Checked: button7.checked
    property alias button8Checked: button8.checked

    RadioButton {
        id:button1
        visible: (fastCache.updateLog || !(fullCache.found)) && !(fullCache.owner === userInfo.name)
        text: "Trouvée"
        checked: !(fullCache.found) && !(fullCache.owner === userInfo.name)
        onClicked: typeLog = 2
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
            implicitWidth: 18
            implicitHeight: 18
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
        visible: !(fullCache.owner === userInfo.name)
        text: "Non trouvée"
        onClicked: typeLog = 3
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
            implicitWidth: 18
            implicitHeight: 18
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
        visible: true
        checked: (fullCache.found) || (fullCache.owner === userInfo.name)
        text: "Note"
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
            implicitWidth: 18
            implicitHeight: 18
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
        visible: !(fullCache.owner === userInfo.name)
        text: "Nécessite une maintenance"
        onClicked: typeLog = 45
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
            implicitWidth: 18
            implicitHeight: 18
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

    RadioButton {
        id:button5
        visible: !(fullCache.owner === userInfo.name)
        text: "Nécessite d'être archivée"
        onClicked: typeLog = 7
        contentItem: Text {
            text: button5.text
            font.family: localFont.name
            font.pointSize: 16
            color: button5.checked ? Palette.white() : Palette.silver()
            leftPadding: button5.indicator.width + button5.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 18
            implicitHeight: 18
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button5.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    RadioButton {
        id:button6
        visible: (fullCache.owner === userInfo.name)
        text: "Maintenance effectuée"
        onClicked: typeLog = 46
        contentItem: Text {
            text: button6.text
            font.family: localFont.name
            font.pointSize: 16
            color: button6.checked ? Palette.white() : Palette.silver()
            leftPadding: button6.indicator.width + button6.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 18
            implicitHeight: 18
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button6.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    RadioButton {
        id:button7
        visible: (fullCache.owner === userInfo.name)
        text: "Désactivée"
        onClicked: typeLog = 22
        contentItem: Text {
            text: button7.text
            font.family: localFont.name
            font.pointSize: 16
            color: button7.checked ? Palette.white() : Palette.silver()
            leftPadding: button7.indicator.width + button7.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 18
            implicitHeight: 18
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button7.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }

    RadioButton {
        id:button8
        text: "Archivée"
        visible: (fullCache.owner === userInfo.name)
        onClicked: typeLog = 5
        contentItem: Text {
            text: button8.text
            font.family: localFont.name
            font.pointSize: 16
            color: button8.checked ? Palette.white() : Palette.silver()
            leftPadding: button8.indicator.width + button8.spacing
            verticalAlignment: Text.AlignVCenter
        }
        indicator: Rectangle {
            y: parent.height / 2 - height / 2
            implicitWidth: 18
            implicitHeight: 18
            radius: 10
            border.width: 1
            Rectangle {
                anchors.fill: parent
                visible: button8.checked
                color: Palette.greenSea()
                radius: 10
                anchors.margins: 4
            }
        }
    }
}
