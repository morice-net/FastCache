import QtQuick 2.6
import QtQml.Models 2.14
import QtLocation 5.3
import QtPositioning 5.3

DelegateModel {
    id: sorting

    property var lessThan: [
        function(left, right) { return left.geocode < right.geocode },
        function(left, right) { return left.name < right.name },
        function(left, right) { return left.type < right.type },
        function(left, right) { return left.size < right.size },
        function(left, right) { return left.difficulty < right.difficulty },
        function(left, right) { return left.terrain < right.terrain },
        function(left, right) { return Math.round(currentPosition.position.coordinate.distanceTo(QtPositioning.coordinate(left.lat, left.lon)))
                                < Math.round(currentPosition.position.coordinate.distanceTo(QtPositioning.coordinate(right.lat, right.lon))) }
    ]

    property int sortOrder: main.sortingBy
    onSortOrderChanged: items.setGroups(0, items.count, "unsorted")

    function insertPosition(lessThan, item) {
        var lower = 0
        var upper = items.count
        while (lower < upper) {
            var middle = Math.floor(lower + (upper - lower) / 2)
            var result = lessThan(item.model, items.get(middle).model);
            if (result) {
                upper = middle
            } else {
                lower = middle + 1
            }
        }
        return lower
    }

    function sort(lessThan) {
        while (unsortedItems.count > 0) {
            var item = unsortedItems.get(0)
            var index = insertPosition(lessThan, item)

            item.groups = "items"
            items.move(item.itemsIndex, index)
        }
    }

    items.includeByDefault: false
    groups: DelegateModelGroup {
        id: unsortedItems
        name: "unsorted"

        includeByDefault: true
        onChanged: {
            if (sorting.sortOrder === sorting.lessThan.length)
                setGroups(0, count, "items")
            else
                sorting.sort(sorting.lessThan[sorting.sortOrder])
        }
    }
    model: modelState()
    delegate: SelectedCacheItem {
        x: (fastList.width - width ) / 2
        Component.onCompleted: show(modelData)
    }

    function modelState() {
        if(main.cachesActive || main.state === "near" || main.state === "address" || main.state === "coordinates" || main.state === "recorded"
                || main.state === "pocketQuery")
            return  cachesSingleList.caches
    }
}
