#include "bluetoothgps.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#if !defined Q_OS_ANDROID
#include <QtWebEngineQuick/qtwebenginequickglobal.h>
#endif

#include <QQuickView>
#include <QQuickItem>
#include "connector.h"
#include "userinfo.h"
#include "cachesbbox.h"
#include "cachesnear.h"
#include "cachesrecorded.h"
#include "cache.h"
#include "fullcache.h"
#include "cacheattribute.h"
#include "sendcachenote.h"
#include "sendcachelog.h"
#include "sendimageslog.h"
#include "sendtravelbuglog.h"
#include "sendtravelbuglog.h"
#include "sendedituserlog.h"
#include "travelbug.h"
#include "replaceimageintext.h"
#include "fullcacheretriever.h"
#include "sqlitestorage.h"
#include "gettravelbuguser.h"
#include "getpocketsquerieslist.h"
#include "getusergeocachelogs.h"
#include "getgeocachelogimages.h"
#include "senduserwaypoint.h"
#include "fullcachesrecorded.h"
#include "cachessinglelist.h"
#include "cachespocketqueries.h"
#include "deletelogimage.h"
#include "tilesdownloader.h"
#include "cachemaptiles.h"
#include "adventurelabcachesretriever.h"
#include "fulllabcacheretriever.h"
#include "fulllabcachesrecorded.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");
    qmlRegisterType<UserInfo>("com.mycompany.connecting", 1, 0, "UserInfo");
    qmlRegisterType<Cache>("com.mycompany.connecting", 1, 0, "Cache");
    qmlRegisterType<FullCache>("com.mycompany.connecting", 1, 0, "FullCache");
    qmlRegisterType<CachesBBox>("com.mycompany.connecting", 1, 0, "CachesBBox");
    qmlRegisterType<CachesNear>("com.mycompany.connecting", 1, 0, "CachesNear");
    qmlRegisterType<CachesRecorded>("com.mycompany.connecting", 1, 0, "CachesRecorded");
    qmlRegisterType<CacheAttribute>("com.mycompany.connecting", 1, 0, "CacheAttribute");
    qmlRegisterType<SendCacheNote>("com.mycompany.connecting", 1, 0, "SendCacheNote");
    qmlRegisterType<SendCacheLog>("com.mycompany.connecting", 1, 0, "SendCacheLog");
    qmlRegisterType<SendImagesLog>("com.mycompany.connecting", 1, 0, "SendImagesLog");
    qmlRegisterType<SendTravelbugLog>("com.mycompany.connecting", 1, 0, "SendTravelbugLog");
    qmlRegisterType<SendEditUserLog>("com.mycompany.connecting", 1, 0, "SendEditUserLog");
    qmlRegisterType<Travelbug>("com.mycompany.connecting", 1, 0, "Travelbug");
    qmlRegisterType<FullCacheRetriever>("com.mycompany.connecting", 1, 0, "FullCacheRetriever");
    qmlRegisterType<SQLiteStorage>("com.mycompany.connecting", 1, 0, "SQLiteStorage");
    qmlRegisterType<GetTravelbugUser>("com.mycompany.connecting", 1, 0, "GetTravelbugUser");
    qmlRegisterType<GetPocketsqueriesList>("com.mycompany.connecting", 1, 0, "GetPocketsqueriesList");
    qmlRegisterType<SendUserWaypoint>("com.mycompany.connecting", 1, 0, "SendUserWaypoint");
    qmlRegisterType<FullCachesRecorded>("com.mycompany.connecting", 1, 0, "FullCachesRecorded");
    qmlRegisterType<CachesSingleList>("com.mycompany.connecting", 1, 0, "CachesSingleList");
    qmlRegisterType<CachesPocketqueries>("com.mycompany.connecting", 1, 0, "CachesPocketqueries");
    qmlRegisterType<GetUserGeocacheLogs>("com.mycompany.connecting", 1, 0, "GetUserGeocacheLogs");
    qmlRegisterType<GetGeocacheLogImages>("com.mycompany.connecting", 1, 0, "GetGeocacheLogImages");
    qmlRegisterType<DeleteLogImage>("com.mycompany.connecting", 1, 0, "DeleteLogImage");
    qmlRegisterType<TilesDownloader>("com.mycompany.connecting", 1, 0, "TilesDownloader");
    qmlRegisterType<ReplaceImageInText>("com.mycompany.connecting", 1, 0, "ReplaceImageInText");
    qmlRegisterType<CacheMapTiles>("com.mycompany.connecting", 1, 0, "CacheMapTiles");
    qmlRegisterType<AdventureLabCachesRetriever>("com.mycompany.connecting", 1, 0, "AdventureLabCachesRetriever");
    qmlRegisterType<FullLabCacheRetriever>("com.mycompany.connecting", 1, 0, "FullLabCacheRetriever");
    qmlRegisterType<FullLabCachesRecorded>("com.mycompany.connecting", 1, 0, "FullLabCachesRecorded");
    qmlRegisterType<BluetoothGps>("com.mycompany.connecting", 1, 0, "BluetoothGps");

#if !defined Q_OS_ANDROID
    QtWebEngineQuick::initialize();
#endif

    QCoreApplication::setOrganizationName("QtProject");
    QCoreApplication::setApplicationName("FastCache");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("FastCache", "Main");
    return app.exec();
}



