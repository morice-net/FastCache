import QtQuick 2.6
import QtQml.Models 2.14

DelegateModel {
    id: visualModel

    property var lessThan: [
        function(left, right) { return left.difficulty < right.difficulty },
        function(left, right) { return left.terrain < right.terrain }
    ]

    property int sortOrder: 1
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
            if (visualModel.sortOrder == visualModel.lessThan.length)
                setGroups(0, count, "items")
            else
                visualModel.sort(visualModel.lessThan[visualModel.sortOrder])
        }
    }
    model: modelState()
    delegate: SelectedCacheItem {
        x: (fastList.width - width ) / 2
        Component.onCompleted: show(modelData)
    }

    function modelState() {
        if(main.cachesActive){
            return  cachesBBox.caches
        } else if(main.state === "near" || main.state === "address" || main.state === "coordinates" ){
            return  cachesNear.caches
        } else if(main.state === "recorded" ){
            return  cachesRecorded.caches
        }
    }
}
