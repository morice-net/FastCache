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

    if(dataJsonDoc["location"].isUndefined()) {  // dataJsonDoc comes from groundspeak database
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
                m_fullCache->setOwn(caches[i]->own());
                break;
            }
        }
    } else { // dataJsonDoc comes from internal database
        m_fullCache->setName(cacheJson["title"].toString());
        m_fullCache->setRatingsAverage(cacheJson["ratingsAverage"].toDouble());
        m_fullCache->setRatingsTotalCount(cacheJson["ratingsTotalCount"].toInt());
        m_fullCache->setStagesTotalCount(cacheJson["stagesTotalCount"].toInt());
        m_fullCache->setIsCompleted(cacheJson["isCompleted"].toBool());
        m_fullCache->setImageUrl(cacheJson["keyImageUrl"].toString());
        m_fullCache->setOwn(cacheJson["isOwned"].toBool());

        // coordinates
        QJsonObject loc = cacheJson["location"].toObject();
        m_fullCache->setLat(loc["latitude"].toDouble());
        m_fullCache->setLon(loc["longitude"].toDouble());
    }
    m_fullCache->setType("labCache");
    m_fullCache->setSize("Virtuelle");
    m_fullCache->setIsCorrectedCoordinates(false);
    m_fullCache->setToDoLog(false);
    m_fullCache->setRegistered(m_fullCache->checkRegistered());

    // adventure type, "Nonsequential" for non sequential lab cache
    m_fullCache->setAdventureType(cacheJson["adventureType"].toString());

    //  description
    m_fullCache->setLongDescriptionIsHtml(false);
    m_fullCache->setLongDescription(cacheJson["firebaseDynamicLink"].toString());

    // stages of lab cache
    QList<QString> listWptsDescription ;
    QList<QString> listWptsName ;
    QList<QString> listWptsIcon ;
    QList<double> listWptsLat ;
    QList<double> listWptsLon ;
    QList<QString> listWptsComment ;
    QList<bool> listWptsIsComplete ;
    listWptsDescription.clear();
    listWptsName.clear();
    listWptsIcon.clear();
    listWptsLat.clear();
    listWptsLon.clear();
    listWptsComment.clear();
    listWptsIsComplete .clear();

    QList<QString> listImagesName ;
    QList<QString> listImagesUrl ;
    listImagesName .clear();
    listImagesUrl.clear();

    QJsonArray stages = cacheJson["stages"].toArray();

    listImagesName .append(m_fullCache->name());
    listImagesUrl.append(m_fullCache->imageUrl());

    for (const QJsonValue &stage: qAsConst(stages))
    {
        listWptsDescription.append(stage["title"].toString());
        listWptsComment.append(stage["description"].toString());
        listWptsIsComplete.append(stage["isComplete"].toBool());
        listWptsName.append(WPT_TYPE_MAP.key(219));
        listWptsIcon.append(WPT_TYPE_ICON_MAP.key(219));

        listImagesName .append(stage["title"].toString());
        listImagesUrl.append(stage["stageImageUrl"].toString());

        qDebug() << "*** imagesName**\n" <<listImagesName ;
        qDebug() << "*** imagesUrl**\n" <<listImagesUrl ;

        QJsonObject v1 ;
        v1 = stage["location"].toObject();
        listWptsLat.append(v1["latitude"].toDouble());
        listWptsLon.append(v1["longitude"].toDouble());

        m_fullCache->setWptsDescription(listWptsDescription);
        m_fullCache->setWptsName(listWptsName);
        m_fullCache->setWptsIcon(listWptsIcon);
        m_fullCache->setWptsLat(listWptsLat);
        m_fullCache->setWptsLon(listWptsLon);
        m_fullCache->setWptsComment(listWptsComment);
        m_fullCache->setImagesName(listImagesName);
        m_fullCache->setImagesUrl(listImagesUrl);
        m_fullCache->setListStagesCount(stages.size());
        m_fullCache->setWptsIsComplete(listWptsIsComplete);
    }
}







