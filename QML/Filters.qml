import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: filters
    width: searchRectangle.width
    height: main.height / 3

    Column {
        anchors.fill:parent

        SelectableFilter {
            id: typeFilterSelectable
            filterText: "Type"
        }

        Row {
            visible: typeFilterSelectable.filterSelected
            //width: searchRectangle.width
            height: searchRectangle.width / 5
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: favouriteCacheType
                SelectableIcon {
                    type: modelData
                    favourite: true
                }
            }
        }

        Grid {
            visible: typeFilterSelectable.filterSelected
            //width: searchRectangle.width
            height: 2 * searchRectangle.width / 6
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 5
            Repeater {
                model: otherCacheType
                SelectableIcon {
                    type: modelData
                }
            }

        }

        SelectableFilter {
            id: sizeFilterSelectable
            filterText: "Taille"
        }

        SelectableFilter {
            id: difficultyFilterSelectable
            filterText: "Difficulté"
        }

        SelectableFilter {
            id: fieldFilterSelectable
            filterText: "Terrain"
        }
    }
}
