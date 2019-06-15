#ifndef CACHESBBOX_H
#define CACHESBBOX_H

#include "requestor.h"
#include <QQmlListProperty>

class Cache;

class CachesBBox : public Requestor
{    
    Q_OBJECT

    Q_PROPERTY(double latBottomRight READ latBottomRight WRITE setLatBottomRight NOTIFY latBottomRightChanged)
    Q_PROPERTY(double lonBottomRight READ lonBottomRight WRITE setLonBottomRight NOTIFY lonBottomRightChanged)
    Q_PROPERTY(double latTopLeft READ latTopLeft WRITE setLatTopLeft NOTIFY latTopLeftChanged)
    Q_PROPERTY(double lonTopLeft READ lonTopLeft WRITE setLonTopLeft NOTIFY lonTopLeftChanged)
    Q_PROPERTY ( QQmlListProperty<Cache> caches READ caches NOTIFY cachesChanged)
    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:
    explicit  CachesBBox(Requestor *parent = nullptr);
    ~CachesBBox() override;

    Q_INVOKABLE void sendRequest(QString token) override;
    Q_INVOKABLE void updateFilterCaches(QList <int> types , QList <int> Sizes , QList <double > difficultyTerrain ,bool found , bool archived ,QList <QString > keyWordDiscoverOwner ,QString userName);

    QQmlListProperty<Cache> caches();

    QString state() const;
    void setState(const QString &state);

    void parseJson(const QJsonDocument &dataJsonDoc) override;

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
    void stateChanged();

protected:
    const int MAX_PER_PAGE=40;
    const int GEOCACHE_LOG_COUNT=30;
    const int TRACKABLE_LOG_COUNT=30;

    int m_indexMoreCachesBBox;
    bool m_moreCachesBBox;
    QString m_userName;
    QList<Cache*> m_caches;
    QList<int> m_filterTypes;
    QList<int> m_filterSizes;
    QList<double> m_filterDifficultyTerrain;
    QList<QString> m_keyWordDiscoverOwner;
    bool m_filterExcludeFound;
    bool m_filterExcludeArchived;

private:
    QString m_state;
    double m_latBottomRight;
    double m_lonBottomRight;
    double m_latTopLeft;
    double m_lonTopLeft;
};

#endif // CACHESBBOX_H
