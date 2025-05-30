import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id: logsPage

    Flickable {
        id: logs
        anchors.fill: parent
        anchors.topMargin: fastCacheHeaderIcon.height * 1.3
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        clip :true

        Column{
            spacing:15
            width: logsPage.width

            Repeater{
                model:fullCache.logs.length

                Rectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.95
                    height: textLog.height + 10
                    border.width: 2
                    border.color: Palette.silver()
                    radius: 8

                    Column{
                        id: textLog
                        spacing: 5

                        Item {
                            width: parent.width * 0.95
                            height: 35

                            Text {
                                topPadding: 10
                                leftPadding: 15
                                anchors.left: parent.left

                                Binding on text {
                                    when: true
                                    value: fullCache.findersName[index]
                                }
                                font.family: localFont.name
                                font.bold: true
                                font.pointSize: 15
                                color: Palette.blueGreen()
                                wrapMode: Text.Wrap

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        ownerProfile.originalUrl = fullCache.findersUrl[index]
                                        ownerProfile.open()
                                    }
                                }
                            }

                            Text {
                                text: new Date(fullCache.findersDate[index]).toLocaleDateString(Qt.locale("fr_FR"))
                                topPadding: 10
                                leftPadding: 15
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                font.family: localFont.name
                                font.pointSize: 13
                                color: Palette.black()
                                wrapMode: Text.Wrap
                            }
                        }

                        Item {
                            width: parent.width * 0.95
                            height: 35

                            Text {

                                Binding on text {
                                    when: true
                                    value: fullCache.logsType[index]
                                }
                                leftPadding: 15
                                anchors.left: parent.left
                                font.family: localFont.name
                                font.pointSize: 13
                                color: Palette.black()
                                wrapMode: Text.Wrap
                            }

                            Text {
                                text: "Nombre de caches:  " + fullCache.findersCount[index]
                                leftPadding: 15
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                font.family: localFont.name
                                font.pointSize: 13
                                color: Palette.black()
                                wrapMode: Text.Wrap
                            }
                        }

                        Image {
                            x:15
                            source:"../Image/" + "icon_photo.png"
                            scale: 0.7
                            visible:(fullCache.cacheImagesIndex[index + 1] - fullCache.cacheImagesIndex[index]) === 0 ? false : true

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    imagesLog(index);
                                    swipeFastCache.setCurrentIndex(fastCache.imagesPageIndex) ;
                                    fastCache.allVisible = false ;
                                }
                            }
                        }

                        Text {
                            width: logsPage.width * 0.95
                            leftPadding: 10
                            rightPadding: 10
                            font.family: localFont.name
                            font.pointSize: 15
                            horizontalAlignment: TextEdit.AlignJustify
                            color: Palette.greenSea()
                            textFormat: Qt.RichText
                            wrapMode: TextArea.Wrap
                            onLinkActivated: Qt.openUrlExternally(link)
                            text: fullCache.logs[index]
                        }
                    }
                }
            }
        }
    }

    function imagesLog(logIndex) {
        var visible =[];
        for (var i = 0; i < fullCache.imagesName.length; i++) {
            if( i < fullCache.cacheImagesIndex[logIndex]){
                visible.push(false) ;
            } else {
                if( i >= fullCache.cacheImagesIndex[logIndex] && i < fullCache.cacheImagesIndex[logIndex + 1]){
                    visible.push(true) ;
                } else {
                    visible.push(false) ;
                }
            }
        }
        fullCache.setListVisibleImages(visible);
        console.log("Images index:  " + fullCache.cacheImagesIndex)
        console.log("Visible Images:  " + fullCache.listVisibleImages)
    }
}

