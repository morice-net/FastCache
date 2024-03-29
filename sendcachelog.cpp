#include "sendcachelog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonObject>

SendCacheLog::SendCacheLog(Requestor *parent)
    : Requestor (parent)
    ,  m_count()
    ,  m_codeLog("")
    ,  m_logTypeResponse()
    ,  m_parsingCompleted(false)
    ,  m_favorited(false)
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
    log.insert("geocacheLogType", QJsonValue(logType));

    QJsonDocument logDoc(log);
    return logDoc;
}

QVariant SendCacheLog::readJsonProperty(const QJsonDocument &jsonDoc, QString propertyName)
{
    QJsonObject json = jsonDoc.object();
    return json[propertyName].toVariant();
}

void SendCacheLog::sendRequest(QString token , QString cacheCode, int logType , QString date , QString text , bool favorite)
{
    //Build url
    QString requestName = "geocachelogs?fields=referenceCode,owner,geocacheLogType,usedFavoritePoint";

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
    setParsingCompleted(false);

    QJsonObject logJson;
    QJsonObject finderJson;
    QJsonObject logTypeJson;

    logJson = dataJsonDoc.object();
    setCodeLog(logJson["referenceCode"].toString());
    setFavorited(logJson["usedFavoritePoint"].toBool());
    finderJson = logJson["owner"].toObject();
    setFounds(finderJson["findCount"].toInt());
    logTypeJson = logJson["geocacheLogType"].toObject();
    setLogTypeResponse(logTypeJson ["id"].toInt());

    qDebug() << "*** logResponse**\n" << logJson;
    setParsingCompleted(true);
    return ;
}

/** Getters & Setters **/

int SendCacheLog::founds() const
{
    return m_count;
}

void SendCacheLog::setFounds(const int &count)
{
    m_count = count;
    emit foundsChanged();
}

QString SendCacheLog::codeLog() const
{
    return m_codeLog;
}

void SendCacheLog::setCodeLog(const QString &code)
{
    m_codeLog = code;
    emit codeLogChanged();
}

int SendCacheLog::logTypeResponse() const
{
    return m_logTypeResponse;
}

void SendCacheLog::setLogTypeResponse(const int &type)
{
    m_logTypeResponse = type;
    emit logTypeResponseChanged();
}

bool SendCacheLog::parsingCompleted() const
{
    return m_parsingCompleted;
}

void SendCacheLog::setParsingCompleted(const bool &completed)
{
    m_parsingCompleted = completed;
    emit parsingCompletedChanged();
}

bool SendCacheLog::favorited() const
{
    return m_favorited;
}

void SendCacheLog::setFavorited(const bool &favorite)
{
    m_favorited = favorite;
    emit favoritedChanged();
}


