#include "sendedituserlog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendEditUserLog::SendEditUserLog(Requestor *parent)
    : Requestor (parent)
    ,  m_count()
    ,  m_codeLog("")
    ,  m_logTypeResponse()
    ,  m_parsingCompleted(false)
    ,  m_favorited(false)
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
    requestName.append("?fields=referenceCode,owner,geocacheLogType,usedFavoritePoint");
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

int SendEditUserLog::founds() const
{
    return m_count;
}

void SendEditUserLog::setFounds(const int &count)
{
    m_count = count;
    emit foundsChanged();
}

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
