#include "cache.h"
#include "connector.h"
#include "cachesbbox.h"

#include <QJsonDocument>
#include <QJsonObject>

CachesBBox::CachesBBox(Requestor *parent)
    : Requestor (parent)
    , m_caches(QList<Cache*>())
    , m_state()
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

/** Data retriever using the requestor **/

void CachesBBox::sendRequest(QString token)

{
    //Build url
    QString requestName = "geocaches/search?";

    //BBox
    requestName.append("q=box:[[" + QString::number(m_latTopLeft) + "," + QString::number(m_lonTopLeft) + "],["
                       + QString::number(m_latBottomRight) + "," + QString::number(m_lonBottomRight) + "]]&lite=true");



    qDebug() << "bbox:" << requestName ;

    Requestor::sendGetRequest(requestName , token);

}

void CachesBBox::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject cachesBBoxJson = dataJsonDoc.object();
    qDebug() << "cachesBBoxJson:" << cachesBBoxJson ;

    // request success
    emit requestReady();
}

void CachesBBox::updateFilterCaches(QList<int> types , QList<int> sizes , QList<double> difficultyTerrain , bool found , bool archived ,
                                    QList<QString> keyWordDiscoverOwner ,QString name)
{
    m_filterTypes = types ;
    m_filterSizes = sizes ;
    m_filterDifficultyTerrain = difficultyTerrain ;
    m_filterExcludeFound = found ;
    m_filterExcludeArchived = archived ;
    m_keyWordDiscoverOwner = keyWordDiscoverOwner;
    m_userName = name ;
}

QQmlListProperty<Cache> CachesBBox::caches()
{
    return QQmlListProperty<Cache>(this, m_caches);
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

QString CachesBBox::state() const
{
    return m_state;
}

void CachesBBox ::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}



