#include "cache.h"

Cache::Cache(QObject *parent):QObject(parent)

  , m_name("")
  , m_geocode("")
  , m_size("")
  , m_difficulty(0)
  , m_terrain(0)
  , m_type("")
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

/** Getters & Setters **/

QString Cache::name() const
{
    return m_name;
}

void Cache::setName(QString &name)
{
    m_name = name;
    emit nameChanged();
}

QString Cache::geocode() const
{
    return m_geocode;
}

void Cache::setGeocode(QString &geocode)
{
    m_geocode = geocode;
    emit geocodeChanged();
}


QString Cache::size() const
{
    return m_size;
}
void Cache::setSize(QString &size)
{
    m_size = size;
    emit sizeChanged();
}

int Cache::difficulty() const
{
    return m_difficulty;
}

void Cache::setDifficulty( int &difficulty)
{
    m_difficulty = difficulty;
    emit difficultyChanged();
}

int Cache::terrain() const
{
    return m_terrain;
}

void Cache::setTerrain(int  &terrain)
{
    m_terrain = terrain;
}

QString Cache::type() const
{
    return m_type;
}

void Cache::setType(QString &type)
{
    m_type = type;
    emit typeChanged();
}

QString Cache::date() const
{
    return m_date;
}

void Cache::setDate(QString &date)
{
    m_date = date;
    emit dateChanged();
}


bool Cache::archived() const
{
    return m_archived;
}
void Cache::setArchived(bool &archived)
{
    m_archived = archived;
    emit archivedChanged();
}

bool Cache::disabled() const
{
    return m_disabled;
}

void Cache::setDisabled( bool &disabled)
{
    m_disabled = disabled;
    emit disabledChanged();
}

int Cache::favoritePoints() const
{
    return m_favoritePoints;
}

void Cache::setFavoritePoints(int  &favoritePoints)
{
    m_favoritePoints = favoritePoints;
}
int Cache::trackableCount() const
{
    return m_trackableCount;
}
void Cache::setTrackableCount(int  &trackableCount)
{
    m_trackableCount = trackableCount;
}

QString Cache::owner() const
{
    return m_owner;
}
void Cache::setOwner(QString  &owner)
{
    m_owner = owner;
}

bool Cache::found() const
{
    return m_found;
}
void Cache::setFound(bool  &found)
{
    m_found = found;
}

double Cache::lat() const
{
    return m_lat;
}
void Cache::setLat(double  &lat)
{
    m_lat = lat;
}

double Cache::lon() const
{
    return m_lon;
}
void Cache::setLon(double  &lon)
{
    m_lon = lon;
}
