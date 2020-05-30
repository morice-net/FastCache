#ifndef CACHESRECORDED_H
#define CACHESRECORDED_H

#include "cachesretriever.h"
#include "sqlitestorage.h"
#include <QMap>

class Cache;

class CachesRecorded : public CachesRetriever

{
    Q_OBJECT

public:
    explicit  CachesRecorded(CachesRetriever *parent = nullptr);
    ~CachesRecorded() override;

    Q_INVOKABLE void parseRecordedJson(const QJsonDocument &dataJsonDoc);
    Q_INVOKABLE void emptyList();

    void moreCaches() override;
    void updateMapCachesRecorded(SQLiteStorage *sqliteStorage) ;

protected:
    void addGetRequestParameters(QString &parameters) override;

private:
    QMap<int, QString > m_mapCachesRecorded;
};

#endif // CACHESRECORDED_H
