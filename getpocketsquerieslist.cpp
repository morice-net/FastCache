#include "getpocketsquerieslist.h"

#include <QJsonArray>

GetPocketsqueriesList::GetPocketsqueriesList(Requestor *parent)
    : Requestor (parent)
    , m_referenceCodes()
    , m_names()
    , m_descriptions()
    , m_dates()
    , m_counts()
    , m_findCounts()
{
}

GetPocketsqueriesList:: ~GetPocketsqueriesList()
{
}

void GetPocketsqueriesList::sendRequest(QString token)
{
    //Build url
    QString requestName = "users/me/lists";
    requestName.append("?fields=referenceCode,name,description,lastUpdatedDateUtc,count,findCount");
    requestName.append("&take=50");

    // load pockets queries
    requestName.append("&types=pq");

    // Inform QML we are loading
    setState("loading");
    Requestor::sendGetRequest(requestName,token);
}

void GetPocketsqueriesList::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonArray  pocketsJson = dataJsonDoc.array();
    qDebug() << "*** Pockets Queries**\n" << pocketsJson;

    if (pocketsJson.size() == 0) {
        emit requestReady();
        return ;
    }

    foreach ( const QJsonValue & pocketJson, pocketsJson)
    {
        m_referenceCodes.append(pocketJson["referenceCode"].toString());
        m_names.append(pocketJson["name"].toString());

        if(pocketJson["description"].isNull()) {
            m_descriptions.append("");
        } else {
            m_descriptions.append(pocketJson["description"].toString());
        }

        m_dates.append(pocketJson["lastUpdatedDateUtc"].toString());
        m_counts.append(pocketJson["count"].toInt());
        m_findCounts.append(pocketJson["findCount"].toInt());
    }

    emit referenceCodesChanged();
    emit namesChanged();
    emit descriptionsChanged();
    emit datesChanged();
    emit countsChanged();
    emit findCountsChanged();

    qDebug() << "*** referenceCodes**\n" << m_referenceCodes;
    qDebug() << "*** names**\n" << m_names;
    qDebug() << "*** descriptions**\n" << m_descriptions;
    qDebug() << "*** dates**\n" << m_dates;
    qDebug() << "*** counts**\n" << m_counts;
    qDebug() << "*** findCounts**\n" << m_findCounts;

    // request success
    emit requestReady();
    return ;
}

QList<QString> GetPocketsqueriesList::referenceCodes() const
{
    return m_referenceCodes;
}

void GetPocketsqueriesList::setReferenceCodes(const QList<QString> &codes)
{
    m_referenceCodes = codes;
    emit referenceCodesChanged();
}

QList<QString> GetPocketsqueriesList::names() const
{
    return m_names;
}

void GetPocketsqueriesList::setNames(const QList<QString> &names)
{
    m_names = names;
    emit namesChanged();
}

QList<QString> GetPocketsqueriesList::descriptions() const
{
    return m_descriptions;
}

void GetPocketsqueriesList::setDescriptions(const QList<QString> &descriptions)
{
    m_descriptions = descriptions;
    emit descriptionsChanged();
}

QList<QString> GetPocketsqueriesList::dates() const
{
    return m_dates;
}

void GetPocketsqueriesList::setDates(const QList<QString> &dates)
{
    m_dates = dates;
    emit datesChanged();
}

QList<int> GetPocketsqueriesList::counts() const
{
    return m_counts;
}

void GetPocketsqueriesList::setCounts(const QList<int> &counts)
{
    m_counts = counts;
    emit countsChanged();
}

QList<int> GetPocketsqueriesList::findCounts() const
{
    return m_findCounts;
}

void GetPocketsqueriesList::setFindCounts(const QList<int> &findCounts)
{
    m_findCounts = findCounts;
    emit findCountsChanged();
}

