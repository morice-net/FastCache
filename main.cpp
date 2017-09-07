#include <QGuiApplication>
#if defined Q_OS_LINUX
#include <QtWebEngine/qtwebengineglobal.h>
#endif

#include <QQuickView>
#include <QQuickItem>
#include "connector.h"
#include "tools.h"
#include "userinfo.h"
#include "cachesbbox.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");
    qmlRegisterType<Tools>("com.mycompany.connecting", 1, 0, "Tools");
    qmlRegisterType<UserInfo>("com.mycompany.connecting", 1, 0, "UserInfo");
    qmlRegisterType<CachesBBox>("com.mycompany.connecting", 1, 0, "CachesBBox");

    QGuiApplication app(argc, argv);
#if defined Q_OS_LINUX
    QtWebEngine::initialize();
#endif

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));

    view.setWidth(450);
    view.setHeight(840);
    view.show();

    return app.exec();
}
