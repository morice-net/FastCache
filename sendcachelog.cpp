#include "sendcachelog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonObject>

SendCacheLog::SendCacheLog(Requestor *parent)
    : Requestor (parent)
    ,  m_count()
{   
}

SendCacheLog::~SendCacheLog()
{
}

QJsonDocument SendCacheLog::makeJsonLog(int logType , QString date , QString text , bool favorite)
{
    QJsonObject log;
    log.insert("loggedDate", QJsonValue(date));
    log.insert("text", QJsonValue(text));
    log.insert("usedFavoritePoint",QJsonValue(favorite));

    QJsonObject type;
    type.insert("id",logType);
    log.insert("geocacheLogType", type);

    return QJsonDocument(log);
}

void SendCacheLog::sendRequest(QString token , QString cacheCode, int logType , QString date , QString text , bool favorite)
{
    //Build url
    QString requestName = "geocachelogs?fields=referenceCode,owner";

    //Add parameters
    QJsonObject log;

    log.insert("geocacheCode", QJsonValue(cacheCode));
    log.insert("loggedDate", QJsonValue(date));
    log.insert("text", QJsonValue(text));
    log.insert("isEncoded",QJsonValue(false));
    log.insert("usedFavoritePoint",QJsonValue(favorite));

    QJsonObject type;
    type.insert("id",logType);
    log.insert("geocacheLogType", type);

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPostRequest(requestName,log,token);
}

void SendCacheLog::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject logJson;
    QJsonObject finderJson;

    logJson = dataJsonDoc.object();
    finderJson = logJson["owner"].toObject();
    setFounds(finderJson["findCount"].toInt());

    qDebug() << "*** logResponse**\n" << logJson;
    return ;
}

int SendCacheLog::founds() const
{
    return m_count;
}

void SendCacheLog::setFounds(const int &count)
{
    m_count = count;
    emit foundsChanged();
}

