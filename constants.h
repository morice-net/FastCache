#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QMap>

// Type of caches facilitator
extern const QMap<QString, int> CACHE_TYPE_MAP ;

// Type of caches (index in cacheList.png)
extern const QMap<QString, int> CACHE_TYPE_INDEX_MAP ;

// Size of caches facilitator
extern const QMap<QString, int> CACHE_SIZE_MAP ;

// Size of caches
extern const QMap<QString, int> CACHE_SIZE_INDEX_MAP ;

// Type of logs(cache) facilitator
extern const QMap<QString, int> LOG_TYPE_CACHE_MAP ;

// Type of logs(travelbugs) facilitator
extern const QMap<QString, int> LOG_TYPE_TB_MAP ;

// Type of logs (icons)
extern const QMap<QString, int> LOG_TYPE_ICON_MAP ;

// Type of waypoints facilitator
extern const QMap<QString, int> WPT_TYPE_MAP ;

// Type of logs (icons)
extern const QMap<QString, int> WPT_TYPE_ICON_MAP ;

const int MAX_PER_PAGE = 50;
const int GEOCACHE_LOGS_COUNT = 20;
const int GEOCACHE_LOG_IMAGES_COUNT = 10;
const int TRACKABLE_LOGS_COUNT = 20;
const int TRACKABLE_LOG_IMAGES_COUNT = 5;
const int IMAGES = 10;
const int USER_WAYPOINTS = 15;

#endif // CONSTANTS_H
