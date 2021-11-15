#include "sendedituserlog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendEditUserLog::SendEditUserLog(Requestor *parent)
    : Requestor (parent)
    ,  m_codeLog("")
    ,  m_logTypeResponse()
    ,  m_parsingCompleted(false)
    ,  m_favorited(false)
{
}

SendEditUserLog::~SendEditUserLog()
{
}

// update log
void SendEditUserLog::sendRequest(QString token, QString referenceCode, QString geocode  , int logType , QString date , QString text , bool favorite)
{
    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode);
    requestName.append("?fields=referenceCode,owner,geocacheLogType,usedFavoritePoint");
    qDebug() << "*** request name**\n" << requestName;

    // create log
    QJsonObject log;
    log.insert("geocacheCode", QJsonValue(geocode));
    log.insert("loggedDate", QJsonValue(date));
    log.insert("text", QJsonValue(text));
    log.insert("usedFavoritePoint", QJsonValue(favorite));
    QJsonObject type;
    type.insert("id",logType);
    log.insert("geocacheLogType", type);

    QJsonDocument Doc(log);
    QByteArray data = Doc.toJson();

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPutRequest(requestName , data ,token);
}

// delete log
void SendEditUserLog::sendRequest(QString token, QString referenceCode)
{
    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode);
    qDebug() << "*** request name**\n" << requestName;

    // Inform QML we are loading
    setState("loading");
    Requestor::sendDeleteRequest(requestName,token);
}

void SendEditUserLog::parseJson(const QJsonDocument &dataJsonDoc)
{
    setParsingCompleted(false);

    QJsonObject logJson;
    QJsonObject finderJson;
    QJsonObject logTypeJson;

    logJson = dataJsonDoc.object();
    setCodeLog(logJson["referenceCode"].toString());
    setFavorited(logJson["usedFavoritePoint"].toBool());
    logTypeJson = logJson["geocacheLogType"].toObject();
    setLogTypeResponse(logTypeJson ["id"].toInt());

    qDebug() << "*** logResponse**\n" << logJson;
    setParsingCompleted(true);
    return ;
}

/** Getters & Setters **/

QString SendEditUserLog::codeLog() const
{
    return m_codeLog;
}

void SendEditUserLog::setCodeLog(const QString &code)
{
    m_codeLog = code;
    emit codeLogChanged();
}

int SendEditUserLog::logTypeResponse() const
{
    return m_logTypeResponse;
}

void SendEditUserLog::setLogTypeResponse(const int &type)
{
    m_logTypeResponse = type;
    emit logTypeResponseChanged();
}

bool SendEditUserLog::parsingCompleted() const
{
    return m_parsingCompleted;
}

void SendEditUserLog::setParsingCompleted(const bool &completed)
{
    m_parsingCompleted = completed;
    emit parsingCompletedChanged();
}

bool SendEditUserLog::favorited() const
{
    return m_favorited;
}

void SendEditUserLog::setFavorited(const bool &favorite)
{
    m_favorited = favorite;
    emit favoritedChanged();
}
