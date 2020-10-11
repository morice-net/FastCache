#include "cachesnear.h"
#include "cache.h"
#include "connector.h"
#include "constants.h"

#include <QJsonDocument>

CachesNear::CachesNear(CachesRetriever *parent)
    : CachesRetriever(parent)
    , m_latPoint(0)
    , m_lonPoint(0)
    , m_distance(0)
{
}

CachesNear::~CachesNear()
{
}

void CachesNear::sendRequest(QString token)
{
    CachesRetriever::sendRequest(token);
}

void CachesNear::parseJson(const QJsonDocument &dataJsonDoc)
{    
    CachesRetriever::parseJson(dataJsonDoc);
    emit cachesChanged();
}

void CachesNear::moreCaches()
{
    setIndexMoreCaches(m_indexMoreCaches + MAX_PER_PAGE);
}

void CachesNear::addGetRequestParameters(QString &parameters)
{
    // create Center, Radius.
    parameters.append("&q=location:[" + QString::number(m_latPoint) + "," + QString::number(m_lonPoint) + "]%2Bradius:"+QString::number(m_distance)+"km");
}

/** Getters & Setters **/

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





