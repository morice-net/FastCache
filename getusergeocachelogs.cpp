#include "getusergeocachelogs.h"

#include <QJsonArray>

GetUserGeocacheLogs::GetUserGeocacheLogs(Requestor *parent)
    : Requestor (parent)
    , m_referenceCodes()
    , m_logs()
    , m_loggedDates()
    , m_logsType()
    , m_geocode()
{
}

GetUserGeocacheLogs:: ~GetUserGeocacheLogs()
{
}

void GetUserGeocacheLogs::sendRequest(QString token , QString geocode)
{
}

void GetUserGeocacheLogs::parseJson(const QJsonDocument &dataJsonDoc)
{
}

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

QString GetUserGeocacheLogs::geocode() const
{
    return m_geocode;
}

void GetUserGeocacheLogs::setGeocode(const QString &code)
{
    m_geocode = code;
    emit geocodeChanged();
}
