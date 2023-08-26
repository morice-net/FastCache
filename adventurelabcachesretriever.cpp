#include "adventurelabcachesretriever.h"
#include "constants.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

AdventureLabCachesRetriever::AdventureLabCachesRetriever(Requestor *parent)
    : Requestor (parent)
    , m_indexMoreCaches(0)
    , m_maxCaches()
    , m_latPoint(0)
    , m_lonPoint(0)    
{
}

AdventureLabCachesRetriever::~AdventureLabCachesRetriever()
{
}

void AdventureLabCachesRetriever::sendRequest(QString token)
{
    m_tokenTemp = token;

    //Build url
    QString requestName = "adventures/search?";

    // create Center
    requestName.append("q=location:[" + QString::number(m_latPoint) + "," + QString::number(m_lonPoint) + "]");

    //Pagination
    requestName.append("&skip=" + QString::number(m_indexMoreCaches) + "&take=" + QString::number(MAX_PER_PAGE));

    // Fields
    requestName.append("&fields=id,keyImageUrl,title,location,ratingsAverage,ratingsTotalCount,stagesTotalCount,dynamicLink,isOwned,isCompleted");

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void AdventureLabCachesRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonArray adventureLabCaches = dataJsonDoc.array();
    qDebug() << "adventureLabCachesArray: " << adventureLabCaches ;

    int lengthCaches = adventureLabCaches.size();
    if (lengthCaches == 0) {
        setIndexMoreCaches(0);
        return ;
    }
}

/** Getters & Setters **/

int AdventureLabCachesRetriever::indexMoreCaches()
{
    return m_indexMoreCaches;
}

void  AdventureLabCachesRetriever::setIndexMoreCaches(int indexMoreCaches)
{
    m_indexMoreCaches = indexMoreCaches;
    emit indexMoreCachesChanged();
}

int  AdventureLabCachesRetriever::maxCaches()
{
    return m_maxCaches;
}

void  AdventureLabCachesRetriever::setMaxCaches(int max)
{
    m_maxCaches = max;
    emit maxCachesChanged();
}

double AdventureLabCachesRetriever::lonPoint() const
{
    return m_lonPoint;
}

void AdventureLabCachesRetriever::setLonPoint(double lonPoint)
{
    m_lonPoint = lonPoint;
    emit lonPointChanged();
}

double AdventureLabCachesRetriever::latPoint() const
{
    return m_latPoint;
}

void AdventureLabCachesRetriever::setLatPoint(double latPoint)
{
    m_latPoint = latPoint;
    emit latPointChanged();
}





