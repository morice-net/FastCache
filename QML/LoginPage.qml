import QtQuick 2.3

import "JavaScript/Palette.js" as Palette

Rectangle {
    color: Palette.greenSea()

    state: "Unconnected"

    states: [
        State {
           name: "Unconnected"
           PropertyChanges { target: loginField; visible: true }
           PropertyChanges { target: passField; visible: true }
        },
        State {
            name: "Connecting"
            PropertyChanges { target: loginField; visible: false }
            PropertyChanges { target: passField; visible: false }
        }
       ]

    TextField {
        id: loginField
        fieldName: qsTr("Login")
        y: (parent.height-126)/2
        width: parent.width*2/3
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

        text: qsTr("Connect")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: Palette.white()
        font.pointSize: 16
        font.italic: true

        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            NumberAnimation { target: connectButton; property: "opacity"; from: 0; to: 1; duration: 1000; easing.type: "OutQuart" }
            NumberAnimation{ target: connectButton; property: "opacity"; from: 1; to: 0; duration: 1000; easing.type: "InQuart" }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //if (loginField.value !=  qsTr("Login") && passField.value != qsTr("Password")) {
                    state = "Connecting";
                    //main.connect(loginField.value,passField.value);
                main.connect("test","test");
                //}
            }
        }
    }

}
