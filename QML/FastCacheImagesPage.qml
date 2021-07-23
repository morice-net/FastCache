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
                width: imagesPage.width
                leftPadding: 10

                Repeater{
                    model: fullCache.imagesName.length

                    Column{

                        Text {
                            width: imagesPage.width*0.95
                            visible: fullCache.listVisibleImages.length !== 0 ? fullCache.listVisibleImages[index] : false
                            text: fullCache.imagesName[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                        }

                        Image {
                            visible: fullCache.listVisibleImages.length !== 0 ? fullCache.listVisibleImages[index] : false
                            source: fullCache.imagesUrl.length !== 0 ? fullCache.imagesUrl[index] : ""
                            horizontalAlignment: Image.AlignHCenter
                            sourceSize.width: parent.width
                        }
                    }
                }
            }
        }
    }
}











