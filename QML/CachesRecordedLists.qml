import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: cachesRecordedLists

    property var cacheInLists : sqliteStorage.cacheInLists("cacheslists", fullCache.geocode)
    property var countLists : sqliteStorage.count("lists")

    width: parent.width * 0.9
    background: Rectangle {
        implicitWidth: 110
        implicitHeight: 200
        opacity: 0.8
        border.color: Palette.silver()
        color:Palette.greenSea()
        border.width: 1
        radius: 15
    }

    Column {
        spacing: 10

        Text {
            y: 10
            font.family: localFont.name
            font.pointSize: 24
            verticalAlignment: Text.AlignLeft
            horizontalAlignment: Text.AlignLeft
            color: Palette.white()
            text: "Choisir les listes.."
        }

        Repeater {
            model: countLists

            CheckBox {
                x:10
                checked:cacheInLists.indexOf(index + 1) > -1
                onCheckedChanged: {
                    if (checked && cacheInLists.length === 0) {
                        fullCacheRetriever.writeToStorage(sqliteStorage)
                        sqliteStorage.updateString("cacheslists" , index+1 , fullCache.geocode)
                        fullCache.registered
                        cacheInLists = sqliteStorage.cacheInLists("cacheslists", fullCache.geocode)
                    } else if (checked && cacheInLists.length !== 0) {
                        sqliteStorage.updateString("cacheslists" , index+1 , fullCache.geocode)
                        cacheInLists = sqliteStorage.cacheInLists("cacheslists", fullCache.geocode)
                    } else if (!checked && cacheInLists.length === 0) {
                        sqliteStorage.deleteString("cacheslists" , index+1);
                    } else if (!checked && cacheInLists.length !== 0) {
                        sqliteStorage.deleteString("cacheslists" , index+1);
                        if(cacheInLists.length === 1) {
                            fullCacheRetriever.deleteToStorage(sqliteStorage)
                                    !fullCache.registered
                        }
                        cacheInLists = sqliteStorage.cacheInLists("cacheslists", fullCache.geocode)
                    }
                }
                contentItem: Text {
                    text: sqliteStorage.readAllStringsFromTable("lists")[index]
                    font.family: localFont.name
                    font.pointSize: 16
                    color: checked ? Palette.white() : Palette.silver()
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: indicator.width + spacing
                }
                indicator: Rectangle {
                    implicitWidth: 25
                    implicitHeight: 25
                    radius: 3
                    border.width: 1
                    y: parent.height / 2 - height / 2
                    Rectangle {
                        anchors.fill: parent
                        visible: checked
                        color: Palette.greenSea()
                        radius: 3
                        anchors.margins: 4
                    }
                }
            }
        }

        Rectangle {
            id: separator1
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        CheckBox {
            id : newList
            x:10
            contentItem: Text {
                text: "Nouvelle liste"
                font.family: localFont.name
                font.pointSize: 16
                color: newList.checked ? Palette.white() : Palette.silver()
                verticalAlignment: Text.AlignVCenter
                leftPadding: newList.indicator.width + newList.spacing
            }
            indicator: Rectangle {
                implicitWidth: 25
                implicitHeight: 25
                radius: 3
                border.width: 1
                y: parent.height / 2 - height / 2
                Rectangle {
                    anchors.fill: parent
                    visible: newList.checked
                    color: Palette.greenSea()
                    radius: 3
                    anchors.margins: 4
                }
            }
        }

        TextField {
            id: createNewList
            visible: newList.checked
            placeholderText: qsTr("nouvelle liste")
            font.family: localFont.name
            font.pointSize: 16
            color: Palette.greenSea()
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                border.color: Palette.turquoise()
                border.width: 1
                radius: 5
            }
        }

        Button {
            id:buttonDel
            visible: newList.checked
            contentItem: Text {
                text:"Effacer"
                font.family: localFont.name
                font.pixelSize: 25
                color: Palette.white()
            }
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                color: Palette.greenSea()
                border.color: Palette.white()
                border.width: 1
                radius: 5
            }
            onClicked: {
                createNewList.text = "" ;
            }
        }

        Rectangle {
            id: separator2
            x:0
            width: cachesRecordedLists.width*0.9
            height: 2
            color: Palette.white()
            radius:10
        }

        Button {
            id:buttonCreate
            x:10
            contentItem: Text {
                text:"Ok"
                font.family: localFont.name
                font.pixelSize: 25
                color: Palette.white()
            }
            background: Rectangle {
                anchors.fill: parent
                opacity: 0.9
                color: Palette.greenSea()
                border.color: Palette.white()
                border.width: 1
                radius: 5
            }
            onClicked: {
                if (!newList.checked ) {
                    closeIfMenu()
                    cachesRecordedLists.close()
                } else if (newList.length === 0) {
                    closeIfMenu()
                    cachesRecordedLists.close()
                }
                sqliteStorage.updateString("lists" , countLists + 1 , newList.text )
                countLists = countLists + 1
                closeIfMenu()
                cachesRecordedLists.close()
            }
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}

