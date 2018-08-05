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
}

CachesNear::~CachesNear()
{
}

void CachesNear::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** CachesNear ***\n" <<dataJsonDoc ;

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

    } else {
        qDebug() << "*** CachesNear ERROR ***\n" <<reply->errorString() ;
        return;
    }
    emit cachesChanged() ;
    return;
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


void CachesNear::updateFilterCaches(QList<int> types , QList<int> sizes , QList<double> difficultyTerrain , bool found , bool archived , QString name)
{
    filterTypes = types ;
    filterSizes = sizes ;
    filterDifficultyTerrain = difficultyTerrain ;
    filterExcludeFound = found ;
    filterExcludeArchived = archived ;
    userName = name ;
}
