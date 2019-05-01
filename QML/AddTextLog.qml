import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

import "JavaScript/Palette.js" as Palette

FastPopup {
    id: addText
    x: parent.height * 0.05 + 10
    y: parent.height * 0.3
    background: Rectangle {
        anchors.fill: parent
        implicitWidth: main.width*0.4
        implicitHeight:main.height*0.33
        color: Palette.turquoise()
        border.color: Palette.black()
        border.width: 1
        opacity:0.9
        radius: 15
    }

    Column {
        id: item
        spacing: 15
        anchors.margins: 5
        anchors.fill: parent

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Date"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = new Date().toLocaleDateString(Qt.LocaleDate);
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Heure"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = new Date().getHours(Qt.LocaleDate) + " h : " + new Date().getMinutes(Qt.LocaleDate);
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Utilisateur"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = userInfo.name ;
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Propriétaire"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = fullCache.owner;
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Nom de la cache"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = fullCache.name;
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Difficulté"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = fullCache.difficulty;
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Terrain"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = fullCache.terrain;
                    addText.close() ;
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height * 0.1
            color: Palette.turquoise()

            Text {
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.pointSize: 16
                font.family: localFont.name
                text: "Taille"
                color: Palette.white()
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textLog = main.cacheSize(fullCache.size);
                    addText.close() ;
                }
            }
        }
    }
}
