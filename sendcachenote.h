#ifndef SENDCACHENOTE_H
#define SENDCACHENOTE_H

#include <QNetworkReply>
#include <QObject>


class SendCacheNote : public QObject
{
    Q_OBJECT

public:    

    explicit SendCacheNote(QObject *parent = nullptr);

    Q_INVOKABLE void updateCacheNote(QString token , QString cacheCode, QString note) ;


public slots:
    void onReplyFinished(QNetworkReply* reply) ;

private:

    //  network manager

    QNetworkAccessManager *m_networkManager;
};

#endif // SENDCACHENOTE_H
