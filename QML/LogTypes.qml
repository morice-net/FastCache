import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: logTypes
    property var types:[]

    LogType {
        id: five
        typeId: "NEEDS_ARCHIVE"
        frenchPattern: "Nécessite d'être archivée"
        typeIdGs: 7
        icon: "logTypes/marker_archive.png"
        Component.onCompleted: {
            types.push(five)
        }
    }

    LogType {
        id: four
        typeId: "NEEDS_MAINTENANCE"
        frenchPattern: "Nécessite une maintenance"
        typeIdGs: 45
        icon: "logTypes/marker_maintenance.png"
        Component.onCompleted: {
            types.push(four)
        }
    }

    LogType {
        id: three
        typeId: "NOTE"
        frenchPattern: "Note"
        typeIdGs: 4
        icon: "logTypes/marker_note.png"
        Component.onCompleted: {
            types.push(three)
        }
    }

    LogType {
        id: two
        typeId: "DIDNT_FIND_IT"
        frenchPattern: "Non trouvée"
        typeIdGs: 3
        icon: "logTypes/marker_not_found_offline.png"
        Component.onCompleted: {
            types.push(two)
        }
    }

    LogType {
        id: one
        typeId: "FOUND_IT"
        frenchPattern: "Trouvée"
        typeIdGs: 2
        icon: "logTypes/marker_found_offline.png"
        Component.onCompleted: {
            types.push(one)
        }
    }
}
