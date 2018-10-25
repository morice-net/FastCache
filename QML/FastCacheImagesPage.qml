import QtQuick 2.6
import QtQuick.Controls 2.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: imagesPage

    Flickable {
        id: images

        anchors.fill: parent
        anchors.topMargin: 25
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column{
            spacing:10
            width: imagesPage.width

            Repeater{
                model:fullCache.imagesName.length

                Column{

                    Text {
                        text: fullCache.imagesName[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.bold: true
                        font.pointSize: 15
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Text {
                        text: fullCache.imagesDescription[index]
                        leftPadding: 15
                        font.family: localFont.name
                        font.pointSize: 15
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Image {
                        source: fullCache.imagesUrl[index]
                        horizontalAlignment: Image.AlignHCenter
                    }
                }
            }
        }
    }
}









