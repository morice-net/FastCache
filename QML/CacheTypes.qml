import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: cacheTypes
    property var types: []

    CacheType {
        id: seventeenthType
        typeId: "block"
        pattern: "fête locale Groundspeak"
        markerId: 6
        typeIdGs: 4738
        Component.onCompleted: {
            types.push(seventeenthType)
        }
    }

    CacheType {
        id: sixteenthType
        typeId: "gps"
        pattern: "GPS Adventures Exhibit"
        markerId: 6
        typeIdGs: 1304
        Component.onCompleted: {
            types.push(sixteenthType)
        }
    }

    CacheType {
        id: fifteenthType
        typeId: "lostfound"
        pattern: "Evènement perdu & trouvé"
        markerId: 6
        typeIdGs: 3653
        Component.onCompleted: {
            types.push(fifteenthType)
        }
    }

    CacheType {
        id: fourteenthType
        typeId: "gchq"
        pattern: "Siège de Groundspeak"
        markerId: 13
        typeIdGs: 3773
        Component.onCompleted: {
            types.push(fourteenthType)
        }
    }

    CacheType {
        id: thirteenthType
        typeId: "wherigo"
        pattern: "Wherigo"
        markerId: 12
        typeIdGs: 1858
        Component.onCompleted: {
            types.push(thirteenthType)
        }
    }

    CacheType {
        id: twelfthType
        typeId: "webcam"
        pattern: "Webcam"
        markerId: 11
        typeIdGs: 11
        Component.onCompleted: {
            types.push(twelfthType)
        }
    }

    CacheType {
        id: eleventhType
        typeId: "virtual"
        pattern: "Virtuelle"
        markerId: 10
        typeIdGs: 4
        Component.onCompleted: {
            types.push(eleventhType)
        }
    }

    CacheType {
        id: tenthType
        typeId: "mega"
        pattern: "Méga-Evènement"
        markerId: 9
        typeIdGs: 453
        Component.onCompleted: {
            types.push(tenthType)
        }
    }

    CacheType {
        id: ninthType
        typeId: "letterbox"
        pattern: "Boîte aux lettres hybride"
        markerId: 8
        typeIdGs: 5
        Component.onCompleted: {
            types.push(ninthType)
        }
    }

    CacheType {
        id: eighthType
        typeId: "giga"
        pattern: "Giga-Evènement"
        markerId: 7
        typeIdGs: 7005
        Component.onCompleted: {
            types.push(eighthType)
        }
    }

    CacheType {
        id: seventhType
        typeId: "event"
        pattern: "Evènement"
        markerId: 6
        typeIdGs: 6
        Component.onCompleted: {
            types.push(seventhType)
        }
    }

    CacheType {
        id: sixthType
        typeId: "ape"
        pattern: "Project ape cache"
        markerId: 5
        typeIdGs: 9
        Component.onCompleted: {
            types.push(sixthType)
        }
    }

    CacheType {
        id: fifthType
        typeId: "cito"
        pattern: "Cito"
        markerId: 4
        typeIdGs: 13
        Component.onCompleted: {
            types.push(fifthType)
        }
    }

    CacheType {
        id: fourthType
        typeId: "earth"
        pattern: "Earthcache"
        markerId: 3
        typeIdGs: 137
        Component.onCompleted: {
            types.push(fourthType)
        }
    }

    CacheType {
        id: thirdType
        typeId: "multi"
        pattern: "Multiple"
        markerId: 2
        typeIdGs: 3
        Component.onCompleted: {
            types.push(thirdType)
        }
    }

    CacheType {
        id: secondType
        typeId: "mystery"
        pattern: "Mystère"
        markerId: 1
        typeIdGs: 8
        Component.onCompleted: {
            types.push(secondType)
        }
    }

    CacheType {
        id: firstType
        typeId: "traditional"
        pattern: "Traditionnelle"
        markerId: 0
        typeIdGs: 2
        Component.onCompleted: {
            types.push(firstType)
        }
    }

}
