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

    FastButton {
        id: buttonTraduct
        leftPadding: 5
        font.pointSize: 12
        text: "Traduction..."
    }

    ComboBox {
        id: langsCombo
        width: main.width * 0.3
        anchors.left: buttonTraduct.right
        anchors.margins: (translateText.width -  buttonTraduct.width - langsCombo.width - 10)
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

    ScrollView {
        anchors.top : langsCombo.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        topPadding: 15
        width: translateText.width * 0.95
        height: translateText.height * 0.9

        TextArea {
            font.family: localFont.name
            font.pointSize: 11
            text: translate
            color: Palette.greenSea()
            horizontalAlignment: TextEdit.AlignJustify
            textFormat: Qt.RichText
            wrapMode: TextArea.Wrap
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}

