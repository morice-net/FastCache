import QtQuick 2.6
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.2

import "JavaScript/Palette.js" as Palette

Rectangle {
    id: imagesBrowser
    anchors.fill: parent
    anchors.topMargin: 40
    anchors.bottomMargin: anchors.topMargin/2
    anchors.rightMargin: anchors.topMargin/3
    anchors.leftMargin: anchors.topMargin/3
    z: 4
    clip: true
    color: Palette.turquoise()
    radius: 8
    focus: true

    FileDialog {
        id: fileDialog
        visible: fileDialogVisible.checked
        selectExisting: true
        nameFilters: [ "Image files (*.png *.jpg *.gif)" ]
        onAccepted: {
            console.log("Accepted: " + fileUrl)
        }
        onRejected: {
            console.log("Rejected")
        }
    }

    FastTextButton {
        id: fileDialogVisible
        buttonText: "Ajouter une image"
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            fileDialog.visible = true
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            left: parent.left
            right: parent.right
            top: fileDialogVisible.bottom
            leftMargin: 12
        }

        Column {
            topPadding: 10
            spacing: 10
            width: imagesBrowser.width

            Repeater{
                model: 1

                Row{
                    spacing: 40
                    width: imagesBrowser.width
                    topPadding: 10

                    TextArea {
                        id: description
                        placeholderText: "Description"
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
                        source: fileDialog.fileUrl
                        sourceSize.width: parent.width/4
                    }

                    Image {
                        id: deleteImage
                        source: "qrc:/Image/" + "icon_delete.png"
                        fillMode: Image.PreserveAspectFit
                        scale: 1.4

                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }
}

