import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: detailsPage
    height: swipeFastTravelbug.height

    Column {
        spacing: 5
        anchors.fill: parent
        anchors.topMargin: parent.height * 0.05
        clip: true

        Row {
            width: parent.width
            spacing: 15

            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Nom"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: travelbug.name
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15

            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Type"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: travelbug.type
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15

            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Code de suivi"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: travelbug.tbCode
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15

            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Propriétaire"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: travelbug.originalOwner
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15

            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Se situe"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: travelbug.located
                color: Palette.white()
            }
        }

        Row {
            width: parent.width
            spacing: 15

            Text {
                width: fastTravelbug.width * 0.25
                font.family: localFont.name
                horizontalAlignment: Text.AlignRight
                font.pointSize: 14
                text: "Libéré le"
                color: Palette.silver()
            }

            Text {
                font.family: localFont.name
                font.pointSize: 14
                text: formatDate(travelbug.dateCreated)
                color: Palette.white()
            }
        }
    }

    function formatDate(date) {
        var   substring = date.substring(date.indexOf("(") + 1 , date.indexOf(")"))
        return new Date(parseFloat(substring)).toLocaleDateString(Qt.locale("fr_FR"))
    }
}
