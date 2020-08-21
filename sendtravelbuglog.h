#ifndef SENDTRAVELBUGLOG_H
#define SENDTRAVELBUGLOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>


class SendTravelbugLog : public Requestor
{    
    Q_OBJECT

public:
    explicit  SendTravelbugLog(Requestor *parent = nullptr);
    ~SendTravelbugLog() override;

    Q_INVOKABLE void sendRequest(QString token , QString geocode , QString tbCode, QString trackingCode ,int logType , QString date , QString log ) ;
    Q_INVOKABLE QJsonDocument makeJsonTbsUserLog(const QList<QString> &list);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

};

#endif // SENDTRAVELBUGLOG_H
