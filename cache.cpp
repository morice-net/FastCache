#include "cache.h"

#include <QUrl>
#include <QDesktopServices>

Cache::Cache(QObject *parent)
    : QObject(parent)
    , m_name("")
    , m_geocode("")
    , m_size(0)
    , m_difficulty(0)
    , m_terrain(0)
    , m_type(0)
    , m_date("")
    , m_archived(true)
    , m_disabled(true)
    , m_favoritePoints(0)
    , m_trackableCount(0)
    , m_owner("")
    , m_found(false)
    , m_lat(0)
    , m_lon(0)
{
}

Cache::~Cache()
{
}

void Cache::launchMaps()
{
    QString mapsUrl = "https://www.google.com/maps/search/?api=1&basemap=terrain&query=" + QString::number(m_lat) + "," + QString::number(m_lon);
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

int Cache::size() const
{
    return m_size;
}

void Cache::setSize(const int &size)
{
    m_size = size;
    emit sizeChanged();
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

int Cache::type() const
{
    return m_type;
}

void Cache::setType(const int &type)
{
    m_type = type;
    emit typeChanged();
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
}
