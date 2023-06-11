#include "cachemaptiles.h"
#include "qdir.h"

CacheMapTiles::CacheMapTiles(QObject *parent)
    : QObject(parent)
{
    QDir dirCacheOsm(m_dirCacheOsm); // cache osm
    if (!dirCacheOsm.exists())
        dirCacheOsm.mkpath(".");

    QDir dirCacheCyclOsm(m_dirCacheCyclOsm); // cache cyclo osm
    if (!dirCacheCyclOsm.exists())
        dirCacheCyclOsm.mkpath(".");
}

CacheMapTiles::~CacheMapTiles()
{
}

/** Getters & Setters **/

QString CacheMapTiles:: dirCacheOsm() const
{
    return m_dirCacheOsm;
}

void CacheMapTiles::setDirCacheOsm(const QString &dir)
{
    m_dirCacheOsm = dir;
    emit dirCacheOsmChanged();
}

QString  CacheMapTiles::dirCacheCyclOsm() const
{
    return m_dirCacheCyclOsm;
}

void  CacheMapTiles::setDirCacheCyclOsm(const QString &dir)
{
    m_dirCacheCyclOsm = dir;
    emit dirCacheCyclOsmChanged();
}
