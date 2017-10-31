import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

import "JavaScript/Palette.js" as Palette

Item {
    id: filters
    width: searchRectangle.width
    height: 800

    MouseArea {
        anchors.fill: parent
    }

    Column {
        id: internFilterColumn
        anchors.fill:parent

        SelectableFilter {
            id: typeFilterSelectable
            filterText: "Type"
        }

        Row {
            opacity: 1
            visible: true
            height: searchRectangle.width /6
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: favouriteCacheType
                SelectableIcon {
                    type: modelData
                    favourite: true
                }
            }

            onVisibleChanged: {
                if (visible)
                    opacity = 1
                else
                    opacity = 0
            }

            Behavior on opacity { NumberAnimation { duration: 500 } }
        }

        Grid {
            opacity: 1
            visible: true
            height: 2 * searchRectangle.width / 6
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 5
            Repeater {
                model: otherCacheType
                SelectableIcon {
                    type: modelData
                }
            }

            onVisibleChanged: {
                if (visible)
                    opacity = 1
                else
                    opacity = 0
            }
            Behavior on opacity { NumberAnimation { duration: 500 } }

        }

        SelectableFilter {
            id: sizeFilterSelectable
            filterText: "Taille"
        }

        Button {
            contentItem: Text {
                text: "Ok"
                color: Palette.greenSea()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                x:10
                implicitWidth: 100
                implicitHeight: 25
                opacity: 0.9
                border.color: Palette.greenSea()
                border.width: 1
                radius: 10
            }
            onClicked: popup.open()
        }

        Popup {
            id: popup
            x: 100
            y: 100
            width: 300
            height:parent
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
            background: Rectangle {
                implicitWidth: 110
                implicitHeight: 25
                opacity: 0.8
                border.color: Palette.greenSea()
                border.width: 1
                radius: 10
            }
            ColumnLayout {
                CheckBox { text:"Micro" }
                CheckBox { text: "Petite" }
                CheckBox { text: "Normale" }
                CheckBox { text: "Grande" }
                CheckBox { text: "Non renseignée" }
                CheckBox { text: "Virtuelle" }
                CheckBox { text: "Autre" }
            }
        }

        SelectableFilter {
            id: difficultyFilterSelectable
            filterText: "Difficulté"
        }

        MultiPointSlider {
            id: difficultySlider
            visible: true
            x: 10
        }

        SelectableFilter {
            id: fieldFilterSelectable
            filterText: "Terrain"
        }

        MultiPointSlider {
            id: fieldSlider
            visible: true
            x: 10
        }

        CheckBox { text: "Exclure les caches trouvées et mes.." }
        CheckBox { text: "Exclure les caches désactivées" }
    }
}
