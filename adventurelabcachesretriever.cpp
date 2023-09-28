#include "adventurelabcachesretriever.h"
#include "constants.h"
#include "cache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

AdventureLabCachesRetriever::AdventureLabCachesRetriever(Requestor *parent)
    : Requestor (parent)
    , m_indexMoreLabCaches(0)
    , m_maxCaches()
    , m_latPoint(0)
    , m_lonPoint(0)
    , m_distance(0)
    , m_excludeOwnedCompleted(false)
    , m_cachesActive(false)
{
}

AdventureLabCachesRetriever::~AdventureLabCachesRetriever()
{
}

void AdventureLabCachesRetriever::listCachesObject(CachesSingleList *listCaches)
{
    m_listCaches = listCaches;
}

void AdventureLabCachesRetriever::sendRequest(QString token)
{
    m_tokenTemp = token;

    //Build url
    QString requestName = "adventures/search?";

    // create Center , radius
    requestName.append("q=location:[" + QString::number(m_latPoint) + "," + QString::number(m_lonPoint) + "]%2Bradius:"+QString::number(m_distance)+"km");

    //Pagination
    requestName.append("&skip=" + QString::number(m_indexMoreLabCaches) + "&take=" + QString::number(MAX_PER_PAGE));

    // Fields
    requestName.append("&fields=id,keyImageUrl,title,location,ratingsAverage,ratingsTotalCount,stagesTotalCount,dynamicLink,isOwned,isCompleted");

    // Exclude owned,completed
    if (m_excludeOwnedCompleted == false) {
        requestName.append("&excludeOwned=false" );
        requestName.append("&excludeCompleted=false" );
    } else {
        requestName.append("&excludeOwned=true" );
        requestName.append("&excludeCompleted=true" );
    }

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
        setIndexMoreLabCaches(0);
        return ;
    }

    for(const QJsonValue &v : adventureLabCaches)
    {
        Cache *cache ;
        cache = new Cache();

        cache->setGeocode(v["id"].toString());
        cache->setOwn(v["isOwned"].toBool());
        cache->setName(v["title"].toString());
        cache->setRatingsAverage(v["ratingsAverage"].toInt());
        cache->setRatingsTotalCount(v["ratingsTotalCount"].toInt());
        cache->setStagesTotalCount(v["stagesTotalCount"].toInt());
        cache->setIsCompleted(v["isCompleted"].toBool());
        cache->setImageUrl(v["keyImageUrl"].toString());

        // coordinates
        QJsonObject v1 = v["location"].toObject();
        cache->setLat(v1["latitude"].toDouble());
        cache->setLon(v1["longitude"].toDouble());

        m_listCaches->append(*cache);
    }
    if (lengthCaches == MAX_PER_PAGE && m_listCaches->length() < m_maxCaches)
        moreCaches();
    else {
        setIndexMoreLabCaches(0);
    }

    emit m_listCaches->cachesChanged();
}

void AdventureLabCachesRetriever::moreCaches()
{
    setIndexMoreLabCaches(m_indexMoreLabCaches + MAX_PER_PAGE);
    if(m_cachesActive)
        sendRequest(m_tokenTemp);
}

double AdventureLabCachesRetriever::distTo(double latPoint1 , double lonPoint1 , double latPoint2 , double lonPoint2)
{
    QGeoCoordinate point1;
    point1.setLatitude(latPoint1);
    point1.setLongitude(lonPoint1);
    QGeoCoordinate point2;
    point2.setLatitude(latPoint2);
    point2.setLongitude(lonPoint2);
    return (point1.distanceTo(point2)) / 1000; // distance in km
}

/** Getters & Setters **/

int AdventureLabCachesRetriever::indexMoreLabCaches()
{
    return m_indexMoreLabCaches;
}

void  AdventureLabCachesRetriever::setIndexMoreLabCaches(int indexMoreCaches)
{
    m_indexMoreLabCaches = indexMoreCaches;
    emit indexMoreLabCachesChanged();
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

double AdventureLabCachesRetriever::distance() const
{
    return m_distance;
}

void AdventureLabCachesRetriever::setDistance(double distance)
{
    m_distance = distance;
    emit distanceChanged();
}

bool AdventureLabCachesRetriever::excludeOwnedCompleted() const
{
    return m_excludeOwnedCompleted;
}

void AdventureLabCachesRetriever::setExcludeOwnedCompleted(bool exclude)
{
    m_excludeOwnedCompleted = exclude;
    emit excludeOwnedCompletedChanged();
}

bool AdventureLabCachesRetriever::cachesActive() const
{
    return m_cachesActive;
}

void AdventureLabCachesRetriever::setCachesActive(bool active)
{
    m_cachesActive = active;
    emit cachesActiveChanged();
}





