import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "JavaScript/Palette.js" as Palette

Item {
    id: filters

    property var listTypes : [settingsFilterType.traditional , settingsFilterType.mystery , settingsFilterType.multi , settingsFilterType.earth , settingsFilterType.cito,
        settingsFilterType.ape , settingsFilterType.event , settingsFilterType.giga , settingsFilterType.letterbox , settingsFilterType.mega , settingsFilterType.virtual ,
        settingsFilterType.webcam , settingsFilterType.wherigo , settingsFilterType.gchq]

    width: searchRectangle.width
    height: main.height * 0.8

    CacheTypes {
        id: cacheTypes
    }

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
                model: listTypes
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

            Settings {
                id: settingsFilterType
                category: "filter caches by type"

                property bool traditional : false
                property bool mystery : false
                property bool multi : false
                property bool earth : false
                property bool cito : false
                property bool ape: false
                property bool event: false
                property bool giga : false
                property bool letterbox: false
                property bool mega: false
                property bool virtual: false
                property bool webcam: false
                property bool wherigo: false
                property bool gchq: false
            }
            Component.onDestruction: {
                createFilterTypesGs()
            }
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
                CheckBox { id :size1; text:"Micro"; checked: settingsFilterSize.micro}
                CheckBox {id :size2; text: "Petite" ;  checked: settingsFilterSize.small}
                CheckBox {id :size3; text: "Normale";  checked: settingsFilterSize.regular }
                CheckBox {id :size4; text: "Grande"; checked: settingsFilterSize.large }
                CheckBox { id :size5;text: "Non renseignée" ; checked: settingsFilterSize.notChosen }
                CheckBox { id :size6;text: "Virtuelle"; checked: settingsFilterSize.virtual }
                CheckBox {id :size7; text: "Autre";  checked: settingsFilterSize.other  }
            }

            Settings {
                id: settingsFilterSize
                category: "filter cache size"
                property bool micro: true
                property bool small: true
                property bool regular: true
                property bool large: true
                property bool notChosen: true
                property bool virtual: true
                property bool other: true
            }

            Component.onDestruction: {
                settingsFilterSize.micro = size1.checkState
                settingsFilterSize.small =size2.checkState
                settingsFilterSize.regular = size3.checkState
                settingsFilterSize.large = size4.checkState
                settingsFilterSize.notChosen = size5.checkState
                settingsFilterSize.virtual = size6.checkState
                settingsFilterSize.other = size7.checkState
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

    function createFilterTypesGs(){
        var  list = [] ;
        cacheTypes.types.reverse()
        for (var i = 0; i < listTypes.length; i++) {
            if(listTypes[i] === false ){
                list.push( cacheTypes.types[i].typeIdGs)
                if(cacheTypes.types[i].markerId === 6){
                    list.push(4738 )
                    list.push(1304)
                    list.push(3653 )
                }
            }
        }
        console.log("listTypesGs:  " + list)
        return list
    }
}
