#include "fullcacheretriever.h"
#include "fullcache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullCacheRetriever::FullCacheRetriever(Requestor *parent)
    : Requestor (parent)
{
}

FullCacheRetriever::~FullCacheRetriever()
{
}

void FullCacheRetriever::sendRequest(QString token)
{

    //Build url
    QString requestName = "geocaches/" ;
    requestName.append( "GC285PA?");
    requestName.append("lite=false");

    // Fields
    requestName.append("&fields=referenceCode,name,difficulty,terrain,favoritePoints,trackableCount,postedCoordinates,ownerAlias,placedDate,geocacheType,"
                       "geocacheSize,location,status,userData,shortDescription,longDescription,hints");
    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);

    qDebug() << "error:" << state() ;
}

void FullCacheRetriever::updateFullCache(FullCache *fullCache)
{
    m_fullCache = fullCache;
}

void FullCacheRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    if (dataJsonDoc.isNull()) {
        // Inform the QML that there is a loading error
        setState("error");
        return;
    }

    QJsonObject cacheJson = dataJsonDoc.object();
    qDebug() << "cacheOject:" << cacheJson;

    // Inform the QML that there is no loading error
    setState("noError");

    m_fullCache->setDifficulty(cacheJson["difficulty"].toDouble());
    qDebug() << "cacheOject:" << m_fullCache->difficulty() ;

    // request success
    emit requestReady();
}






