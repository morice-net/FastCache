import QtQuick 2.6
import QtQuick.Controls 2.5
import QtWebView 1.1

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: descriptionPage
    height: swipeFastCache.height

    property string descriptionText: fullCache.shortDescription + fullCache.longDescription
    property int webHistoryRank: -1
    property bool codedHint: true

    onDescriptionTextChanged: {
        if((main.state !== "recorded") || (main.state === "cachesActive")) {
            webEngineView.loadHtml(descriptionText)
            webHistoryRank = -1
        }
    }

    Flickable {
        id: shortLongDescription
        anchors.topMargin: 30
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height + 50
        ScrollBar.vertical: ScrollBar {}

        Column {
            width: descriptionPage.width
            spacing: 20
            topPadding: 25

            Text {
                visible: main.state === "recorded"
                clip:true
                width: parent.width*0.95
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 14
                horizontalAlignment: TextEdit.AlignJustify
                color: Palette.white()
                textFormat: Qt.RichText
                wrapMode: Text.Wrap
                minimumPointSize: 14
                topPadding: 25
                onLinkActivated: Qt.openUrlExternally(link)
                text: fullCache.shortDescription + fullCache.longDescription
            }

            Row {
                visible: main.state !== "recorded"
                spacing: descriptionPage.width/3
                bottomPadding: 10

                Button {
                    icon.source: "qrc:/Image/goback.png"
                    icon.width: 45
                    icon.height: 45
                    onClicked:{
                        webEngineView.goBack()
                        webHistoryRank = webHistoryRank -2
                        console.log("web history rank:   " + webHistoryRank)
                    }
                    enabled: webEngineView.canGoBack && webHistoryRank >> 0
                    background: Rectangle {
                        implicitWidth: descriptionPage.width/3
                        color: "transparent"
                    }
                }

                Button {
                    icon.source: "qrc:/Image/forward.png"
                    icon.width: 45
                    icon.height: 45
                    onClicked:{
                        webEngineView.goForward()
                        console.log("web history rank:   " + webHistoryRank)
                    }
                    enabled: webEngineView.canGoForward
                    background: Rectangle {
                        implicitWidth: descriptionPage.width/3
                        color: "transparent"
                    }
                }
            }

            WebView {
                id: webEngineView
                clip: true
                visible: webViewDescriptionPageVisible
                width: parent.width*0.95
                anchors.horizontalCenter: parent.horizontalCenter
                height:  main.height*0.7
                onLoadingChanged: {
                    if (loadRequest.status == WebView.LoadSucceededStatus) {
                        console.log("Load succeeded: " )
                        webHistoryRank = webHistoryRank + 1
                        console.log("web history rank:   " + webHistoryRank)
                    }
                }
            }

            Rectangle {
                id: separator1
                width: parent.width*0.95
                anchors.horizontalCenter: parent.horizontalCenter
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id:ind
                anchors.horizontalCenter: parent.horizontalCenter
                y:separator1.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "INDICE"
                color: Palette.silver()
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
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
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.95
                y:ind.y + 30
                font.family: localFont.name
                color: Palette.white()
                textFormat: Text.AutoText
                wrapMode: Text.Wrap
                font.pointSize: 14
                onLinkActivated: Qt.openUrlExternally(link)
                text: textHint()

                MouseArea {
                    id: hintArea
                    anchors.fill: parent
                    onClicked: {
                        codedHint = !codedHint
                    }
                }
                onVisibleChanged: codedHint = true
            }

            Rectangle {
                width: parent.width*0.95
                anchors.horizontalCenter: parent.horizontalCenter
                height: 2
                color: Palette.white()
                radius:10
            }

            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: note
                    font.family: localFont.name
                    leftPadding: 15
                    font.pointSize: 14
                    text: "NOTE PERSONNELLE"
                    color: Palette.silver()
                }

                Item {
                    id: spacer
                    height: 2
                    width: descriptionPage.width*0.9 - note.width - buttonDelete.width - 30
                }

                Button {
                    id: buttonDelete
                    contentItem: Image {
                        source: "qrc:/Image/" + "icon_erase.png"
                    }
                    background: Rectangle {
                        border.width: buttonDelete.activeFocus ? 2 : 1
                        border.color: Palette.silver()
                        radius: 4
                    }
                    onClicked: personalNote.text = ""
                }
            }

            TextArea {
                id: personalNote
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.9
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: fullCache.note
                color: Palette.greenSea()
                background: Rectangle {
                    implicitHeight: 100
                }
            }

            Button {
                id:buttonSend
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text: "Envoyer"
                    font.family: localFont.name
                    font.pixelSize: 30
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
                    sendCacheNote.sendRequest(connector.tokenKey , fullCache.geocode , personalNote.text);
                }
            }
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

    function textHint() {
        if(codedHint)
            return Qt.btoa(fullCache.hints)
        else
            return fullCache.hints
    }
}

