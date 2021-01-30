#include <QGuiApplication>

#if !defined Q_OS_ANDROID
#include <QtWebEngine/qtwebengineglobal.h>
#endif

#include <QQuickView>
#include <QQuickItem>
#include "connector.h"
#include "tools.h"
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
#include "smileygc.h"
#include "travelbug.h"
#include "fullcacheretriever.h"
#include "sqlitestorage.h"
#include "gettravelbuguser.h"
#include "senduserwaypoint.h"
#include "fullcachesrecorded.h"
#include "cachessinglelist.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");
    qmlRegisterType<Tools>("com.mycompany.connecting", 1, 0, "Tools");
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
    qmlRegisterType<Travelbug>("com.mycompany.connecting", 1, 0, "Travelbug");
    qmlRegisterType<FullCacheRetriever>("com.mycompany.connecting", 1, 0, "FullCacheRetriever");
    qmlRegisterType<SQLiteStorage>("com.mycompany.connecting", 1, 0, "SQLiteStorage");
    qmlRegisterType<GetTravelbugUser>("com.mycompany.connecting", 1, 0, "GetTravelbugUser");
    qmlRegisterType<SendUserWaypoint>("com.mycompany.connecting", 1, 0, "SendUserWaypoint");
    qmlRegisterType<FullCachesRecorded>("com.mycompany.connecting", 1, 0, "FullCachesRecorded");
    qmlRegisterType<CachesSingleList>("com.mycompany.connecting", 1, 0, "CachesSingleList");

#if !defined Q_OS_ANDROID
    QtWebEngine::initialize();
#endif

    QGuiApplication app(argc, argv);
    app.setOrganizationName("morice");
    app.setOrganizationDomain("ipsquad.net");
    app.setApplicationName("FastCache");
    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setWidth(450);
    view.setHeight(840);
    view.show();

    QObject::connect((QObject*)view.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
