import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.3
import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0

import "JavaScript/Palette.js" as Palette


Popup {
    id:geocode

    background: Rectangle {
        x:20
        y:20
        implicitWidth: main.width*0.8
        implicitHeight:main.height*0.4
        color:Palette.backgroundGrey()
        border.color: Palette.greenSea()
        border.width: 1
        opacity:0.9
        radius: 10
    }

    ColumnLayout {
        id: tabRectangle
        y: 20
        height: tabTitle.height * 2
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.left: parent.left
        anchors.right: parent.right

        Label {
            id: tabTitle
            color: Palette.black()
            text: qsTr("Adresse")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        id: item2
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.bottomMargin: 20
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: tabRectangle.bottom

        GridLayout {
            id: gridLayout3
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            rowSpacing: 10
            rows: 1
            columns: 2
            anchors.fill: parent

            Label {
                id: label2
                text: qsTr("Rue")
            }

            TextField {
                id: street
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: street.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label3
                text: qsTr("Ville")
            }

            TextField {
                id: city
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: city.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label4
                text: qsTr("Etat")
            }

            TextField {
                id: stateName
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: stateName.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label5
                text: qsTr("Pays")
            }

            TextField {
                id: country
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: country.focus ? Palette.black() :Palette.turquoise()
                }
            }

            Label {
                id: label6
                text: qsTr("Code postal")
            }

            TextField {
                id: postalCode
                Layout.fillWidth: true
                background: Rectangle {
                    implicitWidth: main.width/2.2
                    radius:10
                    border.color: postalCode.focus ? Palette.black() :Palette.turquoise()
                }
            }

            RowLayout {
                id: rowLayout1
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignRight

                Button {
                    id: goButton
                    text: qsTr("Ok")
                    background: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 5
                        opacity: 0.9
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
                    onClicked: {
                 //       address.street = street.text
                  //      address.city = city.text
                  //      address.state = stateName.text
                  //      address.country = country.text
                   //     address.postalCode = postalCode.text
                  //      showPlace(address)
                    }
                }

                Button {
                    id: clearButton
                    text: qsTr("Effacer")
                    background: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 5
                        opacity: 0.9
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
                    onClicked: {
                        street.text = ""
                        city.text = ""
                        stateName.text = ""
                        country.text = ""
                        postalCode.text = ""
                    }
                }

                Button {
                    id: cancelButton
                    text: qsTr("Annuler")
                    background: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 5
                        opacity: 0.9
                        border.color: Palette.greenSea()
                        border.width: 1
                        radius: 5
                    }
                    onClicked: {
                   //     closeForm()
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.columnSpan: 2
            }
        }
    }

    Component.onCompleted: {
   //     street.text = address.street
    //    city.text = address.city
    //    stateName.text = address.state
    //    country.text = address.country
   //     postalCode.text = address.postalCode
    }
}
