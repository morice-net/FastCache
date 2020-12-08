import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.2

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: imagesBrowser

    property var listImagesUrl: []
    property var listImagesDescription: []

    property int repeaterCount: 0

    anchors.fill: parent
    anchors.topMargin: 40
    anchors.bottomMargin: anchors.topMargin/2
    anchors.rightMargin: anchors.topMargin/3
    anchors.leftMargin: anchors.topMargin/3
    z: 4
    clip: true
    color: Palette.turquoise()
    radius: 8

    FileDialog {
        id: fileDialog
        visible: fileDialogVisible.checked
        selectExisting: true
        nameFilters: [ "Image files (*.png *.jpg *.gif)" ]
        onAccepted: {
            listImagesDescription.push("")
            listImagesUrl.push(fileUrl)
            repeaterCount = listImagesDescription.length
            console.log("Descriptions:  " + listImagesDescription)
            console.log("Urls:  " + listImagesUrl)
        }
        onRejected: {
            console.log("Rejected")
        }
    }

    Row {
        id: buttons
        spacing: 30
        anchors.horizontalCenter: parent.horizontalCenter

        FastTextButton {
            id: fileDialogVisible
            y: 10
            buttonText: "Ajouter une image"
            onClicked: {
                fileDialog.visible = true
            }
        }

        FastTextButton {
            id: closePage
            y: 10
            buttonText: "Fermer"
            onClicked: {
                console.log("Descriptions:  " + listImagesDescription)
                console.log("Urls:  " + listImagesUrl)
                imagesBrowser.visible = false
            }
        }
    }

    ScrollView {
        id: scrollView
        focus:true
        anchors {
            left: parent.left
            right: parent.right
            top: buttons.bottom
            leftMargin: 12
            topMargin: 20
        }

        Column {
            topPadding: 10
            spacing: 10
            width: imagesBrowser.width

            Repeater{
                model: repeaterCount
                delegate:
                    Row{
                    spacing: 40
                    width: imagesBrowser.width
                    topPadding: 10

                    TextArea {
                        id: description
                        placeholderText: "Description"
                        text: listImagesDescription[index]
                        onTextChanged: listImagesDescription[index] = description.text
                        width: parent.width/3
                        font.family: localFont.name
                        font.pointSize: 14
                        color: Palette.greenSea()
                        wrapMode: Text.Wrap
                        background: Rectangle {
                            radius: 5
                            implicitHeight: 50
                        }
                    }

                    Image {
                        id: image
                        visible: true
                        source: listImagesUrl[index]
                        sourceSize.width: parent.width/4
                    }

                    Image {
                        id: deleteImage
                        source: "qrc:/Image/" + "icon_delete.png"
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                listImagesUrl.splice(index , 1 )
                                listImagesDescription.splice(index , 1)
                                repeaterCount = listImagesDescription.length
                            }
                        }
                    }
                }
            }
        }
    }

    function addImagesToLog() {
        if(sendCacheLog.codeLog === "" || listImagesUrl.length === 0)
            return
        for (var i = 0; i <listImagesUrl.length; i++) {
            sendImagesLog.sendRequest(connector.tokenKey, sendCacheLog.codeLog, listImagesDescription[i], listImagesUrl[i])
        }
    }
}

