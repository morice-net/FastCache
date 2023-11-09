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

        SelectableLabCache {
            id: selectableLabCache
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: main.width / 15
            text: "Lab Cache"
        }

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

                SelectableIcon {
                    id: selectableIcon
                    width: selectableIconWidth
                    height: width
                    type: modelData
                    onPressAndHold: updatelistTypes(!selectableIcon.type)
                }
            }
        }

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

        CheckBox {
            id :found
            Layout.alignment: Qt.AlignLeft
            Layout.preferredHeight: 28
            checked: settings.excludeCachesFound
            onCheckedChanged: main.excludeFound = found.checkState
            contentItem: Text {
                text: "Exclure les caches trouvées et mes.."
                font.family: localFont.name
                font.pointSize: 16
                color: Palette.greenSea()
                verticalAlignment: Text.AlignVCenter
                leftPadding: found.indicator.width + found .spacing + 10
            }
            indicator: Rectangle {
                implicitWidth: 22
                implicitHeight: 22
                radius: 3
                border.width: 1
                x: 10
                y: parent.height / 2 - height / 2

                Rectangle {
                    anchors.fill: parent
                    visible: found .checked
                    color: Palette.greenSea()
                    radius: 3
                    anchors.margins: 4
                }
            }

            function recordFoundInSettings() {
                settings.excludeCachesFound = found.checkState
            }
        }

        CheckBox {
            id :archived
            Layout.alignment: Qt.AlignLeft
            Layout.preferredHeight: 28
            checked: settings.excludeCachesArchived
            onCheckedChanged: main.excludeArchived = archived.checkState
            contentItem: Text {
                text: "Exclure les caches désactivées"
                font.family: localFont.name
                font.pointSize: 16
                color: Palette.greenSea()
                verticalAlignment: Text.AlignVCenter
                leftPadding: archived.indicator.width + archived.spacing + 10
            }
            indicator: Rectangle {
                implicitWidth: 22
                implicitHeight: 22
                radius: 3
                border.width: 1
                x: 10
                y: parent.height / 2 - height / 2
                Rectangle {
                    anchors.fill: parent
                    visible: archived .checked
                    color: Palette.greenSea()
                    radius: 3
                    anchors.margins: 4
                }
            }

            function recordArchivedInSettings() {
                settings.excludeCachesArchived = archived.checkState
            }
        }

        SelectableFilter {
            id: keywordFilterSelectable
            Layout.alignment: Qt.AlignCenter
            filterText: "Mot-clé , Découvreur..."
        }

        FastButton {
            id: keywordButtonId
            Layout.alignment: Qt.AlignCenter
            text:"Pas de filtres.."
            font.pointSize: 16
            onClicked: keyWordPopup.open()
        }

        // key word popup
        FastPopup {
            id: keyWordPopup
            height: main.height * 0.6
            width: main.width * 0.8
            backgroundOpacity: 0.9
            backgroundRadius: 8

            Column {
                id: column
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id:label1
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Mot-clé:"
                    font.pointSize: 16
                    color:Palette.white()
                    font.family: localFont.name
                }

                TextField {
                    id:mot
                    text:  qsTr(settings.keyWord)
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/1.5
                        radius: 6
                        border.color: mot.focus ? Palette.silver() :Palette.greenSea()
                    }
                    onTextChanged: keyWordButton()

                    function recordMotInSettings() {
                        settings.keyWord = mot.text
                    }
                }

                Label {
                    id:label2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Découvreur:"
                    font.pointSize: 16
                    color: Palette.white()
                    anchors.topMargin: 5
                    font.family: localFont.name
                }

                TextField {
                    id:decouvreur
                    text: qsTr(settings.discover)
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/1.5
                        radius: 6
                        border.color: decouvreur.focus ? Palette.silver() :Palette.greenSea()
                    }
                    onTextChanged: keyWordButton()

                    function recordDiscoverInSettings() {
                        settings.discover = decouvreur.text
                    }
                }

                Label {
                    id: label3
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Proprietaire:"
                    font.pointSize: 16
                    color: Palette.white()
                    font.family: localFont.name
                }

                TextField {
                    id: proprietaire
                    text: qsTr(settings.owner)
                    color: Palette.greenSea()
                    background: Rectangle {
                        implicitWidth: main.width/1.5
                        radius: 6
                        border.color: proprietaire.focus ? Palette.silver() :Palette.greenSea()
                    }
                    onTextChanged: keyWordButton()

                    function recordOwnerInSettings() {
                        settings.owner = proprietaire.text
                    }
                }

                FastButton {
                    id: efface
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Effacer"
                    font.pointSize: 16
                    onClicked:{
                        mot.text=""
                        decouvreur.text=""
                        proprietaire.text=""
                        main.listKeywordDiscoverOwner[0] = mot.text
                        main.listKeywordDiscoverOwner[1] = decouvreur.text
                        main.listKeywordDiscoverOwner[2] = proprietaire.text
                    }
                }
            }

            function closeIfMenu() {
                if (fastMenu.isMenuVisible())
                    visible = false
            }
        }
    }

    function recordFiltersInSettings() {
        found.recordFoundInSettings()
        archived.recordArchivedInSettings()
        mot.recordMotInSettings()
        decouvreur.recordDiscoverInSettings()
        proprietaire.recordOwnerInSettings()
    }

    function updatelistTypes(flag) {
        var list = []
        for (var i = 0; i < listTypes.length; i++) {
            list.push(flag)
        }
        listTypes = list

        settings.traditional = listTypes[0]
        settings.mystery = listTypes[1]
        settings.multi = listTypes[2]
        settings.earth = listTypes[3]
        settings.cito = listTypes[4]
        settings.ape = listTypes[5]
        settings.event= listTypes[6]
        settings.giga = listTypes[7]
        settings.letterbox = listTypes[8]
        settings.mega = listTypes[9]
        settings.virtual = listTypes[10]
        settings.webcam = listTypes[11]
        settings.wherigo = listTypes[12]
        settings.gchq = listTypes[13]
    }
}
