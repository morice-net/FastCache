#ifndef SENDTRAVELBUGLOG_H
#define SENDTRAVELBUGLOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>
#include <QtQml>

class SendTravelbugLog : public Requestor
{    
    Q_OBJECT
    QML_ELEMENT

public:
    explicit  SendTravelbugLog(Requestor *parent = nullptr);
    ~SendTravelbugLog() override;

    Q_INVOKABLE void sendRequest(QString token , QString geocode , QString tbCode, QString trackingCode ,int logType , QString date , QString log ) ;
    Q_INVOKABLE QJsonDocument makeJsonTbsUserLog(const QList<QString> &list);
    Q_INVOKABLE QJsonDocument makeJsonTbLog(const QString &trackingCode , const int &logType , const QString &date , const QString &text );
    Q_INVOKABLE QList<QString> readJsonArray(const QJsonDocument &jsonDoc);
    Q_INVOKABLE QVariant readJsonProperty(const QJsonDocument &jsonDoc, QString propertyName);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // SENDTRAVELBUGLOG_H
