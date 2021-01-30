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

void CachesRecorded::createRecordedCaches(const QList<QString> &list)
{
    // list: (code,name,type,size,difficulty,terrain,lat,lon,found,own)
    qDebug() << "list" << list;
    Cache *cache ;
    cache = new Cache();
    cache->setGeocode(list[0]);
    cache->setRegistered(cache->checkRegistered());
    cache->setToDoLog(cache->checkToDoLog());
    cache->setName(list[1]);
    cache->setType(list[2]);
    cache->setTypeIndex(CACHE_TYPE_INDEX_MAP.key(CACHE_TYPE_MAP.value(list[2])).toInt());
    cache->setSize(list[3]);
    cache->setSizeIndex(CACHE_SIZE_INDEX_MAP.key(CACHE_SIZE_MAP.value(list[3])).toInt());
    cache->setDifficulty(list[4].toDouble());
    cache->setTerrain(list[5].toDouble());
    cache->setLat(list[6].toDouble());
    cache->setLon(list[7].toDouble());
    cache->setFound(QVariant(list[8]).toBool());
    cache->setOwn(QVariant(list[9]).toBool());

    m_listCaches->append(*cache);
}

void CachesRecorded::moreCaches()
{
}

void CachesRecorded::addGetRequestParameters(QString &parameters)
{
    Q_UNUSED(parameters)
}

bool CachesRecorded::updateMapCachesRecorded()
{
    QString selectQueryText = "SELECT cacheslists.list , fullcache.id, fullcache.name, fullcache.type, fullcache.size, fullcache.difficulty,"
                              " fullcache.terrain, fullcache.lat, fullcache.lon, fullcache.found, fullcache.own FROM cacheslists , fullcache"
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
    m_listCaches->deleteAll();
    m_listCaches->clear();
    int a = 0;
    QList<QString> list;
    while(select.next()) {
        list.clear();

        list.append(select.value(1).toString());  // geocode
        list.append(select.value(2).toString());  // name
        list.append(select.value(3).toString());  // type
        list.append(select.value(4).toString());  // size
        list.append(select.value(5).toString());  // difficulty
        list.append(select.value(6).toString());  // terrain
        list.append(select.value(7).toString());  // lat
        list.append(select.value(8).toString());  // lon
        list.append(select.value(9).toString());  // found
        list.append(select.value(10).toString()); // own

        if( m_listCaches->length() == 0) {
            a = select.value(0).toInt() ;
            CachesRecorded::createRecordedCaches(list);
        } else {
            if(a == select.value(0).toInt()) {
                CachesRecorded::createRecordedCaches(list);
            } else {
                m_mapCachesRecorded.insert(a , m_listCaches->getCaches());
                a = select.value(0).toInt();
                emit clearMapRequested();
                m_listCaches->clear();
                CachesRecorded::createRecordedCaches(list);
            }
        }
    }
    m_mapCachesRecorded.insert(a , m_listCaches->getCaches());
    emit clearMapRequested();
    emit m_listCaches->cachesChanged();
    return true;
}

void CachesRecorded::updateListCachesRecorded(int list)
{
    m_listCaches->clear();
    m_listCaches->setCaches(m_mapCachesRecorded[list]);
}
