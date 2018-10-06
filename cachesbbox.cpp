#include "cache.h"
#include "connector.h"
#include "cachesbbox.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>


CachesBBox::CachesBBox(QObject *parent)
    : CachesRetriever (parent)
    , m_latBottomRight(0)
    , m_lonBottomRight(0)
    , m_latTopLeft(0)
    , m_lonTopLeft(0)

{
    m_moreCachesBBox = true;
}

CachesBBox::~CachesBBox()
{
}

bool CachesBBox::parameterChecker()
{
    if(m_latBottomRight == 0.0 && m_lonBottomRight == 0.0 && m_latTopLeft ==  0.0 && m_lonTopLeft == 0.0) {
        return false;
    }
    return true;
}

void CachesBBox::addSpecificParameters(QJsonObject& parameters)
{
    // createViewport.
    QJsonObject viewport;
    QJsonObject bottomRight;
    QJsonObject topLeft;
    bottomRight.insert("Latitude", QJsonValue(m_latBottomRight));
    bottomRight.insert("Longitude", QJsonValue(m_lonBottomRight));
    topLeft.insert("Latitude", QJsonValue(m_latTopLeft));
    topLeft.insert("Longitude", QJsonValue(m_lonTopLeft));
    viewport.insert("BottomRight", QJsonValue(bottomRight));
    viewport.insert("TopLeft", QJsonValue(topLeft));
    parameters.insert("Viewport", QJsonValue(viewport));
}

double CachesBBox::lonTopLeft() const
{
    return m_lonTopLeft;
}

void CachesBBox::setLonTopLeft(double lonTopLeft)
{
    m_lonTopLeft = lonTopLeft;
    emit lonTopLeftChanged();
}

double CachesBBox::latTopLeft() const
{
    return m_latTopLeft;
}

void CachesBBox::setLatTopLeft(double latTopLeft)
{
    m_latTopLeft = latTopLeft;
    emit latTopLeftChanged();
}

double CachesBBox::lonBottomRight() const
{
    return m_lonBottomRight;
}

void CachesBBox::setLonBottomRight(double lonBottomRight)
{
    m_lonBottomRight = lonBottomRight;
    emit lonBottomRightChanged();
}

double CachesBBox::latBottomRight() const
{
    return m_latBottomRight;
}

void CachesBBox::setLatBottomRight(double latBottomRight)
{
    m_latBottomRight = latBottomRight;
    emit latBottomRightChanged();
}

