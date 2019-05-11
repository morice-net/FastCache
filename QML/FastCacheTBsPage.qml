import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: tbsPage
    clip: true

    Flickable {
        id: travelbugs
        anchors.fill: parent
        anchors.topMargin: 50
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column{
            spacing:10
            width: tbsPage.width
            leftPadding: 20

            Repeater{
                model:displayTbsPage()

                Column{

                    Image {
                        source: "qrc:/Image/" + "trackable_travelbug.png"
                        horizontalAlignment: Image.AlignHCenter
                    }

                    Text {
                        text: fullCache.names[index]
                        font.family: localFont.name
                        textFormat: Qt.RichText
                        font.bold: true
                        font.pointSize: 20
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }

    function displayTbsPage() {
        if(fullCache.tackableCount === 0){
            fastCache.removePage(tbsPage)
        } else {
            fastCache.addPage(tbsPage)
        }
        return fullCache.tackableCount
    }
}




