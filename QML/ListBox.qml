import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "JavaScript/Palette.js" as Palette

Item {
    id: listBox
    property bool checkable: true
    property bool editable: false

    property alias checked: box.checked
    property alias contentItem: box.contentItem
    property alias indicator: box.indicator
    property alias text: listBoxText.text

    signal listBoxClicked()
    signal deleteListClicked()
    signal editListClicked()

    width: main.width * 0.7
    height: box.height * 1.5

    CheckBox {
        id: box
        visible: listBox.checkable
        onClicked: listBoxClicked()
        indicator: Rectangle {
            implicitWidth: 25
            implicitHeight: 25
            radius: 3
            border.width: 1
            y: parent.height / 2 - height / 2
            Rectangle {
                anchors.fill: parent
                visible: checked
                color: Palette.greenSea()
                radius: 3
                anchors.margins: 4
            }
        }
        width: indicator.width + 2 * indicator.anchors.margins
        height: indicator.height + 2 * indicator.anchors.margins
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: listBoxText
        text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
        font.family: localFont.name
        font.pointSize: 17
        verticalAlignment: Text.AlignVCenter
        anchors.left: box.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: 20
        color: !checkable || checked ? Palette.white() : Palette.silver()
    }

    Image {
        id: editList
        visible: editable
        source: "../Image/" + "icon_edit.png"
        scale: 0.4
        anchors.right: deleteList.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.rightMargin: 10
        fillMode: Image.PreserveAspectFit
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: editListClicked()
        }
    }

    Image {
        id: deleteList
        visible: editable
        source: "../Image/" + "icon_delete.png"
        scale: 0.4
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.rightMargin: 5
        fillMode: Image.PreserveAspectFit
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: deleteListClicked()
        }
    }
}


