#ifndef CACHESRECORDED_H
#define CACHESRECORDED_H

#include "cachesretriever.h"

class Cache;

class CachesRecorded : public CachesRetriever

{
    Q_OBJECT

public:
    explicit  CachesRecorded(CachesRetriever *parent = nullptr);
    ~CachesRecorded() override;

    Q_INVOKABLE void parseRecordedJson(const QJsonDocument &dataJsonDoc);

    void moreCaches() override;

protected:
    void addGetRequestParameters(QString &parameters) override;
};

#endif // CACHESRECORDED_H
