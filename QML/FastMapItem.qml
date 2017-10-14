import QtQuick 2.3
import QtLocation 5.3
import QtPositioning 5.3

MapQuickItem {

    property int index: 0

    coordinate: QtPositioning.coordinate(cachesBBox.caches[index].lat, cachesBBox.caches[index].lon)

    sourceItem: CacheIcon {
        id: cacheIcon
    }
}
