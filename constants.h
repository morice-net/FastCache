#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QMultiMap>

// Type of caches facilitator
const QMap<QString, int> CACHE_TYPE_MAP = {{"Traditionnelle",2},
                                           {"Multiple", 3},
                                           {"Virtuelle", 4},
                                           {"Boîte aux lettres hybride", 5},
                                           {"Evènement", 6},
                                           {"Mystère", 8},
                                           {"Project ape cache", 9},
                                           {"Webcam", 11},
                                           {"Locationless (Reverse) Cache", 12},
                                           {"Cito", 13},
                                           {"Earthcache", 137},
                                           {"Méga-Evènement", 453},
                                           {"GPS Adventures Exhibit", 1304},
                                           {"Wherigo", 1858 },
                                           {"Community Celebration Event", 3653},
                                           {"Siège de Groundspeak", 3773},
                                           {"Geocaching HQ Celebration", 3774 },
                                           {"fête locale Groundspeak", 4738},
                                           {"Giga-Evènement", 7005}, };

// Type of caches (index in cacheList.png)
const QMap<QString, int> CACHE_TYPE_INDEX_MAP = {{"0",2},
                                                 {"2", 3},
                                                 {"10", 4},
                                                 {"8", 5},
                                                 {"6", 6},
                                                 {"1", 8},
                                                 {"5", 9},
                                                 {"11", 11},
                                                 {"14", 12},
                                                 {"4", 13},
                                                 {"3", 137},
                                                 {"9", 453},
                                                 {"6", 1304},
                                                 {"12", 1858 },
                                                 {"6", 3653},
                                                 {"13", 3773},
                                                 {"14", 3774 },
                                                 {"6", 4738},
                                                 {"7", 7005}, };

// Size of caches facilitator
const QMap<QString, int> CACHE_SIZE_MAP = {{"Inconnue"  , 1},
                                           {"Micro" , 2},
                                           {"Petite" , 8},
                                           {"Normale" , 3},
                                           {"Grande" , 4},
                                           {"Virtuelle" , 5},
                                           {"Non renseignée" , 6}, };

// Size of caches
const QMap<QString, int> CACHE_SIZE_INDEX_MAP = {{"6"  , 1},
                                                 {"0" , 2},
                                                 {"1" , 8},
                                                 {"2" , 3},
                                                 {"3" , 4},
                                                 {"5" , 5},
                                                 {"4" , 6}, };

// Type of logs(cache) facilitator
const QMap<QString, int> LOG_TYPE_CACHE_MAP = {{"Trouvée" , 2},
                                               {"Non trouvée" , 3},
                                               {"Note" , 4},
                                               {"Archivée" , 5},
                                               {"Archivée en permanence" , 6},
                                               {"Nécessite d\'être archivée" , 7},
                                               {"Participera" , 9},
                                               {"A participé" , 10},
                                               {"Photo prise par la webcam" , 11},
                                               {"Désarchivée" , 12},
                                               {"Désactivée" , 22},
                                               {"Activée" , 23},
                                               {"Publier une annonce" , 24},
                                               {"Visite retirée" , 25},
                                               {"Nécessite une maintenance" , 45},
                                               {"Maintenance effectuée" , 46},
                                               {"Coordonnées mises à jour" , 47},
                                               {"Note du reviewer" , 68},
                                               {"Annonce" , 74},};

// Type of logs(travelbugs) facilitator
const QMap<QString, int> LOG_TYPE_TB_MAP = {{"Note", 4},
                                            {"Récupéré", 13},
                                            {"Déposé", 14},
                                            {"Transfert", 15},
                                            {"Marquer comme absente", 16},
                                            {"Pris ailleurs", 19},
                                            {"Découvert", 48},
                                            {"Ajouté à une collection", 69},
                                            {"Ajouté à l\'inventaire", 70},
                                            {"Visité", 75}};

// Type of logs (icons)
const QMap<QString, int> LOG_TYPE_ICON_MAP = {{"logTypes/marker_found_offline.png" , 2},
                                              {"logTypes/marker_not_found_offline.png" , 3},
                                              {"logTypes/marker_note.png" , 4},
                                              {"" , 5},
                                              {"" , 6},
                                              {"logTypes/marker_archive.png" , 7},
                                              {"" , 9},
                                              {"", 10},
                                              {"" , 11},
                                              {"" , 12},
                                              {"" , 22},
                                              {"" , 23},
                                              {"" , 24},
                                              {"" , 25},
                                              {"logTypes/marker_maintenance.png" , 45},
                                              {"" , 46},
                                              {"" , 47},
                                              {"" , 68},
                                              {"" , 74},};

// Type of waypoints facilitator
const QMap<QString, int> WPT_TYPE_MAP = {{"Parking" , 217},
                                         {"Enigme" , 218},
                                         {"Etape" , 219},
                                         {"Etape finale" , 220},
                                         {"Départ du sentier" , 221},
                                         {"Point de repère" , 452},};

// Type of logs (icons)
const QMap<QString, int> WPT_TYPE_ICON_MAP = {{"qrc:/Image/Waypoints/waypoint_pkg.png", 217},
                                              {"qrc:/Image/Waypoints/waypoint_puzzle.png", 218},
                                              {"qrc:/Image/Waypoints/waypoint_stage.png", 219},
                                              {"qrc:/Image/Waypoints/waypoint_flag.png", 220},
                                              {"qrc:/Image/Waypoints/waypoint_trailhead.png", 221},
                                              {"qrc:/Image/Waypoints/waypoint_waypoint.png", 452},};

const int MAX_PER_PAGE = 50;
const int GEOCACHE_LOGS_COUNT = 20;
const int GEOCACHE_LOG_IMAGES_COUNT = 10;
const int TRACKABLE_LOGS_COUNT = 20;
const int TRACKABLE_LOG_IMAGES_COUNT = 5;
const int IMAGES = 10;
const int USER_WAYPOINTS = 15;

#endif // CONSTANTS_H
