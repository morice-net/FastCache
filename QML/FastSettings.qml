import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtPositioning 5.3
import QtWebView 1.1
import Qt.labs.settings 1.0


import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Settings {
    id: settings
    category: "ConnectorTokens"
    property string tokenKey: ""
    property string tokenSecret: ""
}
