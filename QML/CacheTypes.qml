import QtQuick 2.3

import com.mycompany.connecting 1.0

Item {
    id: cacheTypes
    property var types: []

    CacheType {
        id: firstType
        typeId: "id"
        pattern: "pattern"
        markerId: 1
        typeIdGs: 1
        Component.onCompleted: {
            types.push(firstType)
        }
    }
}
