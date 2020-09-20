#ifndef FULLCACHESRECORDED_H
#define FULLCACHESRECORDED_H

#include "requestor.h"
#include "sqlitestorage.h"
#include "replaceimageintext.h"

#include <QNetworkReply>

class ReplaceImageInText;

class FullCachesRecorded : public Requestor
{
    Q_OBJECT

public:
    explicit  FullCachesRecorded(Requestor *parent = nullptr);
    ~FullCachesRecorded() override;

    Q_INVOKABLE void sendRequest(QString token , QList<QString> geocodes , QList<bool> cachesLists , SQLiteStorage *sqliteStorage);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:
    ReplaceImageInText* m_replaceImageInText = new ReplaceImageInText;
    QList<bool> m_cachesLists;
    SQLiteStorage *m_sqliteStorage;
};

#endif // FULLCACHESRECORDED_H
