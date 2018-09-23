#ifndef FULLCACHE_H
#define FULLCACHE_H

#include <QNetworkReply>
#include <QObject>

#include "cache.h"

class FullCache : public Cache
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:
    explicit FullCache(Cache *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token) ;

    QString state() const;
    void setState(const QString &state);

public slots:  
    void onReplyFinished(QNetworkReply* reply)  ;

signals:
    void stateChanged();

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;

private:

    //  network manager

    QNetworkAccessManager *m_networkManager;

    QString m_state;
};

#endif // FULLCACHE_H
