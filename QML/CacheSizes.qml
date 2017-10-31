import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: cacheSizes
    property var sizes:[]

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
        sizeId: "Petite"
        sizeIdGs: 8
        Component.onCompleted: {
            sizes.push(secondSize)
        }
    }

    CacheSize {
        id: thirdSize
        sizeId: "Normale"
        sizeIdGs: 3
        Component.onCompleted: {
            sizes.push(thirdSize)
        }
    }

    CacheSize {
        id: fourthSize
        sizeId: "Grande"
        sizeIdGs: 4
        Component.onCompleted: {
            sizes.push(fourthSize)
        }
    }

    CacheSize {
        id: fifthSize
        sizeId: "Non renseignée"
        sizeIdGs: 6
        Component.onCompleted: {
            sizes.push(fifthSize)
        }
    }

    CacheSize {
        id: sixthSize
        sizeId: "Virtuelle"
        sizeIdGs: 5
        Component.onCompleted: {
            sizes.push(sixthSize)
        }
    }

    CacheSize {
        id: seventhSize
        sizeId: "Autre"
        sizeIdGs: 7
        Component.onCompleted: {
            sizes.push(seventhSize)
        }
    }

    CacheSize {
        id: eighthSize
        sizeId: "Inconnue"
        sizeIdGs: 9
        Component.onCompleted: {
            sizes.push(eighthSize)
        }
    }
}
