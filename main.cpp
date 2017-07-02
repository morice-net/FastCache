#include <QGuiApplication>
#include <QQuickView>
#include <QQuickItem>
#include "connector.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Connector>("com.mycompany.connecting", 1, 0, "Connector");

    QGuiApplication app(argc, argv);

    QQuickView view(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setWidth(450);
    view.setHeight(840);
    view.show();

    return app.exec();
}
