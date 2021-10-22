#include "getusergeocachelogs.h"
#include "constants.h"

#include <QJsonArray>
#include <QJsonObject>

GetUserGeocacheLogs::GetUserGeocacheLogs(Requestor *parent)
    : Requestor (parent)
    , m_referenceCodes()
    , m_logs()
    , m_loggedDates()
    , m_logsType()
    , m_geocodes()
{
}

GetUserGeocacheLogs:: ~GetUserGeocacheLogs()
{
}

void GetUserGeocacheLogs::sendRequest(QString token , QString geocode)
{
    m_referenceCodes.clear();
    m_logs.clear();
    m_loggedDates.clear();
    m_logsType.clear();
    m_geocodes.clear();

    //Build url
    QString requestName = "users/me/geocachelogs";
    requestName.append("?fields=referenceCode,text,loggedDate,geocacheLogType,geocacheLogType");
    requestName.append("&take=50");
    requestName.append("&geocacheCode=" + geocode);

    // Inform QML we are loading
    setState("loading");
    Requestor::sendGetRequest(requestName,token);
}

void GetUserGeocacheLogs::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonArray  userLogsJson = dataJsonDoc.array();
    qDebug() << "*** user Logs**\n" << userLogsJson;

    if (userLogsJson.size() == 0) {
        emit requestReady();
        return ;
    }

    QJsonObject type;
    foreach ( const QJsonValue & userLogJson, userLogsJson)
    {
        m_referenceCodes.append(userLogJson["referenceCode"].toString());
        m_logs.append(userLogJson["text"].toString());
        m_loggedDates.append(userLogJson["loggedDate"].toString());
        m_geocodes.append(userLogJson["geocacheCode"].toString());

        type = userLogJson["geocacheLogType"].toObject();
        m_logsType.append(type["id"].toInt());
    }

    emit referenceCodesChanged();
    emit logsChanged();
    emit loggedDatesChanged();
    emit geocodesChanged();
    emit logsTypeChanged();

    qDebug() << "*** referenceCodes**\n" << m_referenceCodes;
    qDebug() << "*** logs**\n" << m_logs;
    qDebug() << "*** dates**\n" << m_loggedDates;
    qDebug() << "*** types**\n" << m_logsType;
    qDebug() << "*** geocodes**\n" << m_geocodes;

    // request success
    emit requestReady();
    return ;
}

/** Getters & Setters **/

QList<QString> GetUserGeocacheLogs::referenceCodes() const
{
    return m_referenceCodes;
}

void GetUserGeocacheLogs::setReferenceCodes(const QList<QString> &codes)
{
    m_referenceCodes = codes;
    emit referenceCodesChanged();
}

QList<QString> GetUserGeocacheLogs::logs() const
{
    return m_logs;
}

void GetUserGeocacheLogs::setLogs(const QList<QString> &logs)
{
    m_logs = logs;
    emit logsChanged();
}

QList<QString> GetUserGeocacheLogs::loggedDates() const
{
    return m_loggedDates;
}

void GetUserGeocacheLogs::setLoggedDates(const QList<QString> &dates)
{
    m_loggedDates = dates;
    emit loggedDatesChanged();
}

QList<int> GetUserGeocacheLogs::logsType() const
{
    return m_logsType;
}

void GetUserGeocacheLogs::setLogsType(const QList<int> &types)
{
    m_logsType = types;
    emit logsTypeChanged();
}

QList<QString> GetUserGeocacheLogs::geocodes() const
{
    return m_geocodes;
}

void GetUserGeocacheLogs::setGeocodes(const QList<QString> &codes)
{
    m_geocodes = codes;
    emit geocodesChanged();
}
