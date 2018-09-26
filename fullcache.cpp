#include "fullcache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullCache::FullCache(Cache *parent):  Cache (parent),  m_state()
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &FullCache::onReplyFinished);
}

void FullCache::sendRequest( QString token){

    setState("loading");

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//SearchForGeocaches?format=json");

    QJsonObject parameters;
    QJsonObject geocacheCode;

    QJsonArray geocachesCodes;

    geocachesCodes.append(FullCache::geocode());
    geocacheCode.insert("CacheCodes",QJsonValue(geocachesCodes));

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(false));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));
    parameters.insert("CacheCode", QJsonValue(geocacheCode));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cacheJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void FullCache::onReplyFinished(QNetworkReply *reply)
{
    setState("loaded");

    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** Cache ***\n" <<dataJsonDoc ;
        if (dataJsonDoc.isNull()) {
            return;
        }
        QJsonObject JsonObj = dataJsonDoc.object();
        QJsonValue value = JsonObj.value("Geocache");
        QJsonArray caches = value.toArray();

        int lengthCaches = caches.size();
        if (lengthCaches == 0) {
            return ;
        }

        foreach ( const QJsonValue & v, caches)
        {
            FullCache *cache ;
            cache = new FullCache();

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



        }


    }   else {
        qDebug() << "*** Cache ERROR ***\n" <<reply->errorString() ;
        return;
    }
    return;
}

QString FullCache::state() const
{
    return m_state;
}

void FullCache::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}




