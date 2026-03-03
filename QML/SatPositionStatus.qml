import QtQuick
import QtQuick.Layouts

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: root

    property alias latitudeString: latValue.text
    property alias longitudeString: lonValue.text
    property alias statusString: statusValue.text
    property alias precisionString: precisionValue.text
    property alias altString: altValue.text
    property alias speedString: speedValue.text

    height: rootLayout.implicitHeight + rootLayout.anchors.bottomMargin

    RowLayout {
        id: rootLayout
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 10
            rightMargin: 10
            top: parent.top
        }
        spacing: 20

        Rectangle {
            id: rectangle
            Layout.fillWidth: true
            Layout.preferredHeight: posLayout.implicitHeight
            border {
                color: Palette.greenSea()
                width: 1
            }
            radius: 5

            GridLayout {
                id: posLayout

                property real actualHeight: implicitHeight

                anchors.fill: parent
                columns: 2
                columnSpacing: -3

                Text {
                    text: qsTr("Position courante")
                    font.family: localFont.name
                    font.pointSize: 15
                    color: Palette.greenSea()
                    Layout.alignment: Qt.AlignHCenter
                    Layout.columnSpan: 2
                }

                Text {
                    text: qsTr("lat:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: latValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }

                Text {
                    text: qsTr("lon:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: lonValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }

                Text {
                    text: qsTr("altitude:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: altValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }

                Text {
                    text: qsTr("vitesse:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: speedValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }

                Text {
                    text: qsTr("précision:")
                    font.family: localFont.name
                    font.pointSize: 13
                    color: Palette.greenSea()
                    leftPadding: 5
                }

                Text {
                    id: precisionValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: rectangle.Layout.preferredHeight
            border {
                color: Palette.greenSea()
                width: 1
            }
            radius: 5

            ColumnLayout {
                id: statusLayout
                property real actualHeight: implicitHeight + anchors.margins * 2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    margins: 5
                }

                Text {
                    text: qsTr("Statut")
                    font.family: localFont.name
                    font.pointSize: 15
                    color: Palette.greenSea()
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    id: statusValue
                    text: qsTr("N/A")
                    font.family: localFont.name
                    font.pointSize: 12
                    color: Palette.greenSea()
                    wrapMode: Text.WordWrap
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
