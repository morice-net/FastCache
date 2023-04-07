#include "cachesbbox.h"
#include "constants.h"

#include <QJsonDocument>

CachesBBox::CachesBBox(CachesRetriever *parent)
    : CachesRetriever ( parent)
    , m_latBottomRight(0)
    , m_lonBottomRight(0)
    , m_latTopLeft(0)
    , m_lonTopLeft(0)
{
}

CachesBBox::~CachesBBox()
{
}

void CachesBBox::sendRequest(QString token)
{    
    CachesRetriever::sendRequest(token);
}

void CachesBBox::parseJson(const QJsonDocument &dataJsonDoc)
{
    CachesRetriever::parseJson(dataJsonDoc);
    if(indexMoreCaches() == 0 )
        emit clearMapRequested();
    emit m_listCaches->cachesChanged();
}

void CachesBBox::moreCaches()
{
    setIndexMoreCaches(m_indexMoreCaches + MAX_PER_PAGE);
    sendRequest(m_tokenTemp);
}

QString CachesBBox::addGetRequestParameters(QString parameters)
{
    // createBBox.
    return parameters.append("&q=box:[[" + QString::number(m_latTopLeft) + "," + QString::number(m_lonTopLeft) + "],["
                      + QString::number(m_latBottomRight) + "," + QString::number(m_lonBottomRight) + "]]");
}

/** Getters & Setters **/

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





