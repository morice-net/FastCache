﻿import QtQuick
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

            ColumnLayout {

                CheckBox {
                    id : size1
                    x: 10
                    checked: settings.micro
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Micro"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size1.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size1.indicator.width + size1.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size1.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }

                CheckBox {
                    id : size2
                    x:10
                    checked: settings.small
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Petite"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size2.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size2.indicator.width + size2.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size2.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }

                CheckBox {
                    id : size3
                    x:10
                    checked: settings.regular
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Normale"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size3.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size3.indicator.width + size3.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size3.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }

                CheckBox {
                    id : size4
                    x:10
                    checked: settings.large
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Grande"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size4.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size4.indicator.width + size4.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size4.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }

                CheckBox {
                    id : size5
                    x:10
                    checked: settings.notChosen
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Non renseignée"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size5.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size5.indicator.width + size5.spacing

                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size5.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }

                CheckBox {
                    id : size6
                    x:10
                    checked: settings.virtualSize
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Virtuelle"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size6.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size6.indicator.width + size6.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size6.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }

                CheckBox {
                    id : size7
                    x:10
                    checked: settings.other
                    onCheckedChanged: textSizeButton()
                    contentItem: Text {
                        text: "Autre"
                        font.family: localFont.name
                        font.pointSize: 16
                        color: size7.checked ? Palette.white() : Palette.silver()
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: size7.indicator.width + size7.spacing
                    }
                    indicator: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 3
                        border.width: 1
                        y: parent.height / 2 - height / 2

                        Rectangle {
                            anchors.fill: parent
                            visible: size7.checked
                            color: Palette.greenSea()
                            radius: 3
                            anchors.margins: 4
                        }
                    }
                }
            }

            function recordStateInSettings() {
                settings.micro = size1.checkState
                settings.small =size2.checkState
                settings.regular = size3.checkState
                settings.large = size4.checkState
                settings.notChosen = size5.checkState
                settings.virtualSize = size6.checkState
                settings.other = size7.checkState
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

    function textSizeButton() {
        if(size1.checked && size2.checked && size3.checked && size4.checked && size5.checked && size6.checked && size7.checked)
        {
            textButtonId.text = "Toutes..."
            main.listSizes[0] = true
            main.listSizes[1] = true
            main.listSizes[2] = true
            main.listSizes[3] = true
            main.listSizes[4] = true
            main.listSizes[5] = true
            main.listSizes[6] = true
            return
        }
        var textArray = ""
        main.listSizes[0] = false
        main.listSizes[1] = false
        main.listSizes[2] = false
        main.listSizes[3] = false
        main.listSizes[4] = false
        main.listSizes[5] = false
        main.listSizes[6] = false
        if(size1.checked){
            textArray+="Mc "
            main.listSizes[0]  = true
        }
        if(size2.checked){
            textArray+="Pt "
            main.listSizes[1] = true
        }
        if(size3.checked){
            textArray+="Nm "
            main.listSizes[2] = true
        }
        if(size4.checked){
            textArray+="Gr "
            main.listSizes[3] = true
        }
        if(size5.checked){
            textArray+="NonRenseignée "
            main.listSizes[4] = true
        }
        if(size6.checked){
            textArray+="Virt "
            main.listSizes[5] = true
        }
        if(size7.checked){
            textArray+="Autre "
            main.listSizes[6] = true
        }
        if(textArray === "")
            textArray = "Aucune"
        textButtonId.text = textArray
    }

    function keyWordButton() {
        var index = 0
        main.listKeywordDiscoverOwner[0] = mot.text
        main.listKeywordDiscoverOwner[1] = decouvreur.text
        main.listKeywordDiscoverOwner[2] = proprietaire.text
        if(mot.text.length) index += 1
        if(decouvreur.text.length) index += 1
        if(proprietaire.text.length)  index += 1
        if(!index) {
            keywordButtonId.text = "Pas de filtres.."
        } else {
            keywordButtonId.text = "Nombre de filtres:   " + index
        }
    }

    function recordFiltersInSettings() {
        popupSize.recordStateInSettings()
        found.recordFoundInSettings()
        archived.recordArchivedInSettings()
        mot.recordMotInSettings()
        decouvreur.recordDiscoverInSettings()
        proprietaire.recordOwnerInSettings()
    }
}
