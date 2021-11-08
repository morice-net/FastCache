import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item  {
    id: userLogsPage

    property var listLogs: initListLogs()

    property string geocode : fullCache.geocode
    onGeocodeChanged: {
        updateLog = false
        getUserGeocacheLogs.sendRequest(connector.tokenKey , fullCache.geocode)
    }

    Text {
        visible: getUserGeocacheLogs.referenceCodes.length ===0
        anchors.centerIn: parent
        text: "Pas de logs utilisateur"
        font.family: localFont.name
        font.bold: true
        font.pointSize: 17
        color: Palette.white()
    }

    ScrollView {
        id: logs
        anchors.fill: parent
        anchors.topMargin: 40
        contentHeight: columnLogs.height + 30
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip : true

        Column {
            id: columnLogs
            spacing:15
            width: userLogsPage.width

            FastTextButton {
                id: press
                anchors.horizontalCenter: parent.horizontalCenter
                buttonText:  "Cliquer pour rafraichir les logs"
                onClicked: {
                    getUserGeocacheLogs.sendRequest(connector.tokenKey , fullCache.geocode)
                    updateLog = false
                }
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

                    Column{
                        id: textLog
                        spacing: 15

                        Item {
                            width: parent.width*0.95
                            height: 35

                            Text {

                                Binding on text {
                                    when: true
                                    value: getUserGeocacheLogs.logsType[index]
                                }
                                topPadding: 10
                                leftPadding: 15
                                anchors.left: parent.left
                                font.family: localFont.name
                                font.pointSize: 13
                                color: Palette.black()
                                wrapMode: Text.Wrap
                            }

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
                        }

                        Item {
                            width: parent.width*0.95
                            height: 35

                            Image {
                                x:15
                                source: "qrc:/Image/" + "icon_photo.png"
                                visible: getUserGeocacheLogs.imagesCount[index] !== 0

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("clicked:")
                                    }
                                }
                            }

                            Text {
                                text: fullCache.favorited ? "Cette cache est dans vos favoris" : "Cette cache n'est pas dans vos favoris"
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                font.family: localFont.name
                                font.pointSize: 13
                                color: Palette.black()
                            }
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
                                id: iconUpdate
                                //   visible: false
                                contentItem: Image {
                                    source: "qrc:/Image/" + "icon_update.png"
                                }
                                background: Rectangle {
                                    border.width: iconUpdate.activeFocus ? 2 : 1
                                    border.color: Palette.silver()
                                    radius: 4
                                }
                                onClicked: {
                                    updateLog = true
                                    updateLogIndex = index
                                    logPage.typeLog = logPage.initTypeLog()
                                    // log page
                                    swipeFastCache.setCurrentIndex(6) ;
                                }
                                onPressAndHold: {
                                    updateLog = false
                                    updateLogIndex = index
                                    logPage.typeLog = logPage.initTypeLog()
                                }
                            }

                            Button {
                                id: iconAddImage
                                //     visible: false
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
                                //     visible: false
                                contentItem: Image {
                                    source: "qrc:/Image/" + "icon_delete.png"
                                }
                                background: Rectangle {
                                    border.width: iconDeleteLog.activeFocus ? 2 : 1
                                    border.color: Palette.silver()
                                    radius: 4
                                }
                                onClicked: {
                                    buttonYes.visible = true
                                    buttonNo.visible = true
                                }
                            }
                        }

                        // delete user log
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 25

                            FastTextButton {
                                id: buttonYes
                                visible: false
                                buttonText: "Supprimer le log ?"
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
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
