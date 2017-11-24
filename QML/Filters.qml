import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: filters
    width: searchRectangle.width
    height: main.height * 0.8

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

        Grid {
            opacity: 1
            visible: true
            height: 3 * searchRectangle.width / 6
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 5
            Repeater {
                model: main.listTypes
                SelectableIcon {
                    id: selectableIcon
                    type: modelData
                }
            }

            onVisibleChanged: {
                if (visible)
                    opacity = 1
                else
                    opacity = 0
            }

            Behavior on opacity { NumberAnimation { duration: 400 } }
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
                CheckBox { id :size1; text:"Micro"; checked: settings.micro}
                CheckBox {id :size2; text: "Petite" ;  checked: settings.small}
                CheckBox {id :size3; text: "Normale";  checked: settings.regular }
                CheckBox {id :size4; text: "Grande"; checked: settings.large }
                CheckBox { id :size5;text: "Non renseignée" ; checked: settings.notChosen }
                CheckBox { id :size6;text: "Virtuelle"; checked: settings.virtualSize }
                CheckBox {id :size7; text: "Autre";  checked: settings.other  }
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
            first.value:   settingsDifficulty.difficultyMin
            second.value:  settingsDifficulty.difficultyMax

            Settings {
                id: settingsDifficulty
                category: "filter caches by difficulty "
                property real difficultyMin: 1
                property real difficultyMax: 5
            }

            Component.onDestruction: {
                settingsDifficulty.difficultyMin = minValueSlider()
                settingsDifficulty.difficultyMax = maxValueSlider()
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
            first.value:   settingsTerrain.terrainMin
            second.value:  settingsTerrain.terrainMax

            Settings {
                id: settingsTerrain
                category: "filter caches by terrain "
                property real terrainMin: 1
                property real terrainMax: 5
            }

            Component.onDestruction: {
                settingsTerrain.terrainMin = minValueSlider()
                settingsTerrain.terrainMax = maxValueSlider()
            }
        }

        CheckBox {id :found ; text: "Exclure les caches trouvées et mes.." ;checked: settingsFilterFound.excludeCachesFound

            Settings {
                id: settingsFilterFound
                category: "filter caches found"
                property bool excludeCachesFound: true
            }

            Component.onDestruction: {
                settingsFilterFound.excludeCachesFound = found.checkState
            }
        }

        CheckBox {
            id :archived
            text: "Exclure les caches désactivées"
            checked: settingsFilterArchived.excludeCachesArchived

            Settings {
                id: settingsFilterArchived
                category: "filter caches archived"
                property bool excludeCachesArchived: true
            }

            Component.onDestruction: {
                settingsFilterArchived.excludeCachesArchived = archived.checkState
            }
        }
    }

}
