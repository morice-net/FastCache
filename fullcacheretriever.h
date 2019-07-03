#ifndef FULLCACHERETRIEVER_H
#define FULLCACHERETRIEVER_H

#include "requestor.h"

#include <QNetworkReply>

class FullCache;
class FullCacheRetriever : public Requestor
{
    Q_OBJECT

public:
    explicit  FullCacheRetriever(Requestor *parent = nullptr);
    ~FullCacheRetriever() override;

    Q_INVOKABLE void sendRequest(QString token) override ;

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // FULLCACHERETRIEVER_H
