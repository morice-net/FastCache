#ifndef CACHESRECORDED_H
#define CACHESRECORDED_H

#include "cachesretriever.h"

#include <QMap>

class Cache;

class CachesRecorded : public CachesRetriever

{
    Q_OBJECT

public:
    explicit  CachesRecorded(CachesRetriever *parent = nullptr);
    ~CachesRecorded() override;

    void createRecordedCaches(const QList<QString> &list);
    void moreCaches() override;

    Q_INVOKABLE bool updateMapCachesRecorded();
    Q_INVOKABLE void updateListCachesRecorded(int list);    

protected:
    QString addGetRequestParameters(QString parameters) override;

private:
    QMap<int,QList<Cache*> > m_mapCachesRecorded;
};

#endif // CACHESRECORDED_H
