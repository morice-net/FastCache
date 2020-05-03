import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import "JavaScript/Palette.js" as Palette

Item {

    property alias checked: box.checked
    property alias contentItem: box.contentItem
    property alias indicator: box.indicator
    property alias visibleEditList: editList.visible
    property alias visibleDeleteList: deleteList.visible

    signal listBoxClicked()
    signal deleteListClicked()
    signal editListClicked()

    width: parent.width
    height: box.height

    CheckBox {
        id: box
        onClicked: listBoxClicked()
        indicator: Rectangle {
            implicitWidth: 30
            implicitHeight: 30
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
    }

    Image {
        id: deleteList
        source: "qrc:/Image/" + "icon_delete.png"
        anchors.right: parent.right
        anchors.bottom: box.bottom
        anchors.rightMargin: 5
        scale: 1.1

        MouseArea {
            anchors.fill: parent
            onClicked: deleteListClicked()
        }
    }

    Image {
        id: editList
        source: "qrc:/Image/" + "icon_edit.png"
        anchors.right: deleteList.left
        anchors.bottom: box.bottom
        anchors.rightMargin: 40
        scale: 1.1

        MouseArea {
            anchors.fill: parent
            onClicked: editListClicked()
        }
    }
}


