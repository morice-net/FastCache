import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import Qt.labs.settings 1.0

import "JavaScript/Palette.js" as Palette

Item {
    id: filters
    width: searchRectangle.width
    height: 800

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

        CheckBox {id :archived ; text: "Exclure les caches désactivées" ;checked: settingsFilterArchived.excludeCachesArchived
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
