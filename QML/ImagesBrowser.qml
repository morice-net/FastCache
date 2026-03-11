import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: imagesBrowser

    property int repeaterCount: sqliteStorage.isCacheInTable("cachesimageslog", fullCache.geocode) ?
                                    sendImagesLog.readJsonArray(sqliteStorage.readColumnJson("cachesimageslog" , fullCache.geocode)).length : 0

    clip: true
    color: Palette.greenSea()
    border.width: 1
    border.color: Palette.silver()
    height: fastCache.height / 2.6

    FileDialog {
        id: fileDialog
        nameFilters: [ "Image files (*.png *.jpg *.gif)" ]
        onAccepted: {
            listImagesDescription.push("")
            listImagesUrl.push(fileDialog.currentFile)
            listImagesRotation.push(0)
            repeaterCount = listImagesDescription.length
            console.log("Descriptions:  " + listImagesDescription)
            console.log("Urls:  " + listImagesUrl)
            console.log("Rotations:  " + listImagesRotation)
        }
        onRejected: {
            console.log("Rejected")
        }
    }

    ScrollView {
        id: scrollView
        focus: true
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff      
        height: imagesBrowser.height - 10

        Column {
            id: repeaterColumn
            topPadding: 10
            spacing: 10
            width: imagesBrowser.width

            Repeater{
                model: repeaterCount
                delegate:

                    Row {
                    spacing: 40
                    width: imagesBrowser.width
                    height: 120
                    topPadding: 10
                    leftPadding: 10

                    TextArea {
                        id: description
                        text: listImagesDescription[index]
                        onTextChanged: listImagesDescription[index] = description.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        width: parent.width / 3
                        implicitHeight: 30
                        font.family: localFont.name
                        font.pointSize: 14
                        color: Palette.greenSea()
                        wrapMode: Text.Wrap
                        background: Rectangle {
                            radius: 5
                            implicitHeight: 40
                        }
                        cursorDelegate : CursorRectangle {
                            height : 30
                        }
                    }

                    Rectangle {
                        width: parent.width / 4
                        height: width
                        color: Palette.greenSea()

                        Image {
                            id: image
                            visible: true
                            anchors.fill: parent
                            width: parent.width
                            height: parent.height
                            source: listImagesUrl[index]
                            rotation: listImagesRotation[index]

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    listImagesRotation[index] = (listImagesRotation[index] + 90) % 360
                                    image.rotation = (image.rotation + 90) % 360
                                    console.log("Rotations:  " + listImagesRotation)
                                }
                            }
                        }
                    }

                    Image {
                        id: deleteImage
                        source: "../Image/" + "icon_delete.png"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                listImagesUrl.splice(index , 1 )
                                listImagesDescription.splice(index , 1)
                                listImagesRotation.splice(index , 1)
                                repeaterCount = listImagesDescription.length
                            }
                        }
                    }
                }
            }
        }
    }

    function openDialog() {
        fileDialog.open()
    }

    function closeDialog() {
        fileDialog.close()
    }
}

