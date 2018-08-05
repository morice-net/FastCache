#include "cachesbbox.h"
#include "cache.h"
#include "connector.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>


CachesBBox::CachesBBox(QObject *parent)
    : CachesRetriever (parent), m_latBottomRight(0), m_lonBottomRight(0), m_latTopLeft(0), m_lonTopLeft(0)
{
}

CachesBBox::~CachesBBox()
{
}

void CachesBBox::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** CachesBBox ***\n" <<dataJsonDoc ;

        if (dataJsonDoc.isNull()) {
            return;
        }

        QJsonObject JsonObj = dataJsonDoc.object();
        QJsonValue value = JsonObj.value("Geocaches");
        QJsonArray caches = value.toArray();

        int lengthCaches = caches.size();
        if (lengthCaches == 0) {
            return ;
        }

        foreach ( const QJsonValue & v, caches)
        {
            Cache *cache ;
            cache = new Cache();

            cache->setArchived(v.toObject().value("Archived").toBool());
            cache->setDisabled(v.toObject().value("Available").toBool());

            QJsonObject v1 = v.toObject().value("Owner").toObject();
            QString owner = v1.value("UserName").toString();
            cache->setOwner(owner);

            QString date(v.toObject().value("DateCreated").toString());
            cache->setDate(date);

            QJsonObject v2 = v.toObject().value("CacheType").toObject();
            int cacheTypeId= v2.value("GeocacheTypeId").toInt();
            cache->setType(cacheTypeId);

            QString code(v.toObject().value("Code").toString());
            cache->setGeocode(code);

            QJsonObject v3 = v.toObject().value("ContainerType").toObject();
            int cacheSizeId= v3.value("ContainerTypeId").toInt();
            cache->setSize(cacheSizeId);

            cache->setDifficulty(v.toObject().value("Difficulty").toDouble());
            cache->setFavoritePoints(v.toObject().value("FavoritePoints").toInt());
            cache->setLat(v.toObject().value("Latitude").toDouble());
            cache->setLon(v.toObject().value("Longitude").toDouble());
            QString name(v.toObject().value("Name").toString());
            cache->setName(name);
            cache->setTrackableCount(v.toObject().value("TrackableCount").toInt());
            cache->setFound(v.toObject().value("HasbeenFoundbyUser").toBool());
            cache->setTerrain(v.toObject().value("Terrain").toDouble());
            qDebug() << "*** Caches***\n" <<cache->name() ;
            m_caches.append(cache);
        }
        if (lengthCaches == MAX_PER_PAGE) {
            // sendRequestMore(tokenTemp);
        }

    } else {
        qDebug() << "*** CachesBBox ERROR ***\n" <<reply->errorString() ;
        return;
    }
    emit cachesChanged() ;
    return;
}

bool CachesBBox::parameterChecker()
{
    if(m_latBottomRight == 0.0 && m_lonBottomRight == 0.0 && m_latTopLeft ==  0.0 && m_lonTopLeft == 0.0) {
        return false;
    }
    return true;
}

QJsonObject CachesBBox::addSpecificParameters()
{
    QJsonObject viewport;
    QJsonObject bottomRight;
    QJsonObject topLeft;
    bottomRight.insert("Latitude", QJsonValue(m_latBottomRight));
    bottomRight.insert("Longitude", QJsonValue(m_lonBottomRight));
    topLeft.insert("Latitude", QJsonValue(m_latTopLeft));
    topLeft.insert("Longitude", QJsonValue(m_lonTopLeft));
    viewport.insert("BottomRight", QJsonValue(bottomRight));
    viewport.insert("TopLeft", QJsonValue(topLeft));
    return viewport;
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

void CachesBBox::updateFilterCaches(QList<int> types , QList<int> sizes , QList<double> difficultyTerrain , bool found , bool archived , QString name)
{
    filterTypes = types ;
    filterSizes = sizes ;
    filterDifficultyTerrain = difficultyTerrain ;
    filterExcludeFound = found ;
    filterExcludeArchived = archived ;
    userName = name ;
}
