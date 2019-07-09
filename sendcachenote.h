#ifndef SENDCACHENOTE_H
#define SENDCACHENOTE_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>

class SendCacheNote : public Requestor
{
    Q_OBJECT

public:
    explicit  SendCacheNote(Requestor *parent = nullptr);
    ~SendCacheNote() override;

    Q_INVOKABLE void sendRequest(QString token, QString cacheCode, QString note);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:
    QString m_geocode ;
    QString m_note;

    //  network manager

    QNetworkAccessManager *m_networkManager;
};

#endif // SENDCACHENOTE_H
