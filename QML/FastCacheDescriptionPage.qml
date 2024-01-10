import QtQuick
import QtQuick.Controls
import QtWebView

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: descriptionPage
    height: swipeFastCache.height

    property string descriptionText: fullCache.type !== "labCache" ? fullCache.shortDescription + fullCache.longDescription :
                                                                     fullCache.longDescription
    property bool codedHint: true
    property int gobackRank

    onDescriptionTextChanged: {
        gobackRank = -1
        if((main.state !== "recorded") || (main.state === "cachesActive")) {
            if(fullCache.type !== "labCache") {
                webView.loadHtml(descriptionText , "html")   // cacheGC ...
            } else {
                webView.url = descriptionText // lab cache
            }
        }
    }

    Flickable {
        id: shortLongDescription
        anchors.topMargin: fastCacheHeaderIcon.height * 1.3
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height + 15
        clip: true

        Column {
            width: descriptionPage.width
            spacing: 5
            topPadding: 15

            Text {
                visible: main.state === "recorded"
                clip: true
                width: parent.width * 0.95
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
                spacing: descriptionPage.width / 3
                anchors.horizontalCenter: parent.horizontalCenter
                bottomPadding: 10

                Button {
                    id: buttonGoback
                    icon.source: "qrc:/Image/goback.png"
                    icon.width: 40
                    icon.height: 30
                    onClicked:{
                        webView.goBack()
                        gobackRank = gobackRank -2
                        console.log("Go Back rank: " + gobackRank)
                    }
                    visible: webView != null ? webView.canGoBack && gobackRank >> 0 : false
                    background: Rectangle {
                        implicitWidth: descriptionPage.width / 3
                        color: "transparent"
                    }
                }

                Button {
                    id: buttonForward
                    icon.source: "qrc:/Image/forward.png"
                    icon.width: 40
                    icon.height: 30
                    onClicked:{
                        webView.goForward()
                        console.log("Go Back rank: " + gobackRank)
                    }
                    visible: webView != null ? webView.canGoForward && gobackRank >> 0  : false
                    background: Rectangle {
                        implicitWidth: descriptionPage.width / 3
                        color: "transparent"
                    }
                }
            }

            WebView {
                id: webView
                visible: main.state !== "recorded"
                width: parent.width * 0.95
                height: main.height * 0.7
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                onLoadingChanged: (loadRequest) => {
                                      if (loadRequest.status === WebView.LoadStartedStatus) {
                                          console.log("Load start: " + loadRequest.url)
                                          if(fullCache.type !== "labCache" && url.toString().indexOf("data:text/html") === 0 ) { //GC code with html
                                              gobackRank = gobackRank + 1
                                              console.log("Go Back rank: " + gobackRank)
                                          }
                                      } else if (loadRequest.status === WebView.LoadSucceededStatus) {
                                          console.log("Load succeeded: " + loadRequest.url)
                                          if(fullCache.type === "labCache" ||     //lab cache
                                             (fullCache.type !== "labCache" && url.toString().indexOf("data:text/html") !== 0)) { //internet with CG code
                                              gobackRank = gobackRank + 1
                                              console.log("Go Back rank: " + gobackRank)
                                          }
                                      } else if (loadRequest.status === WebView.LoadFailedStatus) {
                                          console.log("Load failed: " + loadRequest.url + ". Error code: " + loadRequest.errorString)
                                          if(url !== parseMalformedUrl(url)) { // redirection error for lab cache
                                              url = parseMalformedUrl(url)
                                          }
                                      }
                                  }
            }

            Rectangle {
                id: separator1
                visible: fullCache.type !== "labCache"
                width: parent.width * 0.95
                anchors.horizontalCenter: parent.horizontalCenter
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id: ind
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 14
                text: "INDICE"
                color: Palette.silver()
            }

            Image {
                source:"qrc:/Image/" + "icon_photo.png"
                scale: 0.7
                visible: fullCache.cacheImagesIndex[0] === 0  || fullCache.type === "labCache" ? false : true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        imagesCache();
                        swipeFastCache.setCurrentIndex(fastCache.imagesPageIndex) ;
                        fastCache.allVisible = false ;
                    }
                }
            }

            Text {
                id:hint
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.95
                font.family: localFont.name
                color: Palette.white()
                textFormat: Text.RichText
                wrapMode: Text.Wrap
                font.pointSize: 14
                onLinkActivated: Qt.openUrlExternally(link)
                text: codedHint ? Qt.btoa(fullCache.hints).substring(0, fullCache.hints.length) : fullCache.hints

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
                width: parent.width * 0.95
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id: note
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: localFont.name
                font.pointSize: 14
                text: "NOTE PERSONNELLE"
                color: Palette.silver()
            }

            FastButtonIcon {
                id: buttonDelete
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                height: 40
                width: 30
                source: "qrc:/Image/" + "icon_erase.png"
                onClicked: personalNote.text = ""
            }

            TextArea {
                id: personalNote
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * 0.9
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: fullCache.note
                color: Palette.greenSea()
                background: Rectangle {
                    implicitHeight: 100
                }
            }

            FastButton {
                id:buttonSend
                visible: fullCache.type !== "labCache"
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Envoyer"
                font.pointSize: 17
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

    function parseMalformedUrl(url) {            // parse the url because of a redirection bug on android for a lab cache.
        if(fullCache.type === "labCache" ) {
            var indexOfFirst = url.toString().indexOf("https://labs.geocaching.com/goto/"); // no correct url on android
            var indexOfSecond = url.toString().indexOf(";", indexOfFirst);
            console.log("URL parsed:  " + url.toString().substring(indexOfFirst, indexOfSecond))
            return url.toString().substring(indexOfFirst, indexOfSecond)
        }
        return url
    }
}
