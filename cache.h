#ifndef CACHE_H
#define CACHE_H

#include <QMap>

#include <QObject>

class Cache : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString geocode READ geocode WRITE setGeocode NOTIFY geocodeChanged)
    Q_PROPERTY(int size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(double difficulty READ difficulty WRITE setDifficulty NOTIFY difficultyChanged)
    Q_PROPERTY(double terrain READ terrain WRITE setTerrain NOTIFY terrainChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(int typeIndex READ typeIndex WRITE setTypeIndex NOTIFY typeIndexChanged)
    Q_PROPERTY(QString date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(bool archived READ archived WRITE setArchived NOTIFY archivedChanged)
    Q_PROPERTY(bool disabled READ disabled WRITE setDisabled NOTIFY disabledChanged)
    Q_PROPERTY(int favoritePoints READ favoritePoints WRITE setFavoritePoints NOTIFY favoritePointsChanged)
    Q_PROPERTY(int trackableCount READ trackableCount WRITE setTrackableCount NOTIFY trackableCountChanged)
    Q_PROPERTY(QString owner READ owner WRITE setOwner NOTIFY ownerChanged)
    Q_PROPERTY(bool found READ found WRITE setFound NOTIFY foundChanged)
    Q_PROPERTY(double lat READ lat WRITE setLat NOTIFY latChanged)
    Q_PROPERTY(double lon READ lon WRITE setLon NOTIFY lonChanged)
    Q_PROPERTY(double registered READ registered WRITE setRegistered NOTIFY registeredChanged)

public:
    explicit  Cache(QObject *parent = nullptr);
    ~Cache();

    bool checkRegistered();
    Q_INVOKABLE void launchMaps();

    QString name() const;
    void setName(const QString &name);

    QString  geocode() const;
    void setGeocode(const QString &geocode);

    int size() const ;
    void    setSize(const int &size);

    double difficulty() const;
    void setDifficulty(const double &difficulty);

    double terrain() const;
    void  setTerrain(const double &terrain);

    QString  type() const;
    void setType(const QString &type);

    int  typeIndex() const;
    void setTypeIndex(const int &typeIndex);

    QString date() const ;
    void setDate(const QString &date);

    bool archived() const;
    void setArchived(const bool &archived);

    bool disabled() const;
    void setDisabled(const bool &disabled);

    int  favoritePoints() const;
    void setFavoritePoints(const int &favoritePoints);

    int trackableCount() const ;
    void setTrackableCount(const int &trackableCount);

    QString owner() const;
    void    setOwner(const QString &owner);

    bool found() const;
    void setFound(const bool &found);

    double lat() const;
    void setLat(const double &lat);

    double lon() const;
    void setLon(const double &lon);

    bool registered() const;
    void setRegistered(bool registered);

signals:
    void nameChanged();
    void geocodeChanged();
    void sizeChanged();
    void difficultyChanged();
    void terrainChanged();
    void typeChanged();
    void typeIndexChanged();
    void dateChanged();
    void archivedChanged();
    void disabledChanged();
    void favoritePointsChanged();
    void trackableCountChanged();
    void ownerChanged();
    void foundChanged();
    void latChanged();
    void lonChanged();
    void registeredChanged();

protected:
    QString m_name;
    QString m_geocode;
    int m_size;
    double m_difficulty;
    double m_terrain;
    QString m_type;
    int m_typeIndex;
    QString m_date;
    bool m_archived;
    bool m_disabled;
    int m_favoritePoints;
    int m_trackableCount;
    QString m_owner;
    bool m_found;
    double m_lat;
    double m_lon;
    bool m_registered;
};

#endif // CACHE_H
