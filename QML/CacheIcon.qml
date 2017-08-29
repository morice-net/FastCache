import QtQuick 2.3

Item {
    /*
      0: tradi
      1: multi
      2: mystery
      3: letterBox
      4: where I go
      5: earth
      6: ghost
      7: webcam
      */
    property int type: 0
    Image {
        id: cacheIconBackground
        source: "qrc:/Image/location.png"
    }

    AnimatedSprite {
        id: cacheIconSprite
        paused: true
        x: cacheIconBackground.width * 0.05
        source: "qrc:/Image/cacheList.png"
        frameCount: 8
        currentFrame: type % 8
        width: cacheIconBackground.width * 0.9
        height: width * 90 / 80 // original width is 80 and height 90 we could could simplify be 10 but it is not readable afterward

    }

    MouseArea {
        anchors.fill: cacheIconBackground
        onClicked: type++
    }

}
