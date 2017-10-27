import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: filters
    width: searchRectangle.width
    height: 700

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

        MultiPointSlider {
            id: sizeSlider
            visible: true
            x: 10
        }

        SelectableFilter {
            id: difficultyFilterSelectable
            filterText: "Difficulté"
        }

        MultiPointSlider {
            id: difficultySlider
            visible: true

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
    }

}
