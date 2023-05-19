import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item  {
    id: userLogsPage

    property var listLogs: initListLogs()

    Text {
        visible: getUserGeocacheLogs.referenceCodes.length === 0
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
        anchors.topMargin: fastCacheHeaderIcon.height * 1.3
        contentHeight: columnLogs.height + 30
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip : true

        Column {
            id: columnLogs
            spacing:15
            width: userLogsPage.width

            Repeater{
                model: getUserGeocacheLogs.referenceCodes.length

                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.95
                    height: textLog.height + 10
                    border.width: 4
                    border.color: Palette.silver()
                    radius: 8

                    Column{
                        id: textLog
                        spacing: 15

                        Item {
                            width: parent.width * 0.95
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
                            width: parent.width * 0.95
                            height: 35

                            Image {
                                x:15
                                source: "qrc:/Image/" + "icon_photo.png"
                                scale: 0.7
                                visible: getUserGeocacheLogs.imagesCount[index] !== 0

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        updateLogIndex = index
                                        getGeocacheLogImages.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[index])
                                        userLogImages = true
                                        swipeToPage(imagesPageIndex)
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

                        Text {
                            id: log

                            Binding on text {
                                when: true
                                value: listLogs[index]
                            }
                            width: userLogsPage.width * 0.95
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
                            spacing: 30
                            anchors.horizontalCenter: parent.horizontalCenter

                            FastButtonIcon {
                                id: iconUpdate
                                source: "qrc:/Image/" + "icon_update.png"
                                height: 40
                                width: 30
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

                            FastButtonIcon {
                                id: iconDeleteLog
                                source: "qrc:/Image/" + "icon_delete.png"
                                height: 40
                                width: 30
                                onClicked: {
                                    buttonYes.visible = !buttonYes.visible
                                    buttonNo.visible = !buttonNo.visible
                                }
                            }
                        }

                        // delete user log
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 25

                            FastButton {
                                id: buttonYes
                                visible: false
                                font.pointSize: 17
                                text: "Supprimer le log ?"
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
                                    updateLogIndex = index
                                    sendEditUserLog.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[index])
                                }
                            }

                            FastButton {
                                id:buttonNo
                                visible: false
                                font.pointSize: 17
                                text: "Annuler"
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
