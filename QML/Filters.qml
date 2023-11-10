import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings
import QtQuick.Dialogs

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: filters
    width: parent.width
    height: parent.height

    property real selectableIconWidth: main.width / 10

    ColumnLayout {
        id: internFilterColumn
        spacing: filters.height / 50

        // lab caches
        SelectableFilterLabCache {
            id: selectableFilterLabCache
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: main.width / 15
            text: "Lab Cache"
        }

        // caches type
        SelectableFilter {
            id: typeFilterSelectable
            filterText: "Type"
            Layout.alignment: Qt.AlignCenter
        }

        Grid {
            columns: 7
            topPadding: 10
            leftPadding: (filters.width - columns * (selectableIconWidth) - (columns - 1 )* columnSpacing) / 2
            columnSpacing: 10
            rowSpacing: 5

            Repeater {
                model: main.listTypes

                SelectableFilterType {
                    id: selectableFilterType
                    width: selectableIconWidth
                    height: width
                    typeCache: modelData
                }
            }
        }

        // caches size
        SelectableFilter {
            id: sizeFilterSelectable
            filterText: "Taille"
            Layout.alignment: Qt.AlignCenter
        }

        FastButton {
            id: textButtonId
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 16
            onClicked: popupSize.open()
            onWidthChanged: x = (filters.width - width) / 2
        }

        FastPopup {
            id: popupSize
            width: main.width * 0.6
            height: main.height * 0.7
            backgroundRadius: 8
            backgroundOpacity: 0.9
            backgroundBorder {
                width: 1
                color: Palette.silver()
            }

            Column {

                Repeater {
                    model: main.listSizes

                    SelectableFilterSize {
                        id: selectableFilterSize
                        width: selectableIconWidth
                        height: width
                        sizeCache: modelData
                    }
                }
            }

            function closeIfMenu() {
                if (fastMenu.isMenuVisible())
                    visible = false
            }
        }

        // caches difficulty
        SelectableFilter {
            id: difficultyFilterSelectable
            filterText: "Difficulté"
            Layout.alignment: Qt.AlignCenter
        }

        MultiPointSlider {
            visible: true
            Layout.alignment: Qt.AlignCenter
            first.value: settings.difficultyMin
            second.value: settings.difficultyMax
            first.onValueChanged: settings.difficultyMin = minValueSlider()
            second.onValueChanged: settings.difficultyMax = maxValueSlider()
        }

        // caches terrain
        SelectableFilter {
            id: fieldFilterSelectable
            filterText: "Terrain"
            Layout.alignment: Qt.AlignCenter
        }

        MultiPointSlider {
            visible: true
            Layout.alignment: Qt.AlignCenter
            first.value: settings.terrainMin
            second.value: settings.terrainMax
            first.onValueChanged: settings.terrainMin = minValueSlider()
            second.onValueChanged: settings.terrainMax = maxValueSlider()
        }

        // exclude caches
        SelectableFilterExclude {
            id : found
            text: "Exclure les caches trouvées et mes.."
            checked: settings.excludeCachesFound
            onClicked: {
                main.excludeFound = found.checked
                settings.excludeCachesFound = found.checked
            }
        }

        SelectableFilterExclude {
            id : archived
            text: "Exclure les caches désactivées"
            checked: settings.excludeCachesArchived
            onClicked: {
                main.excludeArchived = archived.checked
                settings.excludeCachesArchived = archived.checked
            }
        }

        // filter by key, word
        SelectableFilter {
            id: keywordFilterSelectable
            Layout.alignment: Qt.AlignCenter
            filterText: "Mot-clé , Découvreur..."
        }

        FastButton {
            id: keywordButtonId
            Layout.alignment: Qt.AlignCenter
            text: "Pas de filtres"
            font.pointSize: 16
            onClicked: keyWordPopup.open()
        }

        SelectableFilterKeyWord {
            id: keyWordPopup
        }
    }

    function recordFiltersInSettings() {
        keyWordPopup.recordInSettings()
    }
}
