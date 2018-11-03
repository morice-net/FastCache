import QtQuick 2.6
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: imagesPage

    Flickable {
        id: images
        anchors.fill: parent
        anchors.topMargin: 35
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
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
                leftPadding: 15

                Repeater{
                    model:fullCache.imagesName.length

                    Column{

                        Text {
                            visible: fullCache.listVisibleImages[index]
                            text: fullCache.imagesName[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.bold: true
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap
                        }

                        Text {
                            visible: fullCache.listVisibleImages[index]
                            text: fullCache.imagesDescription[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.pointSize: 15
                            color: Palette.white()
                            wrapMode: Text.Wrap

                        }

                        Image {
                            visible: fullCache.listVisibleImages[index]
                            source: fullCache.imagesUrl[index]
                            horizontalAlignment: Image.AlignHCenter

                        }
                    }
                }
            }
        }
    }
}










