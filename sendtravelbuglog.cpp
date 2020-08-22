#include "sendtravelbuglog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QString>

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

    QString   tbCode;
    QString   trackingCode;
    QString   logType;
    QString   text;

    for(int i = 0; i < list.size(); ++i)
    {
        tbCode = list[i].split(',')[0];
        trackingCode = list[i].split(',')[1];
        logType = list[i].split(',')[2];
        text = list[i].mid(list[i].split(',')[0].length() + list[i].split(',')[1].length() + list[i].split(',')[2].length()
                + list[i].split(',')[3].length() + 4);

        item.insert("tbCode", QJsonValue(tbCode));
        item.insert("trackingCode", QJsonValue(trackingCode));
        item.insert("logType", QJsonValue(logType));
        item.insert("text", QJsonValue(text));

        tbsUserLog.push_back(QJsonValue(item));
    }

    QJsonObject doc;
    doc.insert("array", QJsonValue(tbsUserLog));

    QJsonDocument logDoc(doc);
    return logDoc;
}

QList<QString> SendTravelbugLog::readJsonArray(const QJsonDocument &jsonDoc)
{
    // return list of strings of the form: tbCode,trackingNumber,logType,text

    QList<QString> list;
    QString type;
    QJsonObject jsonObject = jsonDoc.object();
    QJsonArray jsonArray = jsonObject["array"].toArray();
    QJsonValue jsonValue;
    for(int i = 0; i < jsonArray.count(); i++)
    {
        jsonValue = jsonArray[i];
        list.append(jsonValue["tbCode"].toString() + "," + jsonValue["trackingCode"].toString() + "," + jsonValue["logType"].toString() +
                "," + jsonValue["text"].toString());
    }
    qDebug()<<"List: "<< list;
    return list;
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





