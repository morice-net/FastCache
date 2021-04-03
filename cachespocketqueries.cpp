#include "cachespocketqueries.h"
#include "cache.h"
#include "connector.h"
#include "constants.h"

#include <QJsonDocument>

CachesPocketqueries::CachesPocketqueries(CachesRetriever *parent)
    : CachesRetriever ( parent)
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
}

void CachesPocketqueries::parseJson(const QJsonDocument &dataJsonDoc)
{
    CachesRetriever::parseJson(dataJsonDoc);
    emit m_listCaches->cachesChanged();
}

void CachesPocketqueries::moreCaches()
{
    setIndexMoreCaches(m_indexMoreCaches + MAX_PER_PAGE);
    sendRequest( m_tokenTemp ,  m_referenceCode);
}







