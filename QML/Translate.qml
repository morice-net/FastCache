import QtQuick
import QtQuick.Controls
import FastCache

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
    property var listLangsAbbreviation: ["fr" ,"en" , "es" , "it" , "de" , "pt-PT"]

    Translator {
        id: translator
        onTranslateTextChanged: main.translate = translator.translateText
    }

    FastButton {
        id: buttonTraduct
        font.pointSize: 13
        text: "Traduction..."
        onClicked: {
            translate = textToTranslate.text
            translator.translate(translate , listLangsAbbreviation[langTarget.currentIndex]  , listLangsAbbreviation[langSource.currentIndex])
        }
    }

    ComboBox {
        id: langSource
        width: main.width * 0.25
        anchors.left: buttonTraduct.right
        anchors.margins: (translateText.width -  buttonTraduct.width - langSource.width - 20)
        model: listLangs
        delegate: ItemDelegate {
            width: langSource.width
            contentItem: Text {
                text: modelData
                color: Palette.turquoise()
                font.family: localFont.name
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        contentItem: Text {
            leftPadding: 20
            text: langSource.displayText
            font.family: localFont.name
            font.pointSize: 12
            color: Palette.turquoise()
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 30
            border.color: Palette.silver()
            border.width: 1
            radius: 8
        }
    }

    ComboBox {
        id: langTarget
        width: main.width * 0.25
        anchors.top: langSource.bottom
        anchors.left: langSource.left
        anchors.topMargin: 5
        model: listLangs
        delegate: ItemDelegate {
            width: langTarget.width
            contentItem: Text {
                text: modelData
                color: Palette.turquoise()
                font.family: localFont.name
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        contentItem: Text {
            leftPadding: 20
            text: langTarget.displayText
            font.family: localFont.name
            font.pointSize: 12
            color: Palette.turquoise()
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            implicitWidth: 120
            implicitHeight: 30
            border.color: Palette.silver()
            border.width: 1
            radius: 8
        }
    }

    ScrollView {
        anchors.top : langTarget.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        contentWidth: availableWidth
     //   ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        width: translateText.width * 0.95
        height: translateText.height * 0.8
        clip : true

        Text {
            id: textToTranslate
            width: translateText.width * 0.95
            font.family: localFont.name
            font.pointSize: 14
            text: translate
            color: Palette.white()
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

