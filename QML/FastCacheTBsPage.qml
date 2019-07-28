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

            Repeater {
                model:displayTbsPage()

                Column {
                    width: tbsPage.width
                    height: tbsPage.height * 0.1

                    Row {
                        height: tbsPage.height * 0.08

                        Image {
                            source: "qrc:/Image/" + "trackable_travelbug.png"
                            horizontalAlignment: Image.AlignHCenter
                            scale: 1.4
                        }

                        Text {
                            text: fullCache.trackableNames[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.bold: true
                            font.pointSize: 20
                            color: Palette.white()
                            wrapMode: Text.Wrap

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    travelbug.sendRequest(connector.tokenKey , fullCache.trackableCodes[index]);
                                    main.viewState = "travelbug"
                                }
                            }
                        }

                    }
                    Rectangle {
                        height: 1
                        width: parent.width*0.6
                        color: Palette.silver()
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
    }

    function displayTbsPage() {
        if (fullCache.tackableCount === 0) {
            fastCache.removePage(tbsPage)
        } else {
            fastCache.addPage(tbsPage)
        }
        return fullCache.tackableCount
    }
}




