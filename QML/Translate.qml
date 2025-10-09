import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: translateText
    closeButtonVisible: false
    backgroundRadius: 5
    width: main.width * 0.7
    height: main.height * 0.7
    x: 50
    y: 50

    property var listLangs: ["francais" ,"anglais" , "espagnol" , "italien" , "allemand" , "portugais"]

    Column {
        spacing: 20

        Row {
            spacing: 10

            FastButton {
                font.pointSize: 12
                text: "Traduction..."
            }

            ComboBox {
                id: langsCombo
                width: main.width * 0.3
                model: listLangs

                delegate: ItemDelegate {
                    width: langsCombo.width
                    contentItem: Text {
                        text: modelData
                        color: Palette.turquoise()
                        font.family: localFont.name
                        font.pointSize: 11
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                contentItem: Text {
                    leftPadding: 20
                    text: langsCombo.displayText
                    font.family: localFont.name
                    font.pointSize: 11
                    color: Palette.turquoise()
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Text {
            width: translateText.width *0.9
          //  height: main.height * 0.8
            text: translate
            color: Palette.white()
        }

        function closeIfMenu() {
            if (fastMenu.isMenuVisible())
                visible = false
        }
    }
}

