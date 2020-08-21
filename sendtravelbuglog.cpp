#include "sendtravelbuglog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

SendTravelbugLog::SendTravelbugLog(Requestor *parent)
    : Requestor (parent)
{
}

SendTravelbugLog::~SendTravelbugLog()
{
}

QJsonDocument SendTravelbugLog::makeJsonTbsUserLog(const QList<QString> &list )
{
    QJsonArray tbsUserLog;
    QJsonObject item;
    for(int i = 0; i < list.size(); ++i)
    {
        item.insert("tbCode", QJsonValue(list[i].split(',')[0]));
        item.insert("trackingCode", QJsonValue(list[i].split(',')[1]));
        item.insert("logType", QJsonValue(list[i].split(',')[2]));
        item.insert("text", QJsonValue(list[i].split(',')[4]));
        tbsUserLog.push_back(QJsonValue(item));
    }

    QJsonObject doc;
    doc.insert("array", QJsonValue(tbsUserLog));

    QJsonDocument logDoc(doc);
    return logDoc;
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





