import QtQuick 2.6
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0

    coordinate: QtPositioning.coordinate(cachesBBox.caches[index].lat, cachesBBox.caches[index].lon)
    anchorPoint.x: cacheIcon.width/2
    anchorPoint.y: cacheIcon.height
    sourceItem: CacheIcon {
        id: cacheIcon
        type: cacheMarkerId(cachesBBox.caches[index].type)

        MouseArea {
            anchors.fill: parent
            onClicked: selectedCache = cachesBBox.caches[index]
        }
    }
}
