#include <QGuiApplication>
#include <QQuickView>
#include <QQuickItem>
#include <QtWebEngine>
#include "connector.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");

    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setWidth(450);
    view.setHeight(840);
    view.show();

    return app.exec();
}
