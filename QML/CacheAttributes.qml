import QtQuick
import QtQuick.Controls
import QtPositioning
import QtQuick.Layouts

import "JavaScript/Palette.js" as Palette

import com.mycompany.connecting 1.0

Item {
    id: cacheAttributes

    CacheAttribute {
        id: cacheAttribute
    }

    //attributes of cache
    property var textAttributes: cacheAttribute.sortAttributes(fullCache.attributesBool , fullCache.attributes)

    //number of icons in the grid
    property int numberIcons : Math.floor(fullCache.attributes.length/attIcons.columns)*attIcons.columns

    Rectangle {
        id: rect
        width:  main.width
        height: attIcons.visible ? attIcons.height + lastLine.height : attText.height
        color: Palette.greenSea()
        visible: true

        // attributes of caches(icons)
        GridLayout {
            id: attIcons
            width:  parent.width
            visible: true
            columns: 6

            Repeater {
                model: numberIcons

                Rectangle {
                    width: parent.width/12
                    height: width
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 10
                    color: colorAttIcon(cacheAttribute.sortedAttributesByGroup[index]) !== undefined ?
                               colorAttIcon(cacheAttribute.sortedAttributesByGroup[index]) : ""
                    border.color: Palette.white()
                    border.width: 1
                    radius: 6

                    Image {
                        anchors.fill: parent
                        source: cacheAttribute.listIcon[cacheAttribute.sortedAttributesByGroup[index]-1] !== undefined ?
                                    "qrc:/Image/" + cacheAttribute.listIcon[cacheAttribute.sortedAttributesByGroup[index]-1] : ""

                        Image {
                            anchors.fill: parent
                            source: "qrc:/Image/Attributes/attribute_no.png"
                            visible: !cacheAttribute.sortedBoolByGroup[index]
                        }
                    }
                }
            }
        }

        // attributes of caches(icons).center the last line
        RowLayout {
            id: lastLine
            width: parent.width
            y: attIcons.height

            Repeater {
                model: fullCache.attributes.length - numberIcons

                Rectangle {
                    width: parent.width/12
                    height: width
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 10
                    color: colorAttIcon(cacheAttribute.sortedAttributesByGroup[index + numberIcons ]) !== undefined ?
                               colorAttIcon(cacheAttribute.sortedAttributesByGroup[index + numberIcons]) : ""
                    border.color: Palette.white()
                    border.width: 1
                    radius: 6

                    Image {
                        anchors.fill: parent
                        source: cacheAttribute.listIcon[cacheAttribute.sortedAttributesByGroup[index + numberIcons]-1] !== undefined ?
                                    "qrc:/Image/" + cacheAttribute.listIcon[cacheAttribute.sortedAttributesByGroup[index + numberIcons]-1] : ""

                        Image {
                            anchors.fill: parent
                            source: "qrc:/Image/Attributes/attribute_no.png"
                            visible: !cacheAttribute.sortedBoolByGroup[index + numberIcons]
                        }
                    }
                }
            }
        }

        // attributes of caches(text)
        Flickable {
            clip: true
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentHeight: attText.height + 150
            ScrollBar.vertical: ScrollBar {}

            Column {
                id: attText
                x: 10
                width: parent.width
                visible: !attIcons.visible

                Repeater {
                    model: textAttributes.length

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textAttributes[index]
                        font.family: localFont.name
                        font.pointSize: fontText(index)
                        color: colorText(index)
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    attIcons.visible = ! attIcons.visible ;
                    lastLine.visible = ! lastLine.visible ;
                }
            }
        }
    }

    function colorAttIcon(index) {
        if(cacheAttribute.listGroup[index - 1] === 10) //permissions
            return "blue"
        if(cacheAttribute.listGroup[index - 1] === 20) //equipment
            return "burlywood"
        if(cacheAttribute.listGroup[index - 1] === 30) // conditions
            return "orange"
        if(cacheAttribute.listGroup[index - 1] === 40) //hazards
            return "black"
        if(cacheAttribute.listGroup[index - 1] === 50) //facilities
            return "grey"
        if(cacheAttribute.listGroup[index - 1] === 60) //specials
            return "magenta"
    }

    function colorText(index) {
        var  count  = 0
        for (var i = 0; i < cacheAttribute.numberAttributesByGroup.length; i++) {
            if(index === count) {
                return Palette.silver()
            } else {
                count = count + cacheAttribute.numberAttributesByGroup[i] + 1
            }
        }
        return Palette.white()
    }

    function fontText(index) {
        var  count  = 0
        for (var i = 0; i < cacheAttribute.numberAttributesByGroup.length; i++) {
            if(index === count) {
                return 19
            } else {
                count = count + cacheAttribute.numberAttributesByGroup[i] + 1
            }
        }
        return 14
    }
}









