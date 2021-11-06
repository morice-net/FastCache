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
    , m_logsTypeId()
    , m_imagesCount()
{
}

GetUserGeocacheLogs:: ~GetUserGeocacheLogs()
{
}

void GetUserGeocacheLogs::sendRequest(QString token , QString geocode)
{
    // empty lists
    setReferenceCodes(QStringList());
    setLogs(QStringList());
    setLoggedDates(QStringList());
    setLogsType(QStringList());
    setLogsTypeId(QList<int>());
    setImagesCount(QList<int>());

    //Build url
    QString requestName = "users/me/geocachelogs";
    requestName.append("?fields=referenceCode,text,loggedDate,geocacheLogType,geocacheCode,imageCount");
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
        m_imagesCount.append(userLogJson["imageCount"].toInt());

        type = userLogJson["geocacheLogType"].toObject();
        m_logsTypeId.append(type["id"].toInt());
        m_logsType.append(LOG_TYPE_CACHE_MAP.key(type["id"].toInt()));
    }

    emit referenceCodesChanged();
    emit logsChanged();
    emit loggedDatesChanged();
    emit logsTypeChanged();
    emit logsTypeIdChanged();
    emit imagesCountChanged();

    qDebug() << "*** referenceCodes**\n" << m_referenceCodes;
    qDebug() << "*** logs**\n" << m_logs;
    qDebug() << "*** dates**\n" << m_loggedDates;
    qDebug() << "*** types**\n" << m_logsType;
    qDebug() << "*** typesId**\n" << m_logsTypeId;
    qDebug() << "*** images counts**\n" << m_imagesCount;

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

QList<QString> GetUserGeocacheLogs::logsType() const
{
    return m_logsType;
}

void GetUserGeocacheLogs::setLogsType(const QList<QString> &types)
{
    m_logsType = types;
    emit logsTypeChanged();
}

QList<int> GetUserGeocacheLogs::logsTypeId() const
{
    return m_logsTypeId;
}

void GetUserGeocacheLogs::setLogsTypeId(const QList<int> &typesId)
{
    m_logsTypeId = typesId;
    emit logsTypeIdChanged();
}

QList<int> GetUserGeocacheLogs::imagesCount() const
{
    return m_imagesCount;
}

void GetUserGeocacheLogs::setImagesCount(const QList<int> &images)
{
    m_imagesCount = images;
    emit imagesCountChanged();
}
