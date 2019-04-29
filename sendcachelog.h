#ifndef SENDCACHELOG_H
#define SENDCACHELOG_H

#include <QNetworkReply>
#include <QObject>


class SendCacheLog : public QObject
{
    Q_OBJECT

public:

    explicit SendCacheLog(QObject *parent = nullptr);

    Q_INVOKABLE void cacheLog(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite) ;


public slots:
    void onReplyFinished(QNetworkReply* reply) ;

private:

    //  network manager

    QNetworkAccessManager *m_networkManager;
};

#endif // SENDCACHELOG_H
