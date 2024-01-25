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

void FullLabCacheRetriever::writeToStorage(SQLiteStorage *sqliteStorage)
{
    QString descriptionTagBegin = "<br />";
    QString descriptionTagEnd = "<br />";
    QString ownerTagBegin = "<br /><center><strong>";
    QString ownerTagEnd = "</strong></center>";

    int  indexBegin = m_fullCache->longDescription().indexOf(descriptionTagBegin) + descriptionTagBegin.size();
    int  indexEnd = m_fullCache->longDescription().indexOf(descriptionTagEnd , indexBegin);
    QString description = m_fullCache->longDescription().sliced(indexBegin , indexEnd - indexBegin);

    indexBegin = m_fullCache->longDescription().indexOf(ownerTagBegin) + ownerTagBegin.size();
    indexEnd = m_fullCache->longDescription().indexOf(ownerTagEnd , indexBegin);
    QString owner = m_fullCache->longDescription().sliced(indexBegin , indexEnd - indexBegin);

    QJsonObject cacheJson = m_dataJson.object();
    cacheJson.insert("title" , QJsonValue(m_fullCache->name()));
    cacheJson.insert("isOwned" , QJsonValue(m_fullCache->own()));
    cacheJson.insert("isCompleted" , QJsonValue(m_fullCache->found()));
    cacheJson.insert("ratingsAverage" , QJsonValue(m_fullCache->ratingsAverage()));
    cacheJson.insert("ratingsTotalCount" , QJsonValue(m_fullCache->ratingsTotalCount()));
    cacheJson.insert("stagesTotalCount" , QJsonValue(m_fullCache->stagesTotalCount()));
    cacheJson.insert("description" , QJsonValue(description));
    cacheJson.insert("owner" , QJsonValue(owner));
    cacheJson.insert("keyImageUrl" , QJsonValue(m_fullCache->imageUrl()));

    QJsonObject location = cacheJson["location"].toObject();
    location.insert("latitude" , QJsonValue(m_fullCache->lat()));
    location.insert("longitude" , QJsonValue(m_fullCache->lon()));
    cacheJson.insert("location" , QJsonValue::fromVariant(location));

    m_dataJson.setObject(cacheJson);

    // Save in database and download images of cache recorded
    sqliteStorage->updateFullCacheColumns("fullcache", m_fullCache->geocode(), m_fullCache->name(), m_fullCache->type(), m_fullCache->size(),
                                          m_fullCache->difficulty(), m_fullCache->terrain(), m_fullCache->lat(), m_fullCache->lon(), m_fullCache->found()
                                          , m_fullCache->own(), m_replaceImageInText->replaceUrlImageToPathLabCache(m_fullCache->geocode(), m_dataJson ,true) ,
                                          QJsonDocument());
}

void FullLabCacheRetriever::deleteToStorage(SQLiteStorage *sqliteStorage)
{
    sqliteStorage->deleteObject("fullcache", m_fullCache->geocode());
    // delete dir of recorded cache images
    m_replaceImageInText->removeDir(m_fullCache->geocode());
}

void FullLabCacheRetriever::descriptionLabCache(QString url, QString imageUrl, QString name)
{
    const auto manager = new QNetworkAccessManager(this);
    QObject::connect(this, &FullLabCacheRetriever::descriptionChanged, this, &FullLabCacheRetriever::setDescription);
    connect(manager, &QNetworkAccessManager::finished,
            this , [imageUrl, name, this](auto reply) {
                QString descriptionTagBegin = "<meta property=\"og:description\" content=\"";
                QString descriptionTagEnd = "\" />";
                QString ownerTagBegin = "<h6 class=\"pt-3\">";
                QString ownerTagEnd = "</h6>";

                QString read = reply->readAll();
                int  indexBegin = read.indexOf(descriptionTagBegin) + descriptionTagBegin.size();
                int  indexEnd = read.indexOf(descriptionTagEnd , indexBegin);
                QString description = read.sliced(indexBegin , indexEnd - indexBegin);

                indexBegin = read.indexOf(ownerTagBegin) + ownerTagBegin.size();
                indexEnd = read.indexOf(ownerTagEnd , indexBegin);
                QString owner = read.sliced(indexBegin , indexEnd - indexBegin);

                QString longDescription = "<p align=\"center\"><img src= " + imageUrl + " width=\"250\"  />" +
                                          "<center><strong>"  + name + "</strong></center><br />" +
                                          description +
                                          "<br /><center><strong>" + owner + "</strong></center>";
                emit descriptionChanged(longDescription);
            });
    manager->get(QNetworkRequest({ url }));
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

void FullLabCacheRetriever::updateReplaceImageInText(ReplaceImageInText *replace)
{
    m_replaceImageInText = replace;
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
                m_fullCache->setShortDescription(cacheJson["firebaseDynamicLink"].toString());

                descriptionLabCache(cacheJson["firebaseDynamicLink"].toString(), m_fullCache->imageUrl() ,  m_fullCache->name());
                break;
            }
        }
    } else { // dataJsonDoc comes from internal database
        // coordinates
        QJsonObject loc = cacheJson["location"].toObject();
        m_fullCache->setLat(loc["latitude"].toDouble());
        m_fullCache->setLon(loc["longitude"].toDouble());

        m_fullCache->setName(cacheJson["title"].toString());
        m_fullCache->setRatingsAverage(cacheJson["ratingsAverage"].toDouble());
        m_fullCache->setRatingsTotalCount(cacheJson["ratingsTotalCount"].toInt());
        m_fullCache->setStagesTotalCount(cacheJson["stagesTotalCount"].toInt());
        m_fullCache->setIsCompleted(cacheJson["isCompleted"].toBool());
        m_fullCache->setImageUrl(cacheJson["keyImageUrl"].toString());
        m_fullCache->setOwn(cacheJson["isOwned"].toBool());
        m_fullCache->setOwner(cacheJson["owner"].toString());

        QString description = "<p align=\"center\"><img src= " + m_fullCache->imageUrl() + " width=\"250\"  />" +
                              "<center><strong>"  + m_fullCache->name() + "</strong></center><br />" +
                              cacheJson["description"].toString() +
                              "<br /><center><strong>" + m_fullCache->owner() + "</strong></center>";
        m_fullCache->setLongDescription(description);
        m_fullCache->setShortDescription(cacheJson["firebaseDynamicLink"].toString());
    }

    // adventure type, "Nonsequential" for non sequential lab cache
    m_fullCache->setAdventureType(cacheJson["adventureType"].toString());

    m_fullCache->setLongDescriptionIsHtml(false);
    m_fullCache->setType("labCache");
    m_fullCache->setSize("Virtuelle");
    m_fullCache->setIsCorrectedCoordinates(false);
    m_fullCache->setToDoLog(false);
    m_fullCache->setRegistered(m_fullCache->checkRegistered());

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

    for (const QJsonValue &stage: std::as_const(stages))
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

void FullLabCacheRetriever::setDescription(QString value)
{
    m_fullCache->setLongDescription(value);
}





