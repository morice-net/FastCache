#ifndef FULLLABCACHESRECORDED_H
#define FULLLABCACHESRECORDED_H

#include "requestor.h"
#include "sqlitestorage.h"
#include "fullcache.h"
#include "cachessinglelist.h"

#include <QNetworkReply>

class FullLabCachesRecorded : public Requestor
{
    Q_OBJECT

public:
    explicit  FullLabCachesRecorded(Requestor *parent = nullptr);
    ~FullLabCachesRecorded() override;

    Q_INVOKABLE void sendRequest(QString token , QList<QString> geocodes , QList<bool> cachesLists , SQLiteStorage *sqliteStorage);
    Q_INVOKABLE void updateCachesSingleList(CachesSingleList *listCaches);
    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:
    QList<bool> m_cachesLists;    
    SQLiteStorage *m_sqliteStorage;   
    QString m_tokenTemp;
    FullCache *m_fullCache;
    QJsonDocument m_dataJson;
    CachesSingleList *m_listCaches;    
};

#endif // FULLLABCACHESRECORDED_H
