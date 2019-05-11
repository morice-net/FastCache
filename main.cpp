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
#include "cachetype.h"
#include "cachesize.h"
#include "cache.h"
#include "fullcache.h"
#include "cacheattribute.h"
#include "sendcachenote.h"
#include "sendcachelog.h"
#include "smileygc.h"
#include "waypointtype.h"
#include "logtype.h"
#include "travelbug.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");
    qmlRegisterType<Tools>("com.mycompany.connecting", 1, 0, "Tools");
    qmlRegisterType<UserInfo>("com.mycompany.connecting", 1, 0, "UserInfo");
    qmlRegisterType<Cache>("com.mycompany.connecting", 1, 0, "Cache");
    qmlRegisterType<FullCache>("com.mycompany.connecting", 1, 0, "FullCache");
    qmlRegisterType<CachesBBox>("com.mycompany.connecting", 1, 0, "CachesBBox");
    qmlRegisterType<CachesNear>("com.mycompany.connecting", 1, 0, "CachesNear");
    qmlRegisterType<CacheType>("com.mycompany.connecting", 1, 0, "CacheType");
    qmlRegisterType<CacheSize>("com.mycompany.connecting", 1, 0, "CacheSize");
    qmlRegisterType<CacheAttribute>("com.mycompany.connecting", 1, 0, "CacheAttribute");
    qmlRegisterType<SendCacheNote>("com.mycompany.connecting", 1, 0, "SendCacheNote");
    qmlRegisterType<SendCacheLog>("com.mycompany.connecting", 1, 0, "SendCacheLog");
    qmlRegisterType<WaypointType>("com.mycompany.connecting", 1, 0, "WaypointType");
    qmlRegisterType<LogType>("com.mycompany.connecting", 1, 0, "LogType");
    qmlRegisterType<Travelbug>("com.mycompany.connecting", 1, 0, "Travelbug");

    QGuiApplication app(argc, argv);
#if !defined Q_OS_ANDROID
    QtWebEngine::initialize();
#endif

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));

    view.setWidth(450);
    view.setHeight(840);
    view.show();
    QObject::connect((QObject*)view.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
