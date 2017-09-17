import QtQuick 2.3

import com.mycompany.connecting 1.0

Item {
    id: cacheSizes
    property var sizes: []

    CacheSize {
        id: firstSize
        sizeId: "Micro"
        sizeIdGs: 2
        Component.onCompleted: {
            sizes.push(firstSize)
        }
    }

    CacheSize {
        id: secondSize
        sizeId: "Small"
        sizeIdGs: 8
        Component.onCompleted: {
            sizes.push(secondSize)
        }
    }

    CacheSize {
        id: thirdSize
        sizeId: "Regular"
        sizeIdGs: 3
        Component.onCompleted: {
            sizes.push(thirdSize)
        }
    }

    CacheSize {
        id: fourthSize
        sizeId: "Large"
        sizeIdGs: 4
        Component.onCompleted: {
            sizes.push(fourthSize)
        }
    }

    CacheSize {
        id: fifthSize
        sizeId: "Not chosen"
        sizeIdGs: 6
        Component.onCompleted: {
            sizes.push(fifthSize)
        }
    }

    CacheSize {
        id: sixthSize
        sizeId: "Virtual"
        sizeIdGs: 5
        Component.onCompleted: {
            sizes.push(sixthSize)
        }
    }

    CacheSize {
        id: seventhSize
        sizeId: "Other"
        sizeIdGs: 7
        Component.onCompleted: {
            sizes.push(seventhSize)
        }
    }

    CacheSize {
        id: eighthSize
        sizeId: "Unknown"
        sizeIdGs: 9
        Component.onCompleted: {
            sizes.push(eighthSize)
        }
    }
}
