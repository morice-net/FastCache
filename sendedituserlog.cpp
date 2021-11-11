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

void SendEditUserLog::sendRequest(QString token, QString referenceCode, QString geocode  , int logType , QString date , QString text , bool favorite)
{
    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode);
    qDebug() << "*** request name**\n" << requestName;

    // create geocacheLog
    QJsonObject geocacheLog;
    geocacheLog.insert("geocacheCode", QJsonValue(geocode));
    geocacheLog.insert("loggedDate", QJsonValue(date));
    geocacheLog.insert("text", QJsonValue(text));
    geocacheLog.insert("usedFavoritePoint", QJsonValue(favorite));
    QJsonObject type;
    type.insert("id",logType);
    geocacheLog.insert("geocacheLogType", type);

    //Add log
    QJsonObject jsonLog;
    jsonLog.insert("log", QJsonValue::fromVariant(geocacheLog));
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
