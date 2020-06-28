#include "cachesrecorded.h"
#include "cache.h"
#include "constants.h"
#include <QJsonObject>
#include <QSqlQuery>
#include <QSqlError>

CachesRecorded::CachesRecorded(CachesRetriever *parent)
    : CachesRetriever(parent)
{
}

CachesRecorded::~CachesRecorded()
{
}

void CachesRecorded::parseRecordedJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject cacheJson = dataJsonDoc.object();
    qDebug() << "cacheOject:" << cacheJson;
    Cache *cache ;
    cache = new Cache();

    cache->setGeocode(cacheJson["referenceCode"].toString());
    cache->setRegistered(cache->checkRegistered());

    if(cacheJson["status"].toString() == "Unpublished"){
        cache->setArchived(false);
        cache->setDisabled(false);
    } else if(cacheJson["status"].toString() == "Active"){
        cache->setArchived(false);
        cache->setDisabled(false);
    } else if(cacheJson["status"].toString() == "Disabled"){
        cache->setArchived(false);
        cache->setDisabled(true);
    } else if(cacheJson["status"].toString() == "Locked"){
        cache->setArchived(false);
        cache->setDisabled(false);
    } else if(cacheJson["status"].toString() == "Archived"){
        cache->setArchived(true);
        cache->setDisabled(false);
    }
    cache->setOwner(cacheJson["ownerAlias"].toString());
    cache->setDate(cacheJson["placedDate"].toString());

    QJsonObject v1 = cacheJson["geocacheType"].toObject();
    cache->setType(CACHE_TYPE_MAP.key(v1["id"].toInt()));
    cache->setTypeIndex(CACHE_TYPE_INDEX_MAP.key(v1["id"].toInt()).toInt());

    v1 = cacheJson["geocacheSize"].toObject();
    cache->setSize(CACHE_SIZE_MAP.key(v1["id"].toInt()));
    cache->setSizeIndex(CACHE_SIZE_INDEX_MAP.key(v1["id"].toInt()).toInt());

    cache->setDifficulty(cacheJson["difficulty"].toDouble());
    cache->setFavoritePoints(cacheJson["favoritePoints"].toInt());

    QString name(cacheJson["name"].toString());
    cache->setName(name);
    cache->setTrackableCount(cacheJson["trackableCount"].toInt());

    // coordinates
    v1 = cacheJson["userData"].toObject();
    if(v1["correctedCoordinates"].isNull()){
        v1 = cacheJson["postedCoordinates"].toObject();
        cache->setLat(v1["latitude"].toDouble());
        cache->setLon(v1["longitude"].toDouble());
    }  else {
        QJsonObject  v2 = v1["correctedCoordinates"].toObject();
        cache->setLat(v2["latitude"].toDouble());
        cache->setLon(v2["longitude"].toDouble());
    }

    //found
    v1 = cacheJson["userData"].toObject();
    if(v1["foundDate"].isNull()){
        cache->setFound(false);
    } else {
        cache->setFound(true);
    }
    cache->setTerrain(cacheJson["terrain"].toDouble());
    m_caches.append(cache);
    emit cachesChanged();
}

void CachesRecorded::emptyList()
{
    m_caches.clear();
 //   emit cachesChanged();
}

void CachesRecorded::moreCaches()
{
}

void CachesRecorded::addGetRequestParameters(QString &parameters)
{
}

bool CachesRecorded::updateMapCachesRecorded()
{
    QString selectQueryText = "SELECT cacheslists.list , fullcache.json FROM cacheslists , fullcache"
                              " WHERE cacheslists.code = fullcache.id ORDER BY cacheslists.list";
    qDebug() << "Query:" << selectQueryText;
    QSqlQuery select;
    if(!select.exec(selectQueryText))
    {
        qDebug() << "Error ? " << select.lastError().text();
        return false;
    }
    qDebug() << "Request success";
    m_mapCachesRecorded.clear();
    CachesRecorded::emptyList();
    int a = 0;
    QString jsonString;
    QByteArray jsonByteArray;
    QJsonDocument json = QJsonDocument();
    while(select.next()) {
        jsonString = select.value(1).toString();
        jsonByteArray = jsonString.toUtf8();
        json = QJsonDocument::fromJson(jsonByteArray);
        if(m_caches.length() == 0) {
            a = select.value(0).toInt() ;
            CachesRecorded::parseRecordedJson(json);
        } else {
            if(a == select.value(0).toInt()) {
                CachesRecorded::parseRecordedJson(json);
            } else {
                m_mapCachesRecorded.insert(a , m_caches);
                a = select.value(0).toInt();
                CachesRecorded::emptyList();
                CachesRecorded::parseRecordedJson(json);
            }
        }
    }
    m_mapCachesRecorded.insert(a , m_caches);
    return true;
}

void CachesRecorded::updateListCachesRecorded(int list)
{    
    m_caches = m_mapCachesRecorded[list];
    emit cachesChanged();
}
