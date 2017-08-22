#include <QGuiApplication>
#if !defined Q_OS_ANDROID
    #include <QtWebEngine/qtwebengineglobal.h>
#endif

#include <QQuickView>
#include <QQuickItem>
#include "connector.h"
#include "tools.h"
#include "userinfo.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");
    qmlRegisterType<Tools>("com.mycompany.connecting", 1, 0, "Tools");
    qmlRegisterType<UserInfo>("com.mycompany.connecting", 1, 0, "UserInfo");

    QGuiApplication app(argc, argv);
#if !defined Q_OS_ANDROID
    QtWebEngine::initialize();
#endif

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));

    view.setWidth(450);
    view.setHeight(840);
    view.show();

    return app.exec();
}
