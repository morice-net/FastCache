import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

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

    width: childrenRect.width
    height: childrenRect.height

    CheckBox {
        id: box
        visible: listBox.checkable
        onClicked: listBoxClicked()
        indicator: Rectangle {
            implicitWidth: 35
            implicitHeight: 35
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
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        anchors.left: box.right
        anchors.margins: 20
        color: !checkable || checked ? Palette.white() : Palette.silver()
    }

    Image {
        id: editList
        visible: editable
        source: "qrc:/Image/" + "icon_edit.png"
        anchors.right: deleteList.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.rightMargin: 20
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
        source: "qrc:/Image/" + "icon_delete.png"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.rightMargin: 20
        fillMode: Image.PreserveAspectFit
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: deleteListClicked()
        }
    }
}


