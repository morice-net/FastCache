import QtQuick 2.6
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: geocodeAlert

    ColumnLayout {
        x:27
        y: main.height/3
        height: tabTitle.height * 2

        Label {
            id: tabTitle
            color: Palette.white()
            text: qsTr("Le plugin ne gère pas le géocoding.")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    function closeIfMenu() {
        if (fastMenu.isMenuVisible())
            visible = false
    }
}



