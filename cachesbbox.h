#ifndef CACHESBBOX_H
#define CACHESBBOX_H

#include <QObject>
#include <QQmlListProperty>

#include "requestor.h"

class Cache;

class CachesBBox : public Requestor
{    
    Q_OBJECT

    Q_PROPERTY(double latBottomRight READ latBottomRight WRITE setLatBottomRight NOTIFY latBottomRightChanged)
    Q_PROPERTY(double lonBottomRight READ lonBottomRight WRITE setLonBottomRight NOTIFY lonBottomRightChanged)
    Q_PROPERTY(double latTopLeft READ latTopLeft WRITE setLatTopLeft NOTIFY latTopLeftChanged)
    Q_PROPERTY(double lonTopLeft READ lonTopLeft WRITE setLonTopLeft NOTIFY lonTopLeftChanged)

    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)

public:
    explicit  CachesBBox(QObject *parent = 0);
    ~CachesBBox();

    Q_INVOKABLE virtual void sendRequest(QString token);
    Q_INVOKABLE   void updateFilterCaches(QList <int> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived , QString userName);

    QQmlListProperty<Cache> caches();

    double latBottomRight() const;
    void setLatBottomRight(double latBottomRight);

    double lonBottomRight() const;
    void setLonBottomRight(double lonBottomRight);

    double latTopLeft() const;
    void setLatTopLeft(double latTopLeft);

    double lonTopLeft() const;
    void setLonTopLeft(double lonTopLeft);

signals:
    void latBottomRightChanged();
    void lonBottomRightChanged();
    void latTopLeftChanged();
    void lonTopLeftChanged();
    void cachesChanged();

public slots:
    void onReplyFinished(QNetworkReply* reply) override;

private:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;
    int indexMoreCachesBBox;

    double m_latBottomRight;
    double m_lonBottomRight;
    double m_latTopLeft;
    double m_lonTopLeft;

    QString tokenTemp ;
    QString userName;

    QList<Cache*> m_caches;
    QList<int> filterTypes;
    QList<int> filterSizes;
    QList<double> filterDifficultyTerrain;

    bool filterExcludeFound;
    bool filterExcludeArchived;

    void   sendRequestMore(QString token);
};

#endif // CACHESBBOX_H
