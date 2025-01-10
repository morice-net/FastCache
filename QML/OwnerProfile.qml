import QtQuick
import QtQuick.Controls
import QtWebView

FastPopup {
    id: ownerProfile
    closeButtonVisible: false

    property bool backWeb: false
    property string originalUrl: fullCache.ownerUrl

    onOriginalUrlChanged: backWeb = false

    Column {

        Row {
            id: buttonsLine
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: buttonGoback
                icon.source: "../Image/goback.png"
                icon.width: 40
                icon.height: 30
                onClicked: webView.goBack()
                enabled: webView.canGoBack && backWeb
                background: Rectangle {
                    implicitWidth: main.width / 2
                    color: "transparent"
                }
            }

            Button {
                id: buttonForward
                icon.source: "../Image/forward.png"
                icon.width: 40
                icon.height: 30
                onClicked: webView.goForward()
                enabled: webView.canGoForward
                background: Rectangle {
                    implicitWidth: main.width / 2
                    color: "transparent"
                }
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: main.width * 0.95
            height: main.height * 0.85

            WebView {
                id: webView
                anchors.fill: parent
                url: fullCache.ownerUrl
                clip: true
                onUrlChanged: {
                    if(webView.url.toString().indexOf("?code=") !== -1) {
                        backWeb = false
                    } else {
                        backWeb = true
                    }
                }
                onLoadingChanged: function(loadRequest) {
                    if (loadRequest.errorString)
                        console.error(loadRequest.errorString);
                }

                Component.onCompleted: {
                    webView.settings.setAllowFileAccess(true)
                    webView.settings.setLocalContentCanAccessFileUrls(true)
                }
            }

            function closeIfMenu() {
                if (fastMenu.isMenuVisible())
                    visible = false
            }
        }
    }
}
