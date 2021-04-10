#ifndef CACHESPOCKETQUERIES_H
#define CACHESPOCKETQUERIES_H

#include "cachesretriever.h"

class Cache;

class CachesPocketqueries : public CachesRetriever
{
    Q_OBJECT

    Q_PROPERTY(bool parsingCompleted READ parsingCompleted WRITE setParsingCompleted NOTIFY parsingCompletedChanged)

public:
    explicit  CachesPocketqueries(CachesRetriever *parent = nullptr);
    ~CachesPocketqueries() override;

    Q_INVOKABLE void sendRequest(QString token , QString referenceCode);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
    void moreCaches() override;
    bool parsingCompleted();
    void setParsingCompleted(bool completed);

signals:
    void parsingCompletedChanged();

protected:
    void addGetRequestParameters(QString &parameters) override;

private:
    bool m_parsingCompleted;
};

#endif // CACHESPOCKETQUERIES_H
