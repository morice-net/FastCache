import QtQuick 2.0

/** Tested with

    TextField {
        id: loginField
        fieldName: qsTr("Login")
        width: parent.width/1.5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3 * ( height + 10 )
        anchors.horizontalCenter: parent.horizontalCenter
    }
    TextField {
        id: passField
        fieldName: qsTr("Password")
        width: loginField.width
        anchors.top: loginField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        secret: true
    }
*/
Item {
    id: textField
    height: 42

    property string fieldName
    property bool secret : false
    property string value : inputValue.text
    

    Rectangle {
        width: parent.width
        height: 1
        color: "#16a085"

        anchors.bottom: parent.bottom
        anchors.margins: 5
    }
    TextInput {
        id: inputValue
        anchors.fill: parent
        anchors.margins: 5
        text: parent.fieldName

        verticalAlignment: Text.AlignVCenter

        color: "#e1e3e4"
        font.pointSize: 16

        onFocusChanged: {
            if (focus) {
                text = "";
                color = "#f4f4f4";
                echoMode = textField.secret ? TextInput.Password : TextInput.Normal
            }
        }
    }
}
