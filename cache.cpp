#include "cache.h"

#include <QUrl>
#include <QDesktopServices>

Cache::Cache(QObject *parent)
    : QObject(parent)
    , m_name("")
    , m_geocode("")
    , m_size("")
    , m_sizeIndex(0)
    , m_difficulty(0)
    , m_terrain(0)
    , m_type("")
    , m_typeIndex(0)
    , m_date("")
    , m_archived(true)
    , m_disabled(true)
    , m_favoritePoints(0)
    , m_trackableCount(0)
    , m_owner("")
    , m_found(false)
    , m_lat(0)
    , m_lon(0)
    , m_registered(false)
    , m_toDoLog(false)
{
}

Cache::~Cache()
{
}

void Cache::updateSqliteStorage(SQLiteStorage *sqliteStorage)
{
    m_sqliteStorage = sqliteStorage;
}

bool Cache::checkRegistered()
{
    return   m_sqliteStorage->isCacheInTable("fullcache", m_geocode);
}

void Cache::launchMaps(double lat , double lon)
{
    QString mapsUrl = "https://www.google.com/maps/search/?api=1&basemap=terrain&query=" + QString::number(lat) + "," + QString::number(lon);
    QDesktopServices::openUrl(QUrl(mapsUrl));
}

/** Getters & Setters **/

QString Cache::name() const
{
    return m_name;
}

void Cache::setName(const QString &name)
{
    m_name = name;
    emit nameChanged();
}

QString Cache::geocode() const
{
    return m_geocode;
}

void Cache::setGeocode(const QString &geocode)
{
    m_geocode = geocode;
    emit geocodeChanged();
}

QString Cache::size() const
{
    return m_size;
}

void Cache::setSize(const QString &size)
{
    m_size = size;
    emit sizeChanged();
}

int Cache::sizeIndex() const
{
    return m_sizeIndex;
}

void Cache::setSizeIndex(const int &sizeIndex)
{
    m_sizeIndex = sizeIndex;
    emit sizeIndexChanged();
}

double Cache::difficulty() const
{
    return m_difficulty;
}

void Cache::setDifficulty(const double &difficulty)
{
    m_difficulty = difficulty;
    emit difficultyChanged();
}

double Cache::terrain() const
{
    return m_terrain;
}

void Cache::setTerrain(const double &terrain)
{
    m_terrain = terrain;
    emit terrainChanged();
}

QString Cache::type() const
{
    return m_type;
}

void Cache::setType(const QString &type)
{
    m_type = type;
    emit typeChanged();
}

int Cache::typeIndex() const
{
    return m_typeIndex;
}

void Cache::setTypeIndex(const int &typeIndex)
{
    m_typeIndex = typeIndex;
    emit typeIndexChanged();
}

QString Cache::date() const
{
    return m_date;
}

void Cache::setDate(const QString &date)
{
    m_date = date;
    emit dateChanged();
}

bool Cache::archived() const
{
    return m_archived;
}

void Cache::setArchived(const bool &archived)
{
    m_archived = archived;
    emit archivedChanged();
}

bool Cache::disabled() const
{
    return m_disabled;
}

void Cache::setDisabled(const bool &disabled)
{
    m_disabled = disabled;
    emit disabledChanged();
}

int Cache::favoritePoints() const
{
    return m_favoritePoints;
}

void Cache::setFavoritePoints(const int &favoritePoints)
{
    m_favoritePoints = favoritePoints;
    emit favoritePointsChanged();
}

int Cache::trackableCount() const
{
    return m_trackableCount;
}

void Cache::setTrackableCount(const int &trackableCount)
{
    m_trackableCount = trackableCount;
    emit trackableCountChanged();
}

QString Cache::owner() const
{
    return m_owner;
}

void Cache::setOwner(const QString &owner)
{
    m_owner = owner;
    emit ownerChanged();
}

bool Cache::found() const
{
    return m_found;
}

void Cache::setFound(const bool &found)
{
    m_found = found;
    emit foundChanged();
}

double Cache::lat() const
{
    return m_lat;
}

void Cache::setLat(const double &lat)
{
    m_lat = lat;
    emit latChanged();
}

double Cache::lon() const
{
    return m_lon;
}

void Cache::setLon(const double &lon)
{
    m_lon = lon;
    emit lonChanged();
}

bool Cache::registered() const
{
    return m_registered;
}

void Cache::setRegistered(bool registered)
{
    m_registered = registered;
    emit registeredChanged();
}

bool Cache::toDoLog() const
{
    return m_toDoLog;
}

void Cache::setToDoLog(const bool &log)
{
    m_toDoLog = log ;
    emit toDoLogChanged();
}
