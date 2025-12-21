#ifndef WHERIGOCARTRIDGE_H
#define WHERIGOCARTRIDGE_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QtQml>

class WherigoCartridge : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit  WherigoCartridge(Requestor *parent = nullptr);
    ~WherigoCartridge() ;

    Q_INVOKABLE void downloadCartridge(QString token , QString cartridgeGuid , QString geocode);

    void parseJson(const QJsonDocument &dataJsonDoc) ;

private:
    QString m_dir = "./wherigoCartridges/";
    QString m_geocode;
    QString m_cartridgeGuid;
};

#endif // WHERIGOCARTRIDGE_H
