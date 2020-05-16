import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import "JavaScript/Palette.js" as Palette

Item {
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
        visible: checkable
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

    Text {
        id: listBoxText
        text: sqliteStorage.readAllStringsFromTable("lists")[index] + " [ " + sqliteStorage.countCachesInLists[index] + " ]"
        font.family: localFont.name
        font.pointSize: 20
        verticalAlignment: Text.AlignVCenter
        leftPadding: indicator.width + 25
        color: checked ? Palette.white() : Palette.silver()
    }

    Image {
        id: editList
        visible: editable
        source: "qrc:/Image/" + "icon_edit.png"
        anchors.right: deleteList.left
        anchors.bottom: box.bottom
        anchors.top: box.top
        anchors.rightMargin: 40
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
        anchors.bottom: box.bottom
        anchors.top: box.top
        anchors.rightMargin: 15
        fillMode: Image.PreserveAspectFit
        width: height

        MouseArea {
            anchors.fill: parent
            onClicked: deleteListClicked()
        }
    }

}


