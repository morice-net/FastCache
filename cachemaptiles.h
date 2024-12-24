#ifndef CACHEMAPTILES_H
#define CACHEMAPTILES_H

#include <QObject>
#include <QtQml>

class CacheMapTiles: public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString dirCacheOsm READ dirCacheOsm WRITE setDirCacheOsm NOTIFY dirCacheOsmChanged)
    Q_PROPERTY(QString dirCacheCyclOsm READ dirCacheCyclOsm WRITE setDirCacheCyclOsm NOTIFY dirCacheCyclOsmChanged)

public:
    CacheMapTiles(QObject *parent = nullptr);
    ~CacheMapTiles();

    QString dirCacheOsm() const;
    void setDirCacheOsm(const QString &dir);

    QString  dirCacheCyclOsm() const;
    void setDirCacheCyclOsm(const QString &dir);

signals:
    void dirCacheOsmChanged();
    void dirCacheCyclOsmChanged();

private:
    QString m_dirCacheOsm = "./cacheOsmTiles";
    QString m_dirCacheCyclOsm = "./cacheCyclOsmTiles";
};

#endif // CACHEMAPTILES_H
