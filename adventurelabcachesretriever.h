#ifndef ADVENTURELABCACHESRETRIEVER_H
#define ADVENTURELABCACHESRETRIEVER_H

#include "requestor.h"
#include "cachessinglelist.h"

class Cache;

#include <QNetworkReply>
#include <QGeoCoordinate>

class AdventureLabCachesRetriever : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(int indexMoreCaches READ indexMoreCaches WRITE setIndexMoreCaches NOTIFY indexMoreCachesChanged)
    Q_PROPERTY(int maxCaches READ maxCaches WRITE setMaxCaches NOTIFY maxCachesChanged)
    Q_PROPERTY(double latPoint READ latPoint WRITE setLatPoint NOTIFY latPointChanged)
    Q_PROPERTY(double lonPoint READ lonPoint WRITE setLonPoint NOTIFY lonPointChanged)
    Q_PROPERTY(double distance READ distance WRITE setDistance NOTIFY distanceChanged)
    Q_PROPERTY(bool excludeOwnedCompleted READ excludeOwnedCompleted WRITE setExcludeOwnedCompleted NOTIFY excludeOwnedCompletedChanged)

public:
    explicit  AdventureLabCachesRetriever(Requestor *parent = nullptr);
    ~AdventureLabCachesRetriever() override;

    Q_INVOKABLE void sendRequest(QString token);
    Q_INVOKABLE double distTo(double latPoint1 , double lonPoint1 , double latPoint2 , double lonPoint2);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

    int indexMoreCaches();
    void setIndexMoreCaches(int indexMoreCaches);

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


signals:
    void clearMapRequested();
    void indexMoreCachesChanged();
    void maxCachesChanged();
    void latPointChanged();
    void lonPointChanged();
    void excludeOwnedCompletedChanged();
    void distanceChanged();

private:
    int m_indexMoreCaches;
    int m_maxCaches;
    QString m_tokenTemp ;
    QString m_userName;
    double m_latPoint;
    double m_lonPoint;
    double  m_distance;
    bool m_excludeOwnedCompleted;


    CachesSingleList *m_listLabCaches;
};

#endif // ADVENTURELABCACHESRETRIEVER_H
