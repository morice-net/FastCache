import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: imagesPage
    clip: true

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
                    model:displayImagesPage()

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

    function displayImagesPage() {
        if(fullCache.imagesName.length === 0){
            fastCache.removePage(imagesPage)
            return fullCache.imagesName.length
        } else {
            fastCache.addPage(imagesPage)
            // reorder pages
            if(swipeFastCache.count === 7){
                swipeFastCache.moveItem(6,5);
                return fullCache.imagesName.length
            }
            if(swipeFastCache.count === 8){
                swipeFastCache.moveItem(7,5);
                return fullCache.imagesName.length
            }
        }
    }
}











