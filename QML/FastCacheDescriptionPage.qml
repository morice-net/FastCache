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

    property alias webViewOpacity: webEngineView.opacity

    onDescriptionTextChanged: {
        if((main.state !== "recorded") || (main.cachesActive === true)) {
            webEngineView.loadHtml(descriptionText)
            webHistoryRank = -1
        }
    }

    Flickable {
        id: shortLongDescription
        anchors.topMargin: 30
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height + 20
        ScrollBar.vertical: ScrollBar {}

        Column {
            width: descriptionPage.width
            spacing: 20
            topPadding: 25

            Text {
                visible: (main.state === "recorded") && (main.cachesActive === false)
                clip:true
                width: parent.width
                leftPadding: 20
                rightPadding: 20
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
                visible: (main.state !== "recorded") || (main.cachesActive === true)
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
                width: parent.width
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
                        sendCacheNote.sendRequest(connector.tokenKey , fullCache.geocode , personalNote.text);
                    }
                }
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

