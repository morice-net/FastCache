#ifndef CACHE_H
#define CACHE_H

#include "sqlitestorage.h"

#include <QMap>
#include <QObject>

class Cache : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString geocode READ geocode WRITE setGeocode NOTIFY geocodeChanged)
    Q_PROPERTY(QString size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(int sizeIndex READ sizeIndex WRITE setSizeIndex NOTIFY sizeIndexChanged)
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
    Q_PROPERTY(bool registered READ registered WRITE setRegistered NOTIFY registeredChanged)
    Q_PROPERTY(bool toDoLog READ toDoLog WRITE setToDoLog NOTIFY toDoLogChanged)
    Q_PROPERTY(bool own READ own WRITE setOwn NOTIFY ownChanged)

    // add for lab caches
    Q_PROPERTY(QString imageUrl READ imageUrl WRITE setImageUrl NOTIFY imageUrlChanged)
    Q_PROPERTY(bool isCompleted READ isCompleted WRITE setIsCompleted NOTIFY isCompletedChanged)
    Q_PROPERTY(double ratingsAverage READ ratingsAverage WRITE setRatingsAverage NOTIFY ratingsAverageChanged)
    Q_PROPERTY(int ratingsTotalCount READ ratingsTotalCount WRITE setRatingsTotalCount NOTIFY ratingsTotalCountChanged)
    Q_PROPERTY(int stagesTotalCount READ stagesTotalCount WRITE setStagesTotalCount NOTIFY stagesTotalCountChanged)

public:
    explicit  Cache(QObject *parent = nullptr);
    ~Cache();

    bool checkRegistered();
    bool checkToDoLog();

    Q_INVOKABLE void updateSqliteStorage(SQLiteStorage *sqliteStorage);
    Q_INVOKABLE void launchMaps(double lat , double lon);
    Q_INVOKABLE void launchAdventureLab(QString url);

    QString name() const;
    void setName(const QString &name);

    QString  geocode() const;
    void setGeocode(const QString &geocode);

    QString size() const ;
    void  setSize(const QString &size);

    int  sizeIndex() const ;
    void setSizeIndex(const int &sizeIndex);

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

    bool toDoLog() const;
    void setToDoLog(const bool &log);

    bool own() const;
    void setOwn(const bool &own);

    QString imageUrl() const;
    void setImageUrl(const QString &mage);

    bool isCompleted() const;
    void setIsCompleted(const bool &complete);

    double ratingsAverage() const;
    void setRatingsAverage(const double &average);

    int ratingsTotalCount() const;
    void setRatingsTotalCount(const int &totalCount);

    int stagesTotalCount() const;
    void setStagesTotalCount(const int &totalCount);

signals:
    void nameChanged();
    void geocodeChanged();
    void sizeChanged();
    void sizeIndexChanged();
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
    void toDoLogChanged();
    void ownChanged();
    void imageUrlChanged();
    void isCompletedChanged();
    void ratingsAverageChanged();
    void ratingsTotalCountChanged();
    void stagesTotalCountChanged();

protected:
    QString m_name;
    QString m_geocode;
    QString m_size;
    int m_sizeIndex;
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
    bool m_toDoLog;
    bool m_own;
    QString m_imageUrl;
    bool m_isCompleted;
    double m_ratingsAverage;
    int m_ratingsTotalCount;
    int m_stagesTotalCount;

private:
    SQLiteStorage *m_sqliteStorage;
};

#endif // CACHE_H
