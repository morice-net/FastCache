#ifndef CACHE_H
#define CACHE_H

#include <QObject>

class Cache : public QObject
{

    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString geocode READ geocode WRITE setGeocode NOTIFY geocodeChanged)
    Q_PROPERTY(QString size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(int difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(int terrain READ terrain WRITE setTerrain NOTIFY terrainChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(bool archived READ archived WRITE setArchived NOTIFY archivedChanged)
    Q_PROPERTY(bool disabled READ disabled WRITE setDisabled NOTIFY disabledChanged)
    Q_PROPERTY(int favoritePoints READ favoritePoints WRITE setFavoritePoints NOTIFY favoritePointsChanged)
    Q_PROPERTY(int tackableCount READ trackableCount WRITE setTrackableCount NOTIFY trackableCountChanged)
    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY ownerChanged)
    Q_PROPERTY(bool found READ found WRITE setFound NOTIFY foundChanged)
    Q_PROPERTY(double lat READ lat WRITE setLat NOTIFY latChanged)
    Q_PROPERTY(double lon READ lon WRITE setLon NOTIFY lonChanged)


public:
    explicit  Cache(QObject *parent = 0);
    ~Cache();

    QString name() const;
    void  setName(QString &m_name);

    QString  geocode()const;
    void    setGeocode(QString &m_geocode);

    QString size()const ;
    void    setSize(QString &m_size);

    int difficulty()const;
    void    setDifficulty(int &m_difficulty);

    int terrain() const;
    void  setTerrain(int &m_terrain);

    QString  type()const;
    void    setType(QString &m_type);

    QString date()const ;
    void    setDate(QString &m_date);

    bool archived()const;
    void    setArchived(bool &m_archived);

    bool disabled()const;
    void  setDisabled(bool &m_disabled);

    int  favoritePoints()const;
    void    setFavoritePoints(int &m_favoritePoints);

    int trackableCount()const ;
    void    setTrackableCount(int &m_trackableCount);

    QString owner()const;
    void    setOwner(QString &m_owner);

    bool found()const;
    void  setFound(bool &m_found);

    double  lat()const;
    void    setLat(double &m_lat);

    double  lon()const;
    void    setLon(double &m_lon);

signals:
    void nameChanged();
    void geocodeChanged();
    void sizeChanged();
    void difficultyChanged();
    void terrainChanged();
    void typeChanged();
    void dateChanged();
    void archivedChanged();
    void disabledChanged();
    void favoritePointsChanged();
    void trackableCountChanged();
    void ownerChanged();
    void foundChanged();
    void latChanged();
    void lonChanged();

private:
    QString m_name;
    QString m_geocode;
    QString m_size;
    int m_difficulty;
    int m_terrain;
    QString m_type;
    QString m_date;
    bool m_archived;
    bool m_disabled;
    int m_favoritePoints;
    int m_trackableCount;
    QString m_owner;
    bool m_found;
    double m_lat;
    double m_lon;
};

#endif // CACHE_H