import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: cacheTypes
    property var types: []

    CacheType {
        id: seventeenthType
        typeId: "block"
        frenchPattern: "fête locale Groundspeak"
        markerId: 6
        typeIdGs: 4738
        Component.onCompleted: {
            types.push(seventeenthType)
        }
    }

    CacheType {
        id: sixteenthType
        typeId: "gps"
        frenchPattern: "GPS Adventures Exhibit"
        markerId: 6
        typeIdGs: 1304
        Component.onCompleted: {
            types.push(sixteenthType)
        }
    }

    CacheType {
        id: fifteenthType
        typeId: "lostfound"
        frenchPattern: "Evènement perdu & trouvé"
        markerId: 6
        typeIdGs: 3653
        Component.onCompleted: {
            types.push(fifteenthType)
        }
    }

    CacheType {
        id: fourteenthType
        typeId: "gchq"
        frenchPattern: "Siège de Groundspeak"
        markerId: 13
        typeIdGs: 3773
        Component.onCompleted: {
            types.push(fourteenthType)
        }
    }

    CacheType {
        id: thirteenthType
        typeId: "wherigo"
        frenchPattern: "Wherigo"
        markerId: 12
        typeIdGs: 1858
        Component.onCompleted: {
            types.push(thirteenthType)
        }
    }

    CacheType {
        id: twelfthType
        typeId: "webcam"
        frenchPattern: "Webcam"
        markerId: 11
        typeIdGs: 11
        Component.onCompleted: {
            types.push(twelfthType)
        }
    }

    CacheType {
        id: eleventhType
        typeId: "virtual"
        frenchPattern: "Virtuelle"
        markerId: 10
        typeIdGs: 4
        Component.onCompleted: {
            types.push(eleventhType)
        }
    }

    CacheType {
        id: tenthType
        typeId: "mega"
        frenchPattern: "Méga-Evènement"
        markerId: 9
        typeIdGs: 453
        Component.onCompleted: {
            types.push(tenthType)
        }
    }

    CacheType {
        id: ninthType
        typeId: "letterbox"
        frenchPattern: "Boîte aux lettres hybride"
        markerId: 8
        typeIdGs: 5
        Component.onCompleted: {
            types.push(ninthType)
        }
    }

    CacheType {
        id: eighthType
        typeId: "giga"
        frenchPattern: "Giga-Evènement"
        markerId: 7
        typeIdGs: 7005
        Component.onCompleted: {
            types.push(eighthType)
        }
    }

    CacheType {
        id: seventhType
        typeId: "event"
        frenchPattern: "Evènement"
        markerId: 6
        typeIdGs: 6
        Component.onCompleted: {
            types.push(seventhType)
        }
    }

    CacheType {
        id: sixthType
        typeId: "ape"
        frenchPattern: "Project ape cache"
        markerId: 5
        typeIdGs: 9
        Component.onCompleted: {
            types.push(sixthType)
        }
    }

    CacheType {
        id: fifthType
        typeId: "cito"
        frenchPattern: "Cito"
        markerId: 4
        typeIdGs: 13
        Component.onCompleted: {
            types.push(fifthType)
        }
    }

    CacheType {
        id: fourthType
        typeId: "earth"
        frenchPattern: "Earthcache"
        markerId: 3
        typeIdGs: 137
        Component.onCompleted: {
            types.push(fourthType)
        }
    }

    CacheType {
        id: thirdType
        typeId: "multi"
        frenchPattern: "Multiple"
        markerId: 2
        typeIdGs: 3
        Component.onCompleted: {
            types.push(thirdType)
        }
    }

    CacheType {
        id: secondType
        typeId: "mystery"
        frenchPattern: "Mystère"
        markerId: 1
        typeIdGs: 8
        Component.onCompleted: {
            types.push(secondType)
        }
    }

    CacheType {
        id: firstType
        typeId: "traditional"
        frenchPattern: "Traditionnelle"
        markerId: 0
        typeIdGs: 2
        Component.onCompleted: {
            types.push(firstType)
        }
    }

}
