#include <QGuiApplication>
#include <QtWebEngine/qtwebengineglobal.h>
#include <QQuickView>
#include <QQuickItem>
#include "connector.h"
#include "tools.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");
    qmlRegisterType<Tools>("com.mycompany.connecting", 1, 0, "Tools");

    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));

    view.setWidth(450);
    view.setHeight(840);
    view.show();

    return app.exec();
}
