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
    property WebView  webEngineView

    onDescriptionTextChanged: {
        deleteWebView()

        if((main.state !== "recorded") || (main.state === "cachesActive")) {
            createWebView() //destroy and create to initialize browsing history of WebView
            if(fullCache.type !== "labCache") {
                webEngineView.loadHtml(descriptionText , "html")   // cacheGC ...
            } else {
                webEngineView.url = descriptionText // lab cache
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
                    icon.source: "qrc:/Image/goback.png"
                    icon.width: 40
                    icon.height: 30
                    onClicked:{
                        webEngineView.goBack()
                    }
                    visible: webEngineView != null ? webEngineView.canGoBack : false
                    background: Rectangle {
                        implicitWidth: descriptionPage.width / 3
                        color: "transparent"
                    }
                }

                Button {
                    icon.source: "qrc:/Image/forward.png"
                    icon.width: 40
                    icon.height: 30
                    onClicked:{
                        webEngineView.goForward()
                    }
                    visible: webEngineView != null ? webEngineView.canGoForward : false
                    background: Rectangle {
                        implicitWidth: descriptionPage.width / 3
                        color: "transparent"
                    }
                }
            }

            Item {
                id: itemWebView
                visible: main.state !== "recorded"
                width: parent.width * 0.95
                height: main.height * 0.7
                anchors.horizontalCenter: parent.horizontalCenter
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
                        swipeFastCache.setCurrentIndex(5) ;
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

    function createWebView() {
        webEngineView = Qt.createQmlObject('import QtWebView
        WebView {
            id: webEngineView
            clip: true
            visible: webViewDescriptionPageVisible && (userSettings.isMenuVisible() === false) &&
                     (fastMenu.isMenuVisible() === false)
            width: parent.width * 0.95
            height: main.height * 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            onUrlChanged: {
                    console.log("[URL] The load request URL is: " + url);
                }
                                  }', itemWebView)
    }

    function deleteWebView() {
        if(webEngineView != null)
            webEngineView = null
    }
}
