#include "cache.h"
#include "cachessinglelist.h"

CachesSingleList::CachesSingleList(QObject *parent)
    : QObject(parent)
    , m_caches(QList<Cache*>())
{
}

CachesSingleList::~CachesSingleList()
{
}

QQmlListProperty<Cache> CachesSingleList::caches()
{
    return QQmlListProperty<Cache>(this, &m_caches);
}

void  CachesSingleList::clear()
{
    m_caches.clear();
}

void  CachesSingleList::append(Cache &cache)
{
    m_caches.append(&cache);
}

void CachesSingleList::setCaches(const QList<Cache*> &caches)
{
    m_caches = caches;
    emit cachesChanged();
}

void  CachesSingleList::deleteAll()
{
    qDeleteAll(m_caches);
}







