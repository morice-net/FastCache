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
                id:found
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
                                color: Palette.white()
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
                                color: Palette.white()
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
                                color: Palette.white()
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
                                color: Palette.white()
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
                                color: Palette.white()
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
                    background: Rectangle {
                        implicitHeight: fastCache.height / 2.8
                        implicitWidth: fastCache.width * 0.7
                        color: Palette.greenSea()
                    }
                    gridVisible: false
                    dayDelegate: Rectangle {
                        gradient: Gradient {
                            GradientStop {
                                position: 0.00
                                color: styleData.selected ? Palette.greenSea() : (styleData.visibleMonth && styleData.valid ? Palette.backgroundGrey() : Palette.backgroundGrey());
                            }
                            GradientStop {
                                position: 1.00
                                color: styleData.selected ? Palette.backgroundGrey() : (styleData.visibleMonth && styleData.valid ? Palette.greenSea() : Palette.backgroundGrey());
                            }
                            GradientStop {
                                position: 1.00
                                color: styleData.selected ? Palette.silver() : (styleData.visibleMonth && styleData.valid ? Palette.turquoise() : Palette.backgroundGrey());
                            }
                        }

                        Label {
                            text: styleData.date.getDate()
                            anchors.centerIn: parent
                            color: styleData.valid ? Palette.white() : Palette.turquoise()
                        }

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: Palette.turquoise()
                            anchors.bottom: parent.bottom

                        }

                        Rectangle {
                            width: 1
                            height: parent.height
                            color: Palette.turquoise()
                            anchors.right: parent.right

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

            TextArea {
                id: message
                width: logPage.width -20
                font.family: localFont.name
                font.pointSize: 16
                textColor: Palette.greenSea()
                backgroundVisible: false

                Rectangle {
                    anchors.fill: parent
                    color: Palette.white()
                }
            }
        }
    }
}







