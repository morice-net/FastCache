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
    property bool goBackWeb: false

    onDescriptionTextChanged: {
        goBackWeb = false
        webView.settings.setAllowFileAccess(true)
        if(main.state === "recorded" ) {  // cache recorded
            webView.loadHtml(descriptionText , "file:")
        } else  {   // lab cache not recorded
            webView.loadHtml(descriptionText , "html")
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

            Row {
                visible: fullCache.geocode.substring(0,2) === "GC"
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
                        console.log("Go Back Web: " + goBackWeb)

                    }
                    visible: webView != null ? webView.canGoBack && goBackWeb : false
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
                        console.log("Go Back Web: " + goBackWeb)
                    }
                    visible: webView != null ? webView.canGoForward : false
                    background: Rectangle {
                        implicitWidth: descriptionPage.width / 3
                        color: "transparent"
                    }
                }
            }

            WebView {
                id: webView
                width: parent.width * 0.95
                height: main.height * 0.7
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                onUrlChanged: {
                    console.log("URL is: " + url);
                    if(url.toString().substring(0,5) === "data:" || url.toString().substring(0,5) === "file:" ) {
                        goBackWeb = false
                    } else {
                        goBackWeb = true
                    }
                    console.log("Go Back Web: " + goBackWeb)
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
}
