import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: filters
    x: parent.width * 0.05
    width: parent.width * 0.9
    height: main.height * 0.8

    FastSettings {
        id: settings
    }

    MouseArea {
        anchors.fill: parent
    }

    Column {
        id: internFilterColumn
        anchors.centerIn: parent

        SelectableFilter {
            id: typeFilterSelectable
            filterText: "Type"
        }

        Grid {
            x: 20
            columns: 5
            Repeater {
                model: main.listTypes
                SelectableIcon {
                    id: selectableIcon
                    type: modelData
                }
            }
        }

        SelectableFilter {
            id: sizeFilterSelectable
            filterText: "Taille"
        }

        Button {
            x: 10
            width: parent.width
            height: parent.height * 0.08
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: localFont.name
            font.pixelSize: userInfoMenu.height * 0.45

            contentItem: Text {
                id: textButtonId
                color: Palette.greenSea()
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                anchors.fill: parent
                anchors.margins: 5
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
            modal: true
            focus: true
            closePolicy:  Popup.CloseOnPressOutside
            background: Rectangle {
                implicitWidth: 110
                implicitHeight: 25
                opacity: 0.8
                border.color: Palette.greenSea()
                border.width: 1
                radius: 10
            }

            ColumnLayout {
                CheckBox { id: size1 ; text:"Micro" ; checked: settings.micro ; onCheckedChanged: textSizeButton() }
                CheckBox { id: size2 ; text: "Petite" ;  checked: settings.small ; onCheckedChanged: textSizeButton() }
                CheckBox { id: size3 ; text: "Normale" ;  checked: settings.regular ; onCheckedChanged: textSizeButton() }
                CheckBox { id: size4 ; text: "Grande" ; checked: settings.large ; onCheckedChanged: textSizeButton() }
                CheckBox { id: size5 ; text: "Non renseignée" ; checked: settings.notChosen ; onCheckedChanged: textSizeButton() }
                CheckBox { id: size6 ; text: "Virtuelle" ; checked: settings.virtualSize; onCheckedChanged: textSizeButton() }
                CheckBox { id: size7 ; text: "Autre" ;  checked: settings.other ; onCheckedChanged: textSizeButton() }
            }

            Component.onDestruction: {
                settings.micro = size1.checkState
                settings.small =size2.checkState
                settings.regular = size3.checkState
                settings.large = size4.checkState
                settings.notChosen = size5.checkState
                settings.virtualSize = size6.checkState
                settings.other = size7.checkState
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
            first.value: settings.difficultyMin
            second.value: settings.difficultyMax

            Component.onDestruction: {
                settings.difficultyMin = minValueSlider()
                settings.difficultyMax = maxValueSlider()
            }
        }

        SelectableFilter {
            id: fieldFilterSelectable
            filterText: "Terrain"
        }

        MultiPointSlider {
            id: fieldSlider
            visible: true
            x: 10
            first.value: settings.terrainMin
            second.value: settings.terrainMax
            Component.onDestruction: {
                settings.terrainMin = minValueSlider()
                settings.terrainMax = maxValueSlider()
            }
        }

        CheckBox {
            id :found
            text: "Exclure les caches trouvées et mes.."
            checked: settings.excludeCachesFound
            Component.onDestruction: {
                settings.excludeCachesFound = found.checkState
            }
        }

        CheckBox {
            id :archived
            text: "Exclure les caches désactivées"
            checked: settings.excludeCachesArchived
            Component.onDestruction: {
                settings.excludeCachesArchived = archived.checkState
            }
        }
    }


    function textSizeButton() {
        console.log("check text size button")
        if(size1.checked && size2.checked && size3.checked && size4.checked && size5.checked && size6.checked && size7.checked)
        {
            textButtonId.text = "Toutes..."
            return
        }

        var textArray = ""
        if(size1.checked)
            textArray+="Mc. "
        if(size2.checked)
            textArray+="Pt. "
        if(size3.checked)
            textArray+="Nm. "
        if(size4.checked)
            textArray+="Gr. "
        if(size5.checked)
            textArray+="NonRenseignée "
        if(size6.checked)
            textArray+="Virt. "
        if(size7.checked)
            textArray+="Autre "
        if(textArray == "")
            textArray="Aucune"
        textButtonId.text = textArray
    }
}
