#ifndef CACHESRETRIEVER_H
#define CACHESRETRIEVER_H

#include "requestor.h"

#include <QNetworkReply>
#include <QQmlListProperty>

class Cache;

class CachesRetriever : public Requestor
{
    Q_OBJECT

    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)

public:
    explicit CachesRetriever(QObject *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token) override;
    Q_INVOKABLE void sendRequestMore(QString token);
    Q_INVOKABLE void updateFilterCaches(QList <int> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived ,QList <QString > keyWordDiscoverOwner ,QString userName);

    QQmlListProperty<Cache> caches();

protected:
    virtual bool parameterChecker() = 0;
    virtual void addSpecificParameters(QJsonObject& parameters) = 0;

signals:
    void cachesChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply) override;

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;
    int m_indexMoreCachesBBox;
    bool m_moreCachesBBox;

    QString m_tokenTemp ;
    QString m_userName;

    QList<Cache*> m_caches;
    QList<int> m_filterTypes;
    QList<int> m_filterSizes;
    QList<double> m_filterDifficultyTerrain;
    QList<QString> m_keyWordDiscoverOwner;

    bool m_filterExcludeFound;
    bool m_filterExcludeArchived;

};

#endif // CACHESRETRIEVER_H
