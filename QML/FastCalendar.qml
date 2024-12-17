import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Rectangle {
    id:calendar
    height: fastCache.height / 2.6
    width: fastCache.width - 20
    color: Palette.greenSea()
    border.width: 1
    border.color: Palette.silver()

    property var dateCalendar

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: calendar.width/4
        leftPadding: 10
        rightPadding: 10

        Text {
            font.family: localFont.name
            font.pointSize: 25
            font.bold: true
            color: Palette.white()
            text: "<"

            MouseArea {
                anchors.fill: parent
                onClicked: monthLag(-1)
            }
        }

        Text {
            id: middle
            width: calendar.width/4
            font.pointSize: 16
            font.family: localFont.name
            font.bold: true
            color: Palette.white()
            text: monthGrid.title
        }

        Text {
            font.family: localFont.name
            font.pointSize: 25
            font.bold: true
            color: Palette.white()
            text: ">"

            MouseArea {
                anchors.fill: parent
                onClicked: monthLag(1)
            }
        }
    }

    DayOfWeekRow {
        id: day
        anchors.fill: parent
        topPadding: middle.height
        locale: monthGrid.locale
        delegate: Text {
            text: shortName
            font.pointSize: monthGrid.font.pointSize
            color: Palette.white()
            horizontalAlignment: Text.AlignHCenter

            required property string shortName
        }
    }

    Item {
        anchors.bottom: calendar.bottom
        width: calendar.width
        height: calendar.height*0.8

        MonthGrid {
            id: monthGrid
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            month: dateCalendar !== undefined ? new Date(dateCalendar.toISOString()).getMonth() : new Date().getMonth()
            year: dateCalendar !== undefined ? new Date(dateCalendar.toISOString()).getFullYear() : new Date().getFullYear()
            locale: Qt.locale("fr")
            delegate: Text {
                color: Palette.white()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: model.month === monthGrid.month ? 1 : 0.5
                text: monthGrid.locale.toString(model.date, "d")
                font.pointSize: monthGrid.font.pointSize

                required property var model
            }
            onClicked:{
                dateCalendar = date
                calendar.visible = false
            }
        }
    }

    function monthLag(lag) {
        if(lag === 1)
            if(monthGrid.month !== 11) {
                monthGrid.month = monthGrid.month + 1
                return
            } else {
                monthGrid.month = 0
                monthGrid.year = monthGrid.year + 1
                return
            }
        if(lag === -1)
            if(monthGrid.month !== 0) {
                monthGrid.month = monthGrid.month - 1
                return
            } else {
                monthGrid.month = 11
                monthGrid.year = monthGrid.year - 1
                return
            }
    }
}



