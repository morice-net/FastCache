#ifndef CACHESNEAR_H
#define CACHESNEAR_H

#include <QObject>
#include <QQmlListProperty>

#include "requestor.h"

class Cache;

class CachesNear : public Requestor
{
    Q_OBJECT

    Q_PROPERTY(double latPoint READ latPoint WRITE setLatPoint NOTIFY latPointChanged)
    Q_PROPERTY(double lonPoint READ lonPoint WRITE setLonPoint NOTIFY lonPointChanged)
    Q_PROPERTY(double distance READ distance WRITE setDistance NOTIFY distanceChanged)


    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)

public:
    explicit  CachesNear(QObject *parent = 0);
    ~CachesNear();

    Q_INVOKABLE virtual void sendRequest(QString token);
    Q_INVOKABLE void sendRequestMore(QString token);
    Q_INVOKABLE   void updateFilterCaches(QList <int> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived , QString userName);

    QQmlListProperty<Cache> caches();

    double latPoint() const;
    void setLatPoint(double latPoint);

    double lonPoint() const;
    void setLonPoint(double lonPoint);

    double distance() const;
    void setDistance(double distance);


signals:
    void latPointChanged();
    void lonPointChanged();
    void distanceChanged();
    void cachesChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply) override;

private:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;
    int indexMoreCachesBBox;

    double m_latPoint;
    double m_lonPoint;
    double m_distance;

    QString tokenTemp ;
    QString userName;

    QList<Cache*> m_caches;
    QList<int> filterTypes;
    QList<int> filterSizes;
    QList<double> filterDifficultyTerrain;

    bool filterExcludeFound;
    bool filterExcludeArchived;

};

#endif // CACHESNEAR_H
