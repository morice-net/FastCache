import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: logPage

    Flickable {
        anchors.topMargin: 10
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height

        Column{
            spacing: 10
            x:10
            y:20

            GroupBox {
                id: found
                flat: true
                width: parent.width
                Column {
                    ExclusiveGroup { id: tabPositionGroup }

                    RadioButton {
                        checked: true
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Trouvée"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                                anchors.margins: 0
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Non trouvée"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Note"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Nécessite une maintenance"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }

                    RadioButton {
                        exclusiveGroup: tabPositionGroup
                        style: RadioButtonStyle {
                            label: Text {
                                text: "Nécessite d'être archivée"
                                font.family: localFont.name
                                font.pointSize: 16
                                color: control.checked ? Palette.white() : Palette.silver()
                            }
                            indicator: Rectangle {
                                y:10
                                implicitWidth: 25
                                implicitHeight: 25
                                radius: 10
                                border.width: 1
                                Rectangle {
                                    anchors.fill: parent
                                    visible: control.checked
                                    color: Palette.greenSea()
                                    radius: 10
                                    anchors.margins: 4
                                }
                            }
                        }
                    }
                }
            }

            Text {
                id: logDate
                width: parent.width
                font.family: localFont.name
                font.pointSize: 16
                text: "Date  " + new Date().toLocaleDateString(Qt.LocaleDate)
                color: Palette.white()
            }

            Calendar {
                id:calendar
                onClicked:logDate.text="Date  " + date.toLocaleDateString(Qt.LocaleDate)
                style: CalendarStyle {
                    gridVisible: false
                    background: Rectangle {
                        implicitHeight: fastCache.height / 2.6
                        implicitWidth: fastCache.width - 20
                        color: Palette.greenSea()
                        radius: 15
                    }
                    navigationBar: Item {
                        implicitHeight: fastCache.height * 0.06
                        Item {
                            height: parent.height
                            width: height
                            anchors.left: parent.left
                            Text {
                                anchors.centerIn: parent
                                font.family: localFont.name
                                font.pointSize: 32
                                text: "   <"
                                font.bold: true
                                color: Palette.white()
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: control.showPreviousMonth()
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            font.family: localFont.name
                            font.pointSize: 18
                            text: styleData.title
                            color: Palette.white()
                        }
                        Item {
                            height: parent.height
                            width: height
                            anchors.right: parent.right
                            Text {
                                anchors.centerIn: parent
                                font.family: localFont.name
                                font.pointSize: 32
                                text: ">   "
                                font.bold: true
                                color: Palette.white()
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: control.showNextMonth()
                            }
                        }
                    }

                    dayOfWeekDelegate: Item {
                        implicitHeight: fastCache.height * 0.06
                        Text {
                            anchors.centerIn: parent
                            font.family: localFont.name
                            font.pointSize: 16
                            color: Palette.white()
                            text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
                        }
                    }

                    dayDelegate: Rectangle {
                        color: styleData.visibleMonth && styleData.valid ? Palette.turquoise() : Palette.greenSea()
                        Rectangle {
                            width: parent.height
                            height: width
                            radius: height / 2
                            color:  Palette.greenSea()
                            border.color: styleData.selected ? Palette.white() : parent.color
                            border.width: 2
                            anchors.centerIn: parent
                        }

                        Label {
                            text: styleData.date.getDate()
                            anchors.centerIn: parent
                            color: (styleData.visibleMonth && styleData.valid) ? Palette.white() : Palette.turquoise()
                            font.family: localFont.name
                            font.bold: styleData.visibleMonth && styleData.valid
                            font.pointSize: 16
                        }
                    }
                }
            }

            Text {
                width: parent.width
                font.family: localFont.name
                font.pointSize: 16
                text: "Texte du Log"
                color: Palette.white()
            }

            Row {
                spacing: 10

                TextArea {
                    id: message
                    width: logPage.width*0.65
                    font.family: localFont.name
                    font.pointSize: 16
                    textColor: Palette.greenSea()
                }

                Button {
                    style: ButtonStyle {
                        label: Text {
                            text: "Envoyer le log"
                            font.family: localFont.name
                            font.pointSize: 16
                            color: Palette.greenSea()
                        }
                        background: Rectangle {
                            border.width: control.activeFocus ? 2 : 1
                            border.color: "#888"
                            radius: 4
                            gradient: Gradient {
                                GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                                GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                            }
                        }
                    }
                }
            }

            CheckBox {
                id :favorited
                x:10
                checked:false
                style: CheckBoxStyle {
                    label: Text {
                        text: "Ajouter cette cache à vos favoris"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: control.checked ? Palette.white() : Palette.silver()
                    }
                    indicator: Rectangle {
                        implicitWidth: 25
                        implicitHeight: 25
                        radius: 3
                        border.width: 1
                        Rectangle {
                            anchors.fill: parent
                            visible: control.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }
            }
        }
    }
}






