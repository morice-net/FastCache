#include "cachespocketqueries.h"
#include "cache.h"
#include "connector.h"
#include "constants.h"

#include <QJsonDocument>

CachesPocketqueries::CachesPocketqueries(CachesRetriever *parent)
    : CachesRetriever ( parent)
    , m_parsingCompleted(false)
{
}

CachesPocketqueries::~CachesPocketqueries()
{
}

void CachesPocketqueries::sendRequest(QString token , QString referenceCode)
{
    m_referenceCode = referenceCode;
    m_tokenTemp = token;
    if(m_indexMoreCaches == 0) {
        emit clearMapRequested();
        m_listCaches->deleteAll();
        m_listCaches->clear();
    }

    //Build url
    QString requestName = "lists/" + referenceCode + "/geocaches?";
    requestName.append("lite=true");

    //Pagination
    requestName.append("&skip=" + QString::number(m_indexMoreCaches) + "&take=" + QString::number(MAX_PER_PAGE));

    // Fields
    requestName.append("&fields=referenceCode,name,difficulty,terrain,favoritePoints,trackableCount,postedCoordinates,ownerAlias,placedDate,geocacheType,"
                       "geocacheSize,location,status,userData");

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");
    Requestor::sendGetRequest(requestName , token);
}

void CachesPocketqueries::addGetRequestParameters(QString &parameters)
{
    (void) parameters;
}

void CachesPocketqueries::parseJson(const QJsonDocument &dataJsonDoc)
{
    setParsingCompleted(false);
    CachesRetriever::parseJson(dataJsonDoc);
    emit m_listCaches->cachesChanged();
    setParsingCompleted(true);
}

void CachesPocketqueries::moreCaches()
{
    setIndexMoreCaches(m_indexMoreCaches + MAX_PER_PAGE);
    sendRequest( m_tokenTemp ,  m_referenceCode);
}

bool CachesPocketqueries::parsingCompleted()
{
    return m_parsingCompleted;
}

void CachesPocketqueries::setParsingCompleted(bool completed)
{
    m_parsingCompleted = completed;
    emit parsingCompletedChanged();
}







