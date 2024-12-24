#ifndef SENDCACHENOTE_H
#define SENDCACHENOTE_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QtQml>

class SendCacheNote : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit  SendCacheNote(Requestor *parent = nullptr);
    ~SendCacheNote() override;

    Q_INVOKABLE void sendRequest(QString token, QString cacheCode, QString note);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

private:
    QString m_geocode ;
    QString m_note;
};

#endif // SENDCACHENOTE_H
