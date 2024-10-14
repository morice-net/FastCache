import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: tbsPage
    clip: true

    Text {
        visible: fullCache.trackableCount === 0
        anchors.centerIn: parent
        text: "La page des travel bug est vide"
        font.family: localFont.name
        font.bold: true
        font.pointSize: 17
        color: Palette.white()
    }

    Flickable {
        id: travelbugs
        anchors.fill: parent
        anchors.topMargin: fastCacheHeaderIcon.height * 1.6
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        clip:true


        Column {
            spacing:10
            width: tbsPage.width
            leftPadding: 20

            Repeater {
                model: fullCache.trackableCount

                Column {
                    height: tbsPage.height * 0.1

                    Row {
                        height: tbsPage.height * 0.08

                        Image {
                            source: "../Image/" + "trackable_travelbug.png"
                            horizontalAlignment: Image.AlignHCenter
                        }

                        Text {
                            width: tbsPage.width
                            text: fullCache.trackableNames[index]
                            font.family: localFont.name
                            textFormat: Qt.RichText
                            font.bold: true
                            font.pointSize: 18
                            color: Palette.white()
                            wrapMode: Text.Wrap

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    travelbug.sendRequest(connector.tokenKey , fullCache.trackableCodes[index])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}




