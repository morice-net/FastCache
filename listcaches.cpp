#include "cache.h"
#include "listcaches.h"

ListCaches::ListCaches(QObject *parent)
    : QObject(parent)
    , m_caches(QList<Cache*>())
{
}

ListCaches::~ListCaches()
{
}

QQmlListProperty<Cache> ListCaches::caches()
{
    return QQmlListProperty<Cache>(this, &m_caches);
}









