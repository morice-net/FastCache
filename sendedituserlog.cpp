#include "sendedituserlog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendEditUserLog::SendEditUserLog(Requestor *parent)
    : Requestor (parent)
{
}

SendEditUserLog::~SendEditUserLog()
{
}

void SendEditUserLog::sendRequest(QString token , QString referenceCode, QString log)
{
    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode);
    qDebug() << "*** request name**\n" << requestName;

    //Add log
    QJsonObject jsonLog;
    jsonLog.insert("log", QJsonValue::fromVariant(log));
    QJsonDocument Doc(jsonLog);
    QByteArray data = Doc.toJson();

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPutRequest(requestName , data,token);
}

void SendEditUserLog::parseJson(const QJsonDocument &dataJsonDoc)
{
    Q_UNUSED(dataJsonDoc)
}
