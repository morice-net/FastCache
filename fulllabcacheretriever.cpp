#include "fulllabcacheretriever.h"
#include "fullcache.h"
#include "constants.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullLabCacheRetriever::FullLabCacheRetriever(Requestor *parent)
    : Requestor (parent)
{
}

FullLabCacheRetriever::~FullLabCacheRetriever()
{
}

void FullLabCacheRetriever::listCachesObject(CachesSingleList *listCaches)
{
    m_listCaches = listCaches;
}

void FullLabCacheRetriever::sendRequest(QString token)
{
    //Build url
    QString requestName = "adventures/" + m_fullCache->geocode();

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void FullLabCacheRetriever::updateFullCache(FullCache *fullCache)
{
    m_fullCache = fullCache;
}

void FullLabCacheRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    m_dataJson = dataJsonDoc;
    QJsonObject cacheJson;
    cacheJson = dataJsonDoc.object();
    qDebug() << "lab cache Oject:" << cacheJson;

    QList<Cache*> caches = m_listCaches->getCaches(); // extract cache list information
    for(int i = 0; i < caches.length(); ++i)
    {
        if(caches[i]->geocode() == m_fullCache->geocode())
        {
            m_fullCache->setName(caches[i]->name());
            m_fullCache->setLat(caches[i]->lat());
            m_fullCache->setLon(caches[i]->lon());
            m_fullCache->setRatingsAverage(caches[i]->ratingsAverage());
            m_fullCache->setRatingsTotalCount(caches[i]->ratingsTotalCount());
            m_fullCache->setStagesTotalCount(caches[i]->stagesTotalCount());
            m_fullCache->setIsCompleted(caches[i]->isCompleted());
            m_fullCache->setImageUrl(caches[i]->imageUrl());
            break;
        }
    }

    m_fullCache->setType("labCache");
    m_fullCache->setSize("Virtuelle");

    QJsonObject v1 ;

    //  description
    m_fullCache->setLongDescription(cacheJson["firebaseDynamicLink"].toString());

    // Waypoints
    QList<QString> listWptsDescription ;
    QList<QString> listWptsName ;
    QList<QString> listWptsIcon ;
    QList<double> listWptsLat ;
    QList<double> listWptsLon ;
    QList<QString> listWptsComment ;
    QJsonArray additionalWaypoints = cacheJson["additionalWaypoints"].toArray();

    listWptsDescription.clear();
    listWptsName.clear();
    listWptsIcon.clear();
    listWptsLat.clear();
    listWptsLon.clear();
    listWptsComment.clear();
    for (const QJsonValue &waypoint: qAsConst(additionalWaypoints))
    {
        listWptsDescription.append(waypoint["name"].toString());
        listWptsName.append(WPT_TYPE_MAP.key(waypoint["typeId"].toInt()));
        listWptsIcon.append(WPT_TYPE_ICON_MAP.key(waypoint["typeId"].toInt()));

        v1 = waypoint["coordinates"].toObject();
        if(v1["latitude"].isNull()) {
            listWptsLat.append(200) ;
        } else{
            listWptsLat.append(v1["latitude"].toDouble());
        }
        listWptsLon.append(v1["longitude"].toDouble());
        listWptsComment.append(waypoint["description"].toString());
    }
    m_fullCache->setWptsDescription(listWptsDescription);
    m_fullCache->setWptsName(listWptsName);
    m_fullCache->setWptsIcon(listWptsIcon);
    m_fullCache->setWptsLat(listWptsLat);
    m_fullCache->setWptsLon(listWptsLon);
    m_fullCache->setWptsComment(listWptsComment);

    emit m_fullCache->registeredChanged();
}







