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
    explicit  CachesRetriever(Requestor *parent = nullptr);
    ~CachesRetriever() override;

    Q_INVOKABLE void sendRequest(QString token) override ;
    Q_INVOKABLE void updateFilterCaches(QList <int> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived ,QList <QString > keyWordDiscoverOwner ,QString userName);

    QQmlListProperty<Cache> caches();
    void parseJson(const QJsonDocument &dataJsonDoc) override;

    virtual void moreCaches() = 0;

protected:
    virtual void addGetRequestParameters(QString& parameters) = 0;

signals:    
    void cachesChanged();

protected:
    const int MAX_PER_PAGE = 40;
    const int GEOCACHE_LOG_COUNT = 30;
    const int TRACKABLE_LOG_COUNT = 30;
    int m_indexMoreCaches;

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
