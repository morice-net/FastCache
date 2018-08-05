#ifndef CACHESRETRIEVER_H
#define CACHESRETRIEVER_H

#include "requestor.h"

#include <QObject>
#include <QNetworkReply>
#include <QQmlListProperty>

class Cache;

class CachesRetriever : public Requestor
{
    Q_OBJECT

    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)
public:
    explicit CachesRetriever(QObject *parent = nullptr);

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void sendRequestMore(QString token);

    QQmlListProperty<Cache> caches();

protected:
    virtual bool parameterChecker() = 0;
    virtual void addSpecificParameters(QJsonObject parameters) = 0;

signals:
    void cachesChanged();

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;
    int indexMoreCachesBBox;

    QString tokenTemp ;
    QString userName;

    QList<Cache*> m_caches;
    QList<int> filterTypes;
    QList<int> filterSizes;
    QList<double> filterDifficultyTerrain;

    bool filterExcludeFound;
    bool filterExcludeArchived;

};

#endif // CACHESRETRIEVER_H
