import QtQuick 2.6
import QtQuick.Controls 2.5
import "JavaScript/Palette.js" as Palette
import com.mycompany.connecting 1.0

Item {
    id: fastTravelbugDetailsPage
    height: swipeFastTravelbug.height
    visible:true

    Flickable {
        anchors.topMargin: 60
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: contentItem.childrenRect.height
        ScrollBar.vertical: ScrollBar {}

        Column {
            width: fastTravelbugDetailsPage.width
            spacing: 5
            clip: true

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Nom"
                    color: Palette.silver()
                }

                Text {
                    font.family: localFont.name
                    font.pointSize: 14
                    text: travelbug.name
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Type"
                    color: Palette.silver()
                }

                Text {
                    font.family: localFont.name
                    font.pointSize: 14
                    text: travelbug.type
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Code"
                    color: Palette.silver()
                }

                Text {
                    font.family: localFont.name
                    font.pointSize: 14
                    text: travelbug.tbCode
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Propriétaire"
                    color: Palette.silver()
                }

                Text {
                    font.family: localFont.name
                    font.pointSize: 14
                    text: travelbug.originalOwner
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Pays d'origine"
                    color: Palette.silver()
                }

                Text {
                    font.family: localFont.name
                    font.pointSize: 14
                    text: travelbug.originCountry
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Se situe"
                    color: Palette.silver()
                }

                Text {
                    id: location
                    font.family: localFont.name
                    font.pointSize: 14
                    text: tbLocation()
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Libéré le"
                    color: Palette.silver()
                }

                Text {
                    font.family: localFont.name
                    font.pointSize: 14
                    text: new Date(travelbug.dateCreated).toLocaleDateString(Qt.locale("fr_FR"))
                    color: Palette.white()
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Text {
                    visible: travelbug.originalOwner === "" || travelbug.tbIsMissing
                    width: fastTravelbug.width * 0.25
                    font.family: localFont.name
                    horizontalAlignment: Text.AlignRight
                    font.pointSize: 14
                    text: "Statut "
                    color: Palette.silver()
                }

                Text {
                    visible: travelbug.originalOwner === "" || travelbug.tbIsMissing
                    font.family: localFont.name
                    font.pointSize: 17
                    text: travelbug.originalOwner === "" ? "Le travel bug n'est pas activé" : "Le travel bug est perdu"
                    color: Palette.black()
                }
            }

            Rectangle {
                id: separator1
                visible:travelbug.goal.length !== 0
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id:goal
                visible:travelbug.goal.length !== 0
                width: parent.width
                y:separator1.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "BUT"
                color: Palette.silver()
            }

            Text {
                id:goalText
                visible:travelbug.goal.length !== 0
                width: parent.width
                y:goal.y + 30
                font.family: localFont.name
                color: Palette.white()
                leftPadding: 15
                rightPadding: 15
                textFormat: Qt.RichText
                wrapMode: Text.Wrap
                font.pointSize: 14
                onLinkActivated: Qt.openUrlExternally(link)
                text: travelbug.goal
            }

            Rectangle {
                id: separator2
                visible:travelbug.description.length !== 0
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id:description
                visible:travelbug.description.length !== 0
                width: parent.width
                y:separator2.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "DESCRIPTION"
                color: Palette.silver()
            }

            Text {
                id:descriptionText
                visible:travelbug.description.length !== 0
                width: parent.width
                y:description.y + 30
                font.family: localFont.name
                color: Palette.white()
                leftPadding: 15
                rightPadding: 15
                textFormat: Qt.RichText
                wrapMode: Text.Wrap
                font.pointSize: 14
                onLinkActivated: Qt.openUrlExternally(link)
                text: travelbug.description
            }

            Rectangle {
                id: separator3
                visible:travelbug.imagesName.length !== 0
                width: parent.width
                height: 2
                color: Palette.white()
                radius:10
            }

            Text {
                id:images
                visible:travelbug.imagesName.length !== 0
                width: parent.width
                y:separator3.y + 10
                font.family: localFont.name
                leftPadding: 15
                font.pointSize: 14
                text: "IMAGES"
                color: Palette.silver()
            }

            // images
            Repeater{
                id: imageRepeater
                model:travelbug.imagesUrl.length

                Column{
                    anchors.horizontalCenter: fastTravelbugDetailsPage.horizontalCenter
                    Text {
                        width: parent.width*0.8
                        x:10
                        visible: travelbug.imagesName[index] !== ""
                        text: travelbug.imagesName[index]
                        font.family: localFont.name
                        textFormat: Qt.RichText
                        font.bold: true
                        font.pointSize: 15
                        color: Palette.white()
                        wrapMode: Text.Wrap
                    }

                    Image {
                        x:10
                        source: travelbug.imagesUrl[index]
                        horizontalAlignment: Image.AlignHCenter
                    }
                }
            }
        }
    }

    // location of travelbug
    function tbLocation() {
        if(travelbug.tbStatus === 0)
            return ""
        if(travelbug.tbStatus === 1)
            return "Dans la cache " + travelbug.located
        if(travelbug.tbStatus === 2)
            return "Dans les mains du propriétaire "
        if(travelbug.tbStatus === 3)
            return "En possession de  " + travelbug.located
    }
}
