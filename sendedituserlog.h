#ifndef SENDEDITUSERLOG_H
#define SENDEDITUSERLOG_H

#include "requestor.h"

#include <QNetworkReply>
#include <QObject>


class SendEditUserLog : public Requestor
{
    Q_OBJECT

public:
    explicit  SendEditUserLog(Requestor *parent = nullptr);
    ~SendEditUserLog() override;

    Q_INVOKABLE void sendRequest(QString token, QString referenceCode, QString log);

    void parseJson(const QJsonDocument &dataJsonDoc) override;
};

#endif // SENDEDITUSERLOG_H
