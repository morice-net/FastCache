import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: cacheSizes
    property var sizes:[]

    CacheSize {
        id: eighthSize
        frenchPattern: "Inconnue"
        sizeIdGs: 1
        Component.onCompleted: {
            sizes.push(eighthSize)
        }
    }

    CacheSize {
        id: seventhSize
        frenchPattern: "Autre"
        sizeIdGs: 6
        Component.onCompleted: {
            sizes.push(seventhSize)
        }
    }

    CacheSize {
        id: sixthSize
        frenchPattern: "Virtuelle"
        sizeIdGs: 5
        Component.onCompleted: {
            sizes.push(sixthSize)
        }
    }

    CacheSize {
        id: fifthSize
        frenchPattern: "Non renseignée"
        sizeIdGs: 6
        Component.onCompleted: {
            sizes.push(fifthSize)
        }
    }

    CacheSize {
        id: fourthSize
        frenchPattern: "Grande"
        sizeIdGs: 4
        Component.onCompleted: {
            sizes.push(fourthSize)
        }
    }

    CacheSize {
        id: thirdSize
        frenchPattern: "Normale"
        sizeIdGs: 3
        Component.onCompleted: {
            sizes.push(thirdSize)
        }
    }

    CacheSize {
        id: secondSize
        frenchPattern: "Petite"
        sizeIdGs: 8
        Component.onCompleted: {
            sizes.push(secondSize)
        }
    }

    CacheSize {
        id: firstSize
        frenchPattern: "Micro"
        sizeIdGs: 2
        Component.onCompleted: {
            sizes.push(firstSize)
        }
    }
}
