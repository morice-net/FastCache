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

    QString   tbCode;
    QString   trackingCode;
    QString   logType;
    QString   dateIso;
    QString   text;

    for(int i = 0; i < list.size(); ++i)
    {
        tbCode = list[i].split(',')[0];
        trackingCode = list[i].split(',')[1];
        logType = list[i].split(',')[2];
        dateIso = list[i].split(',')[3];
        text = list[i].mid(tbCode.length() + trackingCode.length() + logType.length() + dateIso.length() + 4);

        item.insert("tbCode", QJsonValue(tbCode));
        item.insert("trackingCode", QJsonValue(trackingCode));
        item.insert("logType", QJsonValue(logType));
        item.insert("dateIso", QJsonValue(dateIso));
        item.insert("text", QJsonValue(text));

        tbsUserLog.push_back(QJsonValue(item));
    }

    QJsonObject doc;
    doc.insert("array", QJsonValue(tbsUserLog));

    QJsonDocument logDoc(doc);
    return logDoc;
}

QJsonDocument SendTravelbugLog::makeJsonTbLog(const QString &trackingCode , const int &logType , const QString &date , const QString &text )
{
    QJsonObject log;
    log.insert("trackingCode", QJsonValue(trackingCode));
    log.insert("logType", QJsonValue(logType));
    log.insert("loggedDate", QJsonValue(date));
    log.insert("text", QJsonValue(text));

    QJsonDocument logDoc(log);
    return logDoc;
}

QVariant SendTravelbugLog::readJsonProperty(const QJsonDocument &jsonDoc, QString propertyName)
{
    QJsonObject json = jsonDoc.object();
    return json[propertyName].toVariant();
}


QList<QString> SendTravelbugLog::readJsonArray(const QJsonDocument &jsonDoc)
{
    // return list of strings of the form: tbCode,trackingNumber,logType,dateIso,text
    QList<QString> list;
    QJsonObject jsonObject = jsonDoc.object();
    QJsonArray jsonArray = jsonObject["array"].toArray();
    QJsonValue jsonValue;
    for(int i = 0; i < jsonArray.count(); i++)
    {
        jsonValue = jsonArray[i];
        list.append(jsonValue["tbCode"].toString() + "," + jsonValue["trackingCode"].toString() + "," + jsonValue["logType"].toString() +
                "," + jsonValue["dateIso"].toString() + ","  + jsonValue["text"].toString());
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





