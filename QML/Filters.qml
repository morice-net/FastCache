import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

import "JavaScript/Palette.js" as Palette

Item {
    id: filters
    width: searchRectangle.width

    Column {
        id: internFilterColumn
        anchors.fill:parent

        SelectableFilter {
            id: typeFilterSelectable
            filterText: "Type"
        }

        Row {
            opacity: 0
            visible: typeFilterSelectable.filterSelected
            height: searchRectangle.width / 5
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
            opacity: 0
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
            visible: sizeFilterSelectable.filterSelected
            x: 10
        }

        SelectableFilter {
            id: difficultyFilterSelectable
            filterText: "Difficulté"
        }

        MultiPointSlider {
            id: difficultySlider
            visible: difficultyFilterSelectable.filterSelected

        }

        SelectableFilter {
            id: fieldFilterSelectable
            filterText: "Terrain"
        }

        MultiPointSlider {
            id: fieldSlider
            visible: fieldFilterSelectable.filterSelected
            x: 10
        }
    }

    function updateHeight() {
        var computedHeight = typeFilterSelectable.height + sizeFilterSelectable.height + difficultyFilterSelectable.height + fieldFilterSelectable.height
        if (typeFilterSelectable.filterSelected)
            computedHeight += 3 * searchRectangle.width / 5
        if (sizeFilterSelectable.filterSelected)
            computedHeight += 60
        if (difficultyFilterSelectable.filterSelected)
            computedHeight += 60
        if (fieldFilterSelectable.filterSelected)
            computedHeight += 60
        height = computedHeight
    }

    Component.onCompleted: {
        updateHeight()
    }
}
