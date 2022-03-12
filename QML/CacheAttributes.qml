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

    // all attributes
    property var attributesYes: cacheAttribute.listTextYes
    property var attributesNo: cacheAttribute.listTextNo
    property var attributesIcon: cacheAttribute.listIcon
    property var attributesGroup: cacheAttribute.listGroup

    //attributes of cache
    property var sortedAttributes: cacheAttribute.sortAttributesByGroup(fullCache.attributes)
    property var numberAttributes: cacheAttribute.numberAttributesByGroup

    property string header: ""

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
                    color: colorAttIcon(sortedAttributes[index]) !== undefined ? colorAttIcon(sortedAttributes[index]) : ""
                    border.color: Palette.white()
                    border.width: 1
                    radius: 6

                    Image {
                        anchors.fill: parent
                        source: attributesIcon[sortedAttributes[index]-1] !== undefined ? "qrc:/Image/" + attributesIcon[sortedAttributes[index]-1] : ""

                        Image {
                            anchors.fill: parent
                            source: "qrc:/Image/Attributes/attribute_no.png"
                            visible: !fullCache.attributesBool[index]
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
                    model: fullCache.attributes.length

                    Text {
                        text: textAtt(index)
                        font.family: localFont.name
                        font.pointSize: 14
                        color: Palette.white()
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
        if(attributesGroup[index - 1] === 10) //permissions
            return "blue"
        if(attributesGroup[index - 1] === 20) //equipment
            return "burlywood"
        if(attributesGroup[index - 1] === 30) // conditions
            return "orange"
        if(attributesGroup[index - 1] === 40) //hazards
            return "black"
        if(attributesGroup[index - 1] === 50) //facilities
            return "grey"
        if(attributesGroup[index - 1] === 60) //specials
            return "magenta"
    }

    function headerTextAtt(index) {
        if(attributesGroup[index - 1] === 10) //permissions
            return "Autorisations:"
        if(attributesGroup[index - 1] === 20) //equipment
            return "Equipement:"
        if(attributesGroup[index - 1] === 30) // conditions
            return "Conditions:"
        if(attributesGroup[index - 1] === 40) //hazards
            return "Dangers:"
        if(attributesGroup[index - 1] === 50) //facilities
            return "Installations:"
        if(attributesGroup[index - 1] === 60) //specials
            return "Promotions:"
    }

    function textAtt(index) {
        var text = ""
        if(fullCache.attributesBool[index]) {
            text  = attributesYes[sortedAttributes[index]-1] !== undefined ? attributesYes[sortedAttributes[index]-1] : ""
        } else {
            text  = attributesNo[sortedAttributes[index]-1] !== undefined ? attributesNo[sortedAttributes[index]-1] : ""
        }

        //    return headerTextAtt(sortedAttributes[index]) + "\n" +  text
        return text

        //     if(index === 0) {
        //        header = headerTextAtt(sortedAttributes[index])
        //          return header + "\n" +  text
        //      } else {
        //         if(header !== headerTextAtt(sortedAttributes[index])) {
        //           console.log("bonjour:  " + header)
        //
        //          header = headerTextAtt(sortedAttributes[index])
        //          return header + "\n" + text
        //     } else {
        //        return text
        //      }
        //   }
    }
}









