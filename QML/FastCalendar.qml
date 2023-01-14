import QtQuick 2.6
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Calendar {
    id:calendar

    property var dateCalendar

    onClicked:{
        dateCalendar = date
        calendar.visible = false
    }
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


