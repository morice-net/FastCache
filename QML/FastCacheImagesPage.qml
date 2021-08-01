import QtQuick 2.6
import QtQuick.Controls 2.5

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: imagesPage
    clip: true

    Text {
        visible: fullCache.imagesName.length === 0
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
                    model: fullCache.imagesName.length

                    Column{

                        Text {
                            width: images.width*0.95

                            Binding on visible {
                                when: true
                                value: fullCache.listVisibleImages[index]
                            }
                            text: fullCache.imagesName[index]
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
                                value: fullCache.listVisibleImages[index]
                            }

                            Binding on source {
                                when: true
                                value: fullCache.imagesUrl[index]
                            }
                            sourceSize.width: images.width*0.95
                        }
                    }
                }
            }
        }
    }
}











