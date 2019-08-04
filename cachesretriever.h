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

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE void updateFilterCaches(QList <bool> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived ,QList <QString > keyWordDiscoverOwner ,QString userName);

    QQmlListProperty<Cache> caches();
    void parseJson(const QJsonDocument &dataJsonDoc) override;

    virtual void moreCaches() = 0;

protected:
    virtual void addGetRequestParameters(QString& parameters) = 0;

signals:    
    void cachesChanged();

public:
    // Type of caches facilitator
    const QMap<QString, int> CACHE_TYPE_MAP = {{"Traditionnelle",2},
                                               {"Multiple", 3},
                                               {"Virtuelle", 4},
                                               {"Boîte aux lettres hybride", 5},
                                               {"Evènement", 6},
                                               {"Mystère", 8},
                                               {"Project ape cache", 9},
                                               {"Webcam", 11},
                                               {"Locationless (Reverse) Cache", 12},
                                               {"Cito", 13},
                                               {"Earthcache", 137},
                                               {"Méga-Evènement", 453},
                                               {"GPS Adventures Exhibit", 1304},
                                               {"Wherigo", 1858 },
                                               {"Community Celebration Event", 3653},
                                               {"Siège de Groundspeak", 3773},
                                               {"Geocaching HQ Celebration", 3774 },
                                               {"fête locale Groundspeak", 4738},
                                               {"Giga-Evènement", 7005}, };

    // Type of caches (index in cacheList.png)
    const QMap<QString, int> CACHE_TYPE_INDEX_MAP = {{"0",2},
                                                     {"2", 3},
                                                     {"10", 4},
                                                     {"8", 5},
                                                     {"6", 6},
                                                     {"1", 8},
                                                     {"5", 9},
                                                     {"11", 11},
                                                     {"14", 12},
                                                     {"4", 13},
                                                     {"3", 137},
                                                     {"9", 453},
                                                     {"6", 1304},
                                                     {"12", 1858 },
                                                     {"6", 3653},
                                                     {"13", 3773},
                                                     {"14", 3774 },
                                                     {"6", 4738},
                                                     {"7", 7005}, };

protected:
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
