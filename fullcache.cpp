#include "fullcache.h"

#include <QTimer>

FullCache::FullCache(): m_state(), m_description()
{

}

void FullCache::loadCache(const QString &token, Cache *cache)
{
    setParent(cache);
    setState("loading");
    QTimer::singleShot(5000, this, SLOT(onReplyFinished()));
}

void FullCache::onReplyFinished()
{
    setDescription(name() + " - " + geocode());
    setState("loaded");
}

void FullCache::onReplyFinished(QNetworkReply *reply)
{

}

QString FullCache::description() const
{
    return m_description;
}

void FullCache::setDescription(const QString &description)
{
    m_description = description;
    emit descriptionChanged();
}


QString FullCache::state() const
{
    return m_state;
}

void FullCache::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}
