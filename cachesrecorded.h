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

    Q_INVOKABLE void createRecordedCaches(const QList<QString> &list);
    Q_INVOKABLE bool updateMapCachesRecorded();
    Q_INVOKABLE void updateListCachesRecorded(int list);

    void moreCaches() override;

protected:
    QString addGetRequestParameters(QString parameters) override;

private:
    QMap<int,QList<Cache*> > m_mapCachesRecorded;
};

#endif // CACHESRECORDED_H
