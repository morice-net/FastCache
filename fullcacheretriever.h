#ifndef FULLCACHERETRIEVER_H
#define FULLCACHERETRIEVER_H

#include "requestor.h"
#include "fullcache.h"

#include <QNetworkReply>

class FullCache;
class FullCacheRetriever : public Requestor
{
    Q_OBJECT

public:
    explicit  FullCacheRetriever(Requestor *parent = nullptr);
    ~FullCacheRetriever() override;

    Q_INVOKABLE void sendRequest(QString token) override ;
    Q_INVOKABLE void updateFullCache(FullCache *fullCache);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:
    FullCache *m_fullCache;
};

#endif // FULLCACHERETRIEVER_H