#include "cachesnear.h"
#include "cache.h"
#include "connector.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

CachesNear::CachesNear(CachesRetriever *parent)
    : CachesRetriever(parent)
    , m_latPoint(0)
    , m_lonPoint(0)
    , m_distance(0)
{
    m_moreCachesBBox = false;
}

CachesNear::~CachesNear()
{
}

void CachesNear::sendRequest(QString token)
{

}

void CachesNear::parseJson(const QJsonDocument &dataJsonDoc)
{

}

double CachesNear::lonPoint() const
{
    return m_lonPoint;
}

void CachesNear::setLonPoint(double lonPoint)
{
    m_lonPoint = lonPoint;
    emit lonPointChanged();
}

double CachesNear::latPoint() const
{
    return m_latPoint;
}

void CachesNear::setLatPoint(double latPoint)
{
    m_latPoint = latPoint;
    emit latPointChanged();
}

double CachesNear::distance() const
{
    return m_distance;
}

void CachesNear::setDistance(double distance)
{
    m_distance = distance;
    emit distanceChanged();
}

void CachesNear::addGetRequestParameters(QString &parameters)
{
    // create Center, Radius.
}



