#ifndef CACHESBBOX_H
#define CACHESBBOX_H

#include "requestor.h"

class CachesBBox : public Requestor
{

    Q_OBJECT

public:
    explicit  CachesBBox(QObject *parent = 0);
    ~CachesBBox();

    Q_INVOKABLE void sendRequest(QString token, double latBottomRight, double lonBottomRight , double latTopLeft , double lonTopLeft) ;

public slots:
    void onReplyFinished(QNetworkReply* reply);

private:
    int MAX_PER_PAGE=40;
    int GEOCACHE_LOG_COUNT=30;
    int TRACKABLE_LOG_COUNT=30;

    void   sendRequestMore(QString token);
};

#endif // CACHESBBOX_H
