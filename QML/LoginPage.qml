import QtQuick 2.0

Rectangle {
    width: 480
    height: 640
    color: "#1abc9c"

    Text {
        anchors.fill: parent
        text: qsTr("\n\nFast caching")
        horizontalAlignment: Text.AlignHCenter
        color: "#f4f4f4"
        font.pointSize: 48
        font.underline: true
    }

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
    Text {
        id: connectButton
        height: loginField.height
        width: loginField.width
        anchors.top: passField.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 25

        text: qsTr("Connect")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: "#f4f4f4"
        font.pointSize: 16

        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            NumberAnimation { target: connectButton; property: "opacity"; from: 0; to: 1; duration: 1000; easing.type: "OutQuart" }
            NumberAnimation{ target: connectButton; property: "opacity"; from: 1; to: 0; duration: 1000; easing.type: "InQuart" }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: { console.log("Login: " + loginField.value + ", Password: " + passField.value) }
        }
    }

}
