import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: imagesPage
    clip: true

    Button {
        id: buttonGoback
        visible: userLogImages === true
        icon.source: "../Image/icon_backwards.png"
        icon.width: 50
        icon.height: 50
        topPadding: 60
        leftPadding: 20
        onClicked:{
            onClicked: userLogImages = !userLogImages
        }
        background: Rectangle {
            color: "transparent"
        }
    }

    Text {
        visible: userLogImages === false ? fullCache.imagesName.length === 0 : getGeocacheLogImages.descriptions.length === 0
        anchors.centerIn: parent
        text: userLogImages === false ?  "Il n'y a pas d'images pour la cache" : "Il n'y a pas d'images pour le log utilisateur"
        font.family: localFont.name
        font.bold: true
        font.pointSize: 17
        color: Palette.white()
    }

    Flickable {
        id: images
        anchors.fill: parent
        anchors.topMargin: fastCacheHeaderIcon.height * 1.3
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height + 20
        clip: true

        Loader {
            id:imagesLoader
            active: true
            sourceComponent: imagesComponent
        }

        Component{
            id:imagesComponent

            Column{
                spacing:10
                leftPadding: images.width * 0.025

                Repeater{
                    model: userLogImages === false ? fullCache.imagesName.length : getGeocacheLogImages.descriptions.length

                    Column{
                        spacing: 10

                        FastButton {
                            id: iconDeleteImage
                            visible: userLogImages === true
                            anchors.horizontalCenter: parent.horizontalCenter
                            contentItem: Image {
                                source: "../Image/" + "icon_delete.png"
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

                            FastButton {
                                id: buttonYes
                                visible: false
                                text: "Supprimer l'image ?"
                                font.pointSize: 18
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
                                    deleteLogImage.sendRequest(connector.tokenKey , getUserGeocacheLogs.referenceCodes[updateLogIndex] ,
                                                               getGeocacheLogImages.guids[index])
                                }
                            }

                            FastButton {
                                id:buttonNo
                                visible: false
                                font.pointSize: 18
                                text: "Annuler"
                                onClicked: {
                                    buttonYes.visible = false
                                    buttonNo.visible = false
                                }
                            }
                        }

                        Text {
                            width: images.width * 0.95

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
                            sourceSize.width: images.width * 0.95
                        }
                    }
                }
            }
        }
    }
}











