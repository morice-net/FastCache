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
{
}

SendEditUserLog::~SendEditUserLog()
{
}

// update log
void SendEditUserLog::sendRequest(QString token, QString referenceCode, QString geocode  , int logType , QString date , QString text)
{
    //Build url
    QString requestName = "geocachelogs/";
    requestName.append(referenceCode);
    requestName.append("?fields=referenceCode,owner,geocacheLogType");
    qDebug() << "*** request name**\n" << requestName;

    // create log
    QJsonObject log;
    log.insert("geocacheCode", QJsonValue(geocode));
    log.insert("loggedDate", QJsonValue(date));
    log.insert("text", QJsonValue(text));
    QJsonObject type;
    type.insert("id",logType);
    log.insert("geocacheLogType", type);
    qDebug() << "*** update log**\n" << log;

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




