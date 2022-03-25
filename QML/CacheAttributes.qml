import QtQuick 2.6
import QtQuick.Controls 2.5
import QtPositioning 5.2

import "JavaScript/Palette.js" as Palette

import com.mycompany.connecting 1.0

Item {
    id: cacheAttributes

    CacheAttribute {
        id: cacheAttribute
    }

    //attributes of cache
    property var textAttributes: cacheAttribute.sortAttributes(fullCache.attributesBool , fullCache.attributes)

    Rectangle {
        id: rect
        width:  main.width
        height: attIcons.visible ? attIcons.height : attText.height
        color: Palette.greenSea()
        visible: true

        // attributes of caches(icons)
        Grid {
            id: attIcons
            topPadding: 10
            leftPadding: 10
            visible: true
            width:  main.width
            columns: 10
            spacing: 17

            Repeater {
                model: fullCache.attributes.length

                Rectangle {
                    width: parent.width/12
                    height: width
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
        // attributes of caches(text)
        Flickable {
            clip: true
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentHeight: attText.height + 100
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









