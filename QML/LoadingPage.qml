import QtQuick
import QtQuick.Controls

import "JavaScript/Palette.js" as Palette

Item {
    id:loadingPage
    z: 2
    opacity: 0.8

    Rectangle {
        x: 0
        width: main.width
        height: main.height
        color: Palette.greenSea()
        visible: visibleRectangle()

        Text {
            anchors.topMargin: parent.height /3
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            font.family: localFont.name
            font.pointSize: 22
            text: "Loading....\n\n\n"
            color: Palette.white()
        }

        BusyIndicator {
            id: control
            anchors.centerIn: parent
            running: visibleRectangle()
            contentItem: Item {
                implicitWidth: 40
                implicitHeight: 40

                Item {
                    id: item
                    width: 40
                    height: 40

                    RotationAnimator {
                        target: item
                        running: control.visible && control.running
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        duration: 1250
                    }

                    Repeater {
                        id: repeater
                        model: 6

                        Rectangle {
                            id: delegate
                            x: item.width / 2 - width / 2
                            y: item.height / 2 - height / 2
                            implicitWidth: 10
                            implicitHeight: 10
                            radius: 5
                            color: Palette.black()

                            required property int index

                            transform: [
                                Translate {
                                    y: -Math.min(item.width, item.height) * 0.5 + 5
                                },
                                Rotation {
                                    angle: delegate.index / repeater.count * 360
                                    origin.x: 5
                                    origin.y: 5
                                }
                            ]
                        }
                    }
                }
            }
        }
    }

    function visibleRectangle() {
        if(sendCacheNote.state === "loading" || sendCacheLog.state === "loading" || fullCacheRetriever.state === "loading" || travelbug.state === "loading"
                || sendTravelbugLog.state === "loading" || fullCachesRecorded.state === "loading" || sendEditUserLog.state === "loading"
                || deleteLogImage.state === "loading")
            return true
        if(userLogImagesLoaded > -1 && userLogImagesLoaded < fastCache.listImagesUrl.length)
            return true
        return false
    }
}
