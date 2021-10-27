import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

FastPopup  {
    id: userLogs

    property int repeaterIndex: 0
    property var listLogs: initListLogs()

    x: (parent.width - userLogs.width)/2
    backgroundWidth: main.width*0.9
    backgroundHeight: Math.min(columnLogs.height + geocode.height + 40 , main.height*0.9)
    backgroundRadius: 8
    backgroundOpacity: 1
    closeButtonVisible: false

    Text {
        id: geocode
        anchors.horizontalCenter: parent.horizontalCenter
        text: getUserGeocacheLogs.referenceCodes.length !==0 ? getUserGeocacheLogs.geocodes[0] : "Pas de logs de cache ou erreur de géocode"
        font.family: localFont.name
        font.pointSize: 15
        color: Palette.black()
    }

    ScrollView {
        id: logs
        anchors.fill: parent
        anchors.topMargin: geocode.height + 10
        contentHeight: columnLogs.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip : true

        Column {
            id: columnLogs
            spacing:15
            width: userLogs.width

            Repeater{
                model: getUserGeocacheLogs.referenceCodes.length

                Rectangle{
                    width: parent.width*0.95
                    height: textLog.height + 10
                    border.width: 4
                    border.color: Palette.silver()
                    radius: 8

                    MouseArea {
                        anchors.fill: parent
                        onPressAndHold: {
                            repeaterIndex = index
                            log.readOnly= !log.readOnly
                            buttonDelete.visible = !buttonDelete.visible
                        }
                    }

                    Column{
                        id: textLog
                        spacing: 15

                        Text {
                            text: new Date(getUserGeocacheLogs.loggedDates[index]).toLocaleDateString(Qt.locale("fr_FR"))
                            topPadding: 10
                            leftPadding: 15
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.black()
                            wrapMode: Text.Wrap
                        }

                        Text {

                            Binding on text {
                                when: true
                                value: getUserGeocacheLogs.logsType[index]
                            }
                            leftPadding: 15
                            anchors.left: parent.left
                            font.family: localFont.name
                            font.pointSize: 13
                            color: Palette.black()
                            wrapMode: Text.Wrap
                        }

                        TextArea {
                            id: log
                            readOnly: true

                            Binding on text {
                                when: true
                                value: listLogs[index]
                            }
                            width: userLogs.width*0.95
                            leftPadding: 10
                            rightPadding: 10
                            font.family: localFont.name
                            font.pointSize: 15
                            horizontalAlignment: TextEdit.AlignJustify
                            color: log.readOnly === true ? Palette.greenSea() : Palette.silver()
                            textFormat: Qt.RichText
                            wrapMode: TextArea.Wrap
                            onLinkActivated: Qt.openUrlExternally(link)
                        }

                        Button {
                            id: buttonDelete
                            visible: false
                            anchors.horizontalCenter: parent.horizontalCenter
                            contentItem: Image {
                                source: "qrc:/Image/" + "icon_erase.png"
                            }
                            background: Rectangle {
                                border.width: buttonDelete.activeFocus ? 2 : 1
                                border.color: Palette.silver()
                                radius: 4
                            }
                            onClicked: {
                                log.text = ""
                            }
                        }
                    }
                }
            }
        }
    }

    function initListLogs() {
        var list = []
        for (var i = 0; i < getUserGeocacheLogs.logs.length; i++) {
            list.push(getUserGeocacheLogs.logs[i])
        }
        return list
    }
}

