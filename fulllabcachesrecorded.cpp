#include "fulllabcachesrecorded.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

FullLabCachesRecorded::FullLabCachesRecorded(Requestor *parent)
    : Requestor (parent)
{
}

FullLabCachesRecorded::~FullLabCachesRecorded()
{
}

void FullLabCachesRecorded::updateCachesSingleList(CachesSingleList *listCaches)
{
    m_listCaches = listCaches;
}

void FullLabCachesRecorded::sendRequest(QString token , QList<QString> geocodes , QList<bool> cachesLists , SQLiteStorage *sqliteStorage)
{
    m_tokenTemp = token;
    m_cachesLists = cachesLists;
    m_sqliteStorage = sqliteStorage;

    for(int i = 0; i < geocodes.length() ; ++i)
    {
        //Build url
        QString requestName = "adventures/" + geocodes[i] ;
        qDebug() << "URL:" << requestName ;
        // Inform QML we are loading
        setState("loading");        
        Requestor::sendGetRequest(requestName , token);
    }
}

void FullLabCachesRecorded::parseJson(const QJsonDocument &dataJsonDoc)
{
    QString geocode = dataJsonDoc["id"].toString();
    QString name;
    QString type = "labCache";
    QString size = "Virtuelle";
    double difficulty = 0;
    double terrain = 0;
    double lat;
    double lon;
    bool found;
    bool own;
    double ratingsAverage = 0;
    int ratingsTotalCount = 0;
    int stagesTotalCount = 0;
    QString imageUrl;

    QList<Cache*> caches = m_listCaches->getCaches(); // extract caches list information
    for(int i = 0; i < caches.length(); ++i)
    {
        if(caches[i]->geocode() == geocode)
        {            
            name = caches[i]->name();
            lat = caches[i]->lat();
            lon = caches[i]->lon();
            found = caches[i]->isCompleted();
            own = caches[i]->own();
            ratingsAverage = caches[i]->ratingsAverage();
            ratingsTotalCount = caches[i]->ratingsTotalCount();
            stagesTotalCount = caches[i]->stagesTotalCount();
            imageUrl = caches[i]->imageUrl();
            break;
        }
    }

    QJsonDocument jsonDoc = dataJsonDoc;
    QJsonObject cacheJson = jsonDoc.object();
    cacheJson.insert("ratingsAverage" , QJsonValue(ratingsAverage));
    cacheJson.insert("ratingsTotalCount" , QJsonValue(ratingsTotalCount));
    cacheJson.insert("stagesTotalCount" , QJsonValue(stagesTotalCount));
    cacheJson.insert("keyImageUrl" , QJsonValue(imageUrl));
    jsonDoc.setObject(cacheJson);

    m_sqliteStorage->updateFullCacheColumns("fullcache", geocode, name, type, size, difficulty, terrain, lat, lon, found, own,
                                            jsonDoc , QJsonDocument());
    m_sqliteStorage->updateListWithGeocode("cacheslists" , m_cachesLists , geocode , false);
    m_sqliteStorage->numberCachesInLists("cacheslists");
}






