import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: addText

    property list <string> textList: ["Date" , "Heure" , "Utilisateur" , "Propriétaire" , "Nom de la cache" , "Difficulté" , "Terrain" , "Taille"]
    property list <string> clickedList: [new Date().toLocaleDateString(Qt.LocaleDate) , new Date().getHours(Qt.LocaleDate) + " h : " +
        new Date().getMinutes(Qt.LocaleDate) , userInfo.name , fullCache.owner , fullCache.name , fullCache.difficulty ,
        fullCache.terrain , fullCache.size]

    width: item.width + 20
    height: item.height + 20
    backgroundRadius: 8
    backgroundColor: Palette.backgroundGrey()

    Column {
        id: item
        spacing: 5

        Repeater {
            model: textList.length

            Label {
                font.pointSize: 16
                font.family: localFont.name
                text: textList[index]
                color: Palette.greenSea()

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        addLog = clickedList[index]
                        addText.close() ;
                    }
                }
            }
        }
    }
}
