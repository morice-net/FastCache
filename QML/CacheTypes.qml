import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: cacheTypes
    property var types: []

    CacheType {
        id: seventeenthType
        typeId: "block"
        pattern: "Groundspeak Block Party"
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
        pattern: "Lost and Found Event Cache"
        markerId: 6
        typeIdGs: 3653
        Component.onCompleted: {
            types.push(fifteenthType)
        }
    }

    CacheType {
        id: fourteenthType
        typeId: "gchq"
        pattern: "Groundspeak HQ"
        markerId: 13
        typeIdGs: 3773
        Component.onCompleted: {
            types.push(fourteenthType)
        }
    }

    CacheType {
        id: thirteenthType
        typeId: "wherigo"
        pattern: "Wherigo Cache"
        markerId: 12
        typeIdGs: 1858
        Component.onCompleted: {
            types.push(thirteenthType)
        }
    }

    CacheType {
        id: twelfthType
        typeId: "webcam"
        pattern: "Webcam Cache"
        markerId: 11
        typeIdGs: 11
        Component.onCompleted: {
            types.push(twelfthType)
        }
    }

    CacheType {
        id: eleventhType
        typeId: "virtual"
        pattern: "Virtual Cache"
        markerId: 10
        typeIdGs: 4
        Component.onCompleted: {
            types.push(eleventhType)
        }
    }


    CacheType {
        id: tenthType
        typeId: "mega"
        pattern: "Mega-Event Cache"
        markerId: 9
        typeIdGs: 453
        Component.onCompleted: {
            types.push(tenthType)
        }
    }

    CacheType {
        id: ninthType
        typeId: "letterbox"
        pattern: "Letterbox hybrid"
        markerId: 8
        typeIdGs: 5
        Component.onCompleted: {
            types.push(ninthType)
        }
    }

    CacheType {
        id: eighthType
        typeId: "giga"
        pattern: "Giga-Event Cache"
        markerId: 7
        typeIdGs: 7005
        Component.onCompleted: {
            types.push(eighthType)
        }
    }
    CacheType {
        id: seventhType
        typeId: "event"
        pattern: "Event Cache"
        markerId: 6
        typeIdGs: 6
        Component.onCompleted: {
            types.push(seventhType)
        }
    }
    CacheType {
        id: sixthType
        typeId: "ape"
        pattern: "Project Ape Cache"
        markerId: 5
        typeIdGs: 9
        Component.onCompleted: {
            types.push(sixthType)
        }
    }
    CacheType {
        id: fifthType
        typeId: "cito"
        pattern: "Cache in Trash out Event"
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
        pattern: "Multi-cache"
        markerId: 2
        typeIdGs: 3
        Component.onCompleted: {
            types.push(thirdType)
        }
    }

    CacheType {
        id: secondType
        typeId: "mystery"
        pattern: "Unknown Cache"
        markerId: 1
        typeIdGs: 8
        Component.onCompleted: {
            types.push(secondType)
        }
    }
    CacheType {
        id: firstType
        typeId: "traditional"
        pattern: "Traditional Cache"
        markerId: 0
        typeIdGs: 2
        Component.onCompleted: {
            types.push(firstType)
        }
    }
































}
