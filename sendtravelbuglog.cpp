#include "sendtravelbuglog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendTravelbugLog::SendTravelbugLog(Requestor *parent)
    : Requestor (parent)
{
}

SendTravelbugLog::~SendTravelbugLog()
{
}

void SendTravelbugLog::sendRequest(QString token ,QString geocode , QString tbCode, QString trackingCode , int logType , QString date , QString text)
{
    //Build url
    QString requestName = "trackablelogs?fields=referenceCode";

    //Add parameters
    QJsonObject log;
    log.insert("geocacheCode", QJsonValue(geocode));
    log.insert("trackableCode", QJsonValue(tbCode));
    log.insert("trackingNumber", QJsonValue(trackingCode));
    log.insert("loggedDate", QJsonValue(date));
    log.insert("text", QJsonValue(text));
    log.insert("isRot13Encoded",QJsonValue(false));

    QJsonObject type;
    type.insert("id",logType);
    log.insert("trackableLogType", type);

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPostRequest(requestName,log,token);
}

void SendTravelbugLog::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject logJson;
    logJson = dataJsonDoc.object();
    qDebug() << "*** logResponse**\n" << logJson;
    return ;
}





