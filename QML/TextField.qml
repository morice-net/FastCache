import QtQuick 2.3

import "JavaScript/Palette.js" as Palette

Item {
    id: textField
    height: 42

    property string fieldName
    property bool secret : false
    property string value : inputValue.text
    

    Rectangle {
        width: parent.width
        height: 1
        color: Palette.white()

        anchors.bottom: parent.bottom
        anchors.margins: 5
    }
    TextInput {
        id: inputValue
        anchors.fill: parent
        anchors.margins: 5
        text: parent.fieldName

        verticalAlignment: Text.AlignVCenter

        color: Palette.backgroundGrey()
        font.pointSize: 16
        font.family: localFont.name

        onFocusChanged: {
            if (focus) {
                text = "";
                color = Palette.white();
                echoMode = textField.secret ? TextInput.Password : TextInput.Normal
            }
        }
    }
}
