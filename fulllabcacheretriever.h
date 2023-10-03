#ifndef FULLLABCACHERETRIEVER_H
#define FULLLABCACHERETRIEVER_H

#include "requestor.h"
#include "fullcache.h"
#include "cachessinglelist.h"

#include <QNetworkReply>

class FullCache;
class FullLabCacheRetriever : public Requestor
{
    Q_OBJECT

public:
    explicit  FullLabCacheRetriever(Requestor *parent = nullptr);
    ~FullLabCacheRetriever() override;

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void updateFullCache(FullCache *fullCache);
    Q_INVOKABLE  void parseJson(const QJsonDocument &dataJsonDoc) override;
    Q_INVOKABLE void listCachesObject(CachesSingleList *listCaches);

private:
    FullCache *m_fullCache;
    QJsonDocument m_dataJson;
    CachesSingleList *m_listCaches;
};

#endif // FULLLABCACHERETRIEVER_H
