#ifndef CACHESPOCKETQUERIES_H
#define CACHESPOCKETQUERIES_H

#include "cachesretriever.h"

class Cache;

class CachesPocketqueries : public CachesRetriever
{
    Q_OBJECT

public:
    explicit  CachesPocketqueries(CachesRetriever *parent = nullptr);
    ~CachesPocketqueries() override;

    Q_INVOKABLE void sendRequest(QString token , QString referenceCode);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
    void moreCaches() override;

protected:
    void addGetRequestParameters(QString &parameters) override;
};

#endif // CACHESPOCKETQUERIES_H
