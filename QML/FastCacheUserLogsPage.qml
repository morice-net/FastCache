import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item  {
    id: userLogsPage

    property var listLogs: initListLogs()

    // editLog = 0 delete log, editLog = 1 update log
    property int editLog

    ScrollView {
        id: logs
        anchors.fill: parent
        anchors.topMargin: 40
        contentHeight: contentItem.childrenRect.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip : true

        Column {
            id: columnLogs
            spacing:15
            width: userLogsPage.width

            Button {
                id: press
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 15
                 text: "Clic pour obtenir les logs utilisateur de la cache"
                contentItem: Text {
                    text: "Clic pour obtenir les logs utilisateur de la cache"
                    color: Palette.greenSea()
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    color: Palette.white()
                    border.color: Palette.greenSea()
                    border.width: 1
                    radius: 5
                }

                onClicked: {
                    getUserGeocacheLogs.sendRequest(connector.tokenKey , fullCache.geocode)
                }
            }

            Text {
                id: geocode
                anchors.horizontalCenter: parent.horizontalCenter
                text: getUserGeocacheLogs.referenceCodes.length !==0 ? getUserGeocacheLogs.geocodes[0] : "Pas de logs de cache ou erreur de géocode"
                font.family: localFont.name
                font.pointSize: 15
                color: Palette.black()
            }

            Repeater{
                model: getUserGeocacheLogs.referenceCodes.length

                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width*0.95
                    height: textLog.height + 10
                    border.width: 4
                    border.color: Palette.silver()
                    radius: 8

                    MouseArea {
                        anchors.fill: parent
                        onPressAndHold: {
                            iconDelete.visible = !iconDelete.visible
                            iconUpdate.visible = !iconUpdate.visible
                            iconAddImage.visible = !iconAddImage.visible
                            iconDeleteLog.visible =! iconDeleteLog.visible
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

                            Binding on text {
                                when: true
                                value: listLogs[index]
                            }
                            width: userLogsPage.width*0.95
                            leftPadding: 10
                            rightPadding: 10
                            font.family: localFont.name
                            font.pointSize: 15
                            horizontalAlignment: TextEdit.AlignJustify
                            color: Palette.greenSea()
                            textFormat: Qt.RichText
                            wrapMode: TextArea.Wrap
                            onLinkActivated: Qt.openUrlExternally(link)
                        }

                        // icons
                        Row {
                            spacing: 20
                            anchors.horizontalCenter: parent.horizontalCenter

                            Button {
                                id: iconDelete
                                visible: false
                                contentItem: Image {
                                    source: "qrc:/Image/" + "icon_erase.png"
                                }
                                background: Rectangle {
                                    border.width: iconDelete.activeFocus ? 2 : 1
                                    border.color: Palette.silver()
                                    radius: 4
                                }
                                onClicked: {
                                    log.text = ""
                                }
                            }

                            Button {
                                id: iconUpdate
                                visible: false
                                contentItem: Image {
                                    source: "qrc:/Image/" + "icon_update.png"
                                }
                                background: Rectangle {
                                    border.width: iconUpdate.activeFocus ? 2 : 1
                                    border.color: Palette.silver()
                                    radius: 4
                                }
                                onClicked: {
                                    editLog = 1
                                    buttonYes.visible = true
                                    buttonNo.visible = true
                                }
                            }

                            Button {
                                id: iconAddImage
                                visible: false
                                contentItem: Image {
                                    source: "qrc:/Image/" + "icon_addImage.png"
                                }
                                background: Rectangle {
                                    border.width: iconAddImage.activeFocus ? 2 : 1
                                    border.color: Palette.silver()
                                    radius: 4
                                }
                                onClicked: {
                                }
                            }

                            Button {
                                id: iconDeleteLog
                                visible: false
                                contentItem: Image {
                                    source: "qrc:/Image/" + "icon_delete.png"
                                }
                                background: Rectangle {
                                    border.width: iconDeleteLog.activeFocus ? 2 : 1
                                    border.color: Palette.silver()
                                    radius: 4
                                }
                                onClicked: {
                                    editLog = 0
                                    buttonYes.visible = true
                                    buttonNo.visible = true
                                }
                            }
                        }

                        // delete or update user log
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 25

                            FastTextButton {
                                id: buttonYes
                                visible: false
                                buttonText: editLog === 0 ? "Supprimer le log ?" : "Modifier le log ?"
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
                                    //update log
                                    if(editLog === 1) {
                                        sendEditUserLog.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[index] , log.text)


                                    }
                                }
                            }

                            FastTextButton {
                                id:buttonNo
                                visible: false
                                buttonText: "Annuler"
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
                                }
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
