import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: imagesPage
    clip: true

    Text {
        visible: userLogImages === false ? fullCache.imagesName.length === 0 : getGeocacheLogImages.descriptions.length === 0
        anchors.centerIn: parent
        text: "Il n'y a pas d'images"
        font.family: localFont.name
        font.bold: true
        font.pointSize: 17
        color: Palette.white()
    }

    Flickable {
        id: images
        anchors.fill: parent
        anchors.topMargin: 35
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height + 20
        ScrollBar.vertical: ScrollBar {}

        Loader {
            id:imagesLoader
            active: true
            sourceComponent: imagesComponent
        }

        Component{
            id:imagesComponent

            Column{
                spacing:10
                leftPadding: images.width*0.025

                Repeater{
                    model: userLogImages === false ? fullCache.imagesName.length : getGeocacheLogImages.descriptions.length

                    Column{
                        spacing: 10
                        Button {
                            id: iconDeleteImage
                            anchors.horizontalCenter: parent.horizontalCenter
                            contentItem: Image {
                                source: "qrc:/Image/" + "icon_delete.png"
                            }
                            background: Rectangle {
                                border.width: iconDeleteImage.activeFocus ? 2 : 1
                                border.color: Palette.silver()
                                radius: 4
                            }
                            onClicked: {
                                buttonYes.visible = !buttonYes.visible
                                buttonNo.visible = !buttonNo.visible
                            }
                        }

                        // delete user log image
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 25

                            FastTextButton {
                                id: buttonYes
                                visible: false
                                buttonText: "Supprimer l'image ?"
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
                                    deleteLogImage.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[updateLogIndex] ,
                                                               getGeocacheLogImages.guids[updateLogIndex])
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

                        Text {
                            width: images.width*0.95

                            Binding on visible {
                                when: true
                                value: userLogImages === false ? fullCache.listVisibleImages[index] : true
                            }
                            text: userLogImages === false ? fullCache.imagesName[index] : getGeocacheLogImages.descriptions[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                        }

                        Image {

                            Binding on visible {
                                when: true
                                value: userLogImages === false ? fullCache.listVisibleImages[index] : true
                            }

                            Binding on source {
                                when: true
                                value: userLogImages === false ? fullCache.imagesUrl[index] : getGeocacheLogImages.urls[index]
                            }
                            sourceSize.width: images.width*0.95
                        }
                    }
                }
            }
        }
    }
}











