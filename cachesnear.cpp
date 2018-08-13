#include "cachesnear.h"
#include "cache.h"
#include "connector.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>


CachesNear::CachesNear(QObject *parent)
    : CachesRetriever(parent), m_latPoint(0), m_lonPoint(0), m_distance(0)
{
    m_moreCachesBBox = false;
}

CachesNear::~CachesNear()
{
}

bool CachesNear::parameterChecker()
{
    if(m_latPoint == 0.0 && m_lonPoint == 0.0 && m_distance ==  0.0 ) {
        return false;
    }
    return true;

}

void CachesNear::addSpecificParameters(QJsonObject &parameters)
{
    // createCenterPoint.
    QJsonObject pointRadius;
    QJsonObject point;
    point.insert("Latitude", QJsonValue(m_latPoint));
    point.insert("Longitude", QJsonValue(m_lonPoint));
    pointRadius.insert("DistanceInMeters", QJsonValue(m_distance));
    pointRadius.insert("Point", QJsonValue(point));
    parameters.insert("PointRadius", QJsonValue(pointRadius));
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



