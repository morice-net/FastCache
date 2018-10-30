import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: waypointTypes
    property var types:[]

    WaypointType {
        id: one
        icon: "waypoint_flag.png"
        name: "Final Location"
        nameFr: "Etape finale"
        Component.onCompleted: {
            types.push(one)
        }
    }

    WaypointType {
        id: two
        icon: "waypoint_waypoint.png"
        name: "Own"
        nameFr: "Posséder"
        Component.onCompleted: {
            types.push(two)
        }
    }

    WaypointType {
        id: three
        icon: "waypoint_pkg.png"
        name: "Parking Area"
        nameFr: "Parking"
        Component.onCompleted: {
            types.push(three)
        }
    }

    WaypointType {
        id: four
        icon: "waypoint_puzzle.png"
        name: "Virtual Stage"
        nameFr: "Enigme"
        Component.onCompleted: {
            types.push(four)
        }
    }

    WaypointType {
        id: five
        icon: "waypoint_stage.png"
        name: "Physical Stage"
        nameFr: "Etape"
        Component.onCompleted: {
            types.push(five)
        }
    }

    WaypointType {
        id: six
        icon: "waypoint_trailhead.png"
        name: "Trailhead"
        nameFr: "Départ du sentier"
        Component.onCompleted: {
            types.push(six)
        }
    }

    WaypointType {
        id: seven
        icon: "waypoint_waypoint.png"
        name: "Reference Point"
        nameFr: "Point de repère"
        Component.onCompleted: {
            types.push(seven)
        }
    }

    WaypointType {
        id: height
        icon: "waypoint_waypoint.png"
        name:"Original Coordinates"
        nameFr: "Coordonnées d'origine"
        Component.onCompleted: {
            types.push(height)
        }
    }
}
