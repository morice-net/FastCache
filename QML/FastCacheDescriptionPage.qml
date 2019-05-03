import QtQuick 2.6
import QtQuick.Controls 2.2

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: descriptionPage
    height: swipeFastCache.height

    Flickable {
        id: shortLongDescription
        anchors.topMargin: 29
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column {
            width: descriptionPage.width
            spacing: 20

            Text {
                clip:true
                width: parent.width
                font.family: localFont.name
                font.pointSize: 14
                horizontalAlignment: TextEdit.AlignJustify
                color: Palette.white()
                textFormat: Qt.RichText
                wrapMode: Text.Wrap
                minimumPointSize: 14
                leftPadding: 15
                rightPadding: 15
                topPadding: 25
                onLinkActivated: Qt.openUrlExternally(link)
                text: fullCache.shortDescription + fullCache.longDescription
            }

            Rectangle {
                id: separator1
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id:ind
                width: parent.width
                y:separator1.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "INDICE"
                color: Palette.silver()
            }

            Image {
                x: 15
                source:"qrc:/Image/" + "icon_photo.png"
                visible:fullCache.cacheImagesIndex[0] === 0 ? false : true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        imagesCache();
                        swipeFastCache.setCurrentIndex(5) ;
                        fastCache.allVisible = false ;
                    }
                }
            }

            Text {
                id:hint
                width: parent.width
                y:ind.y + 30
                font.family: localFont.name
                color: Palette.white()
                leftPadding: 15
                rightPadding: 15
                textFormat: Text.AutoText
                wrapMode: Text.Wrap
                font.pointSize: 14
                onLinkActivated: Qt.openUrlExternally(link)
                text: "****** *** ****** ********** *** ******** **********"

                MouseArea {
                    id: hintArea
                    anchors.fill: parent
                    onClicked: {
                        if (hint.text == "****** *** ****** ********** *** ******** **********")
                            hint.text = fullCache.hints
                        else
                            hint.text = "****** *** ****** ********** *** ******** **********"
                    }
                }
                onVisibleChanged: text = "****** *** ****** ********** *** ******** **********"
            }

            Rectangle {
                id: separator2
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id: note
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "NOTE PERSONNELLE"
                color: Palette.silver()
            }

            TextArea {
                id: personalNote
                x: 10
                width: parent.width - 20
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: fullCache.note
                color: Palette.greenSea()
                background: Rectangle {
                    anchors.fill: parent
                    opacity: 0.9
                    border.color: Palette.white()
                    border.width: 1
                    radius: 5
                }
            }

            Row {
                spacing: 10
                x: parent.width / 2
                Button {
                    id:buttonDel
                    contentItem: Text {
                        text:"Effacer"
                        font.family: localFont.name
                        font.pixelSize: 28
                        color: Palette.white()
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        opacity: 0.9
                        color: Palette.greenSea()
                        border.color: Palette.white()
                        border.width: 1
                        radius: 5
                    }
                    onClicked: personalNote.text = ""
                }

                Button {
                    id:buttonSend
                    contentItem: Text {
                        text:"Envoyer"
                        font.family: localFont.name
                        font.pixelSize: 28
                        color: Palette.white()
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        anchors.fill: parent
                        opacity: 0.9
                        color: Palette.greenSea()
                        border.color: Palette.white()
                        border.width: 1
                        radius: 5
                    }
                    onClicked: {
                        sendCacheNote.updateCacheNote(connector.tokenKey , fullCache.geocode ,personalNote.text);
                    }
                }
            }

            Text {
                id: spaceBottom
                width: parent.width
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "\n\n\n\n\n"
                color: Palette.white()
            }

            Rectangle {
                id: separator3
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }
        }
    }

    Rectangle {
        x:10
        width:main.width*0.9
        height: main.height*0.9
        color: Palette.greenSea()
        border.color: Palette.black()
        border.width: 1
        radius:10
        visible: sendCacheNote.state === "loading"

        Text {
            anchors.fill: parent
            font.family: localFont.name
            font.pointSize: 20
            text: "Loading....\n\n\n"
            color: Palette.white()

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: sendCacheNote.state === "loading"
        }
    }

    function imagesCache() {
        var visible =[];

        for (var i = 0; i < fullCache.imagesName.length; i++) {
            if( i < fullCache.cacheImagesIndex[0]){
                visible.push(true) ;
            } else {
                visible.push(false) ;
            }
        }
        fullCache.setListVisibleImages(visible);
        console.log("Images index:  " + fullCache.cacheImagesIndex)
        console.log("Visible Images:  " + fullCache.listVisibleImages)
    }
}

