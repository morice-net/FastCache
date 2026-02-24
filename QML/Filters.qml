import QtQuick
import QtQuick.Layouts

import "JavaScript/Palette.js" as Palette

Item {
    id: filters
    width: parent.width
    height: parent.height

    property real selectableIconWidth: main.width / 10

    ColumnLayout {
        id: internFilterColumn
        spacing: 22

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
                model: listTypes.length
                delegate: SelectableFilterType {
                    id: selectableFilterType
                    width: selectableIconWidth
                    height: width
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
            Component.onCompleted: textSizeButton()
        }

        FastPopup {
            id: popupSize

            Connections {
                target: popupSize.parent
                function onVisibleChanged() {
                    if (!cacheFilter.opacity !== 0 && popupSize.opened) {
                        popupSize.close()
                    }
                }
            }
            leftMargin: 20
            width: main.width * 0.6
            height: sizeColumn.implicitHeight + 20
            backgroundRadius: 8
            backgroundOpacity: 0.9
            backgroundBorder {
                width: 1
                color: Palette.silver()
            }

            Column {
                id: sizeColumn

                Repeater {
                    model: listSizes.length
                    delegate: SelectableFilterSize {
                        id: selectableFilterSize
                        width: selectableIconWidth
                        height: width
                    }
                }
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

            Connections {
                target: keyWordPopup.parent
                function onVisibleChanged() {
                    if (!cacheFilter.opacity !== 0 && keyWordPopup.opened) {
                        keyWordPopup.close()
                    }
                }
            }
        }
    }

    function recordFiltersInSettings() {
        keyWordPopup.recordInSettings()
    }

    function textSizeButton() {
        if(listSizes[0] && listSizes[1] && listSizes[2] && listSizes[3] && listSizes[4] && listSizes[5] && listSizes[6])
        {
            textButtonId.text = "Toutes..."
            return
        }
        var textArray = ""
        if(listSizes[0]) {
            textArray += "Mc "
        }
        if(listSizes[1]) {
            textArray += "Pt "
        }
        if(listSizes[2]) {
            textArray += "Nm "
        }
        if(listSizes[3]) {
            textArray += "Gr "
        }
        if(listSizes[4]) {
            textArray += "NonRenseignée "
        }
        if(listSizes[5]) {
            textArray += "Virt "
        }
        if(listSizes[6]) {
            textArray += "Autre "
        }
        if(textArray === "")
            textArray = "Aucune"
        textButtonId.text = textArray
    }
}
