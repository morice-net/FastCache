#include <QGuiApplication>
#include <QQuickView>
#include <QQuickItem>

#include "connector.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));
    QObject *root = view.rootObject();

    Connector connector;
    QObject::connect ( root, SIGNAL(connect(QString,QString)), &connector, SLOT(onConnect(QString,QString)) );


    view.show();
    return app.exec();
}
