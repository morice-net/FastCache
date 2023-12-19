#ifndef FULLLABCACHESRECORDED_H
#define FULLLABCACHESRECORDED_H

#include "requestor.h"
#include "sqlitestorage.h"

#include <QNetworkReply>

class FullLabCachesRecorded : public Requestor
{
    Q_OBJECT

public:
    explicit  FullLabCachesRecorded(Requestor *parent = nullptr);
    ~FullLabCachesRecorded() override;

    Q_INVOKABLE void sendRequest(QString token , QList<QString> geocodes , QList<double> latitudes, QList<double> longitudes
                                 , QList<bool> cachesLists , SQLiteStorage *sqliteStorage);    
    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:
    QList<bool> m_cachesLists;    
    SQLiteStorage *m_sqliteStorage;   
    QString m_tokenTemp;  
    QJsonDocument m_dataJson;   // json for get adventure lab
};
#endif // FULLLABCACHESRECORDED_H
