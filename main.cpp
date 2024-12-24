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



