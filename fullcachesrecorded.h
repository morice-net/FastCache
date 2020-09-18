#ifndef FULLCACHESRECORDED_H
#define FULLCACHESRECORDED_H

#include "requestor.h"
#include "sqlitestorage.h"

#include <QNetworkReply>

class FullCachesRecorded : public Requestor
{
    Q_OBJECT

public:
    explicit  FullCachesRecorded(Requestor *parent = nullptr);
    ~FullCachesRecorded() override;

    Q_INVOKABLE void sendRequest(QString token , QList<QString> geocodes);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // FULLCACHESRECORDED_H
