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

    Q_INVOKABLE void sendRequest(QString token , QString tbCode, int logType , QString date , QString log ) ;

    void parseJson(const QJsonDocument &dataJsonDoc) override;

};

#endif // SENDTRAVELBUGLOG_H
