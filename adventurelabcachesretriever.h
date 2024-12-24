#ifndef ADVENTURELABCACHESRETRIEVER_H
#define ADVENTURELABCACHESRETRIEVER_H

#include "requestor.h"
#include "cachessinglelist.h"

#include <QNetworkReply>
#include <QGeoCoordinate>
#include <QtQml>

class Cache;

class AdventureLabCachesRetriever : public Requestor
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int indexMoreLabCaches READ indexMoreLabCaches WRITE setIndexMoreLabCaches NOTIFY indexMoreLabCachesChanged)
    Q_PROPERTY(int maxCaches READ maxCaches WRITE setMaxCaches NOTIFY maxCachesChanged)
    Q_PROPERTY(double latPoint READ latPoint WRITE setLatPoint NOTIFY latPointChanged)
    Q_PROPERTY(double lonPoint READ lonPoint WRITE setLonPoint NOTIFY lonPointChanged)
    Q_PROPERTY(double distance READ distance WRITE setDistance NOTIFY distanceChanged)
    Q_PROPERTY(bool excludeOwnedCompleted READ excludeOwnedCompleted WRITE setExcludeOwnedCompleted NOTIFY excludeOwnedCompletedChanged)    
    Q_PROPERTY(bool cachesActive READ cachesActive WRITE setCachesActive NOTIFY cachesActiveChanged)  // caches active or not

public:
    explicit  AdventureLabCachesRetriever(Requestor *parent = nullptr);
    ~AdventureLabCachesRetriever() override;

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE double distTo(double latPoint1 , double lonPoint1 , double latPoint2 , double lonPoint2);
    Q_INVOKABLE void listCachesObject(CachesSingleList *listCaches);

    void moreCaches();

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    int indexMoreLabCaches();
    void setIndexMoreLabCaches(int indexMoreCaches);

    int maxCaches();
    void setMaxCaches(int max);

    double latPoint() const;
    void setLatPoint(double latPoint);

    double lonPoint() const;
    void setLonPoint(double lonPoint);

    double distance() const;
    void setDistance(double distance);

    bool excludeOwnedCompleted() const;
    void setExcludeOwnedCompleted(bool exclude);

    bool cachesActive() const;
    void setCachesActive(bool active);

signals:
    void clearMapRequested();
    void indexMoreLabCachesChanged();
    void maxCachesChanged();
    void latPointChanged();
    void lonPointChanged();
    void excludeOwnedCompletedChanged();
    void distanceChanged();
    void cachesActiveChanged();

private:
    int m_indexMoreLabCaches;
    int m_maxCaches;
    QString m_tokenTemp;
    QString m_userName;
    double m_latPoint;
    double m_lonPoint;
    double  m_distance;
    bool m_excludeOwnedCompleted;
    bool m_cachesActive;

    CachesSingleList *m_listCaches;
};

#endif // ADVENTURELABCACHESRETRIEVER_H
