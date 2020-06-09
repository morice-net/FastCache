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
    Q_INVOKABLE bool updateMapCachesRecorded();

    void moreCaches() override;

protected:
    void addGetRequestParameters(QString &parameters) override;

private:
    QMap<int,QList<Cache*> > m_mapCachesRecorded;
};

#endif // CACHESRECORDED_H
