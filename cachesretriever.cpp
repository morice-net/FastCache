#include "cachesretriever.h"
#include "cache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>


CachesRetriever::CachesRetriever(QObject *parent) : Requestor(parent), m_caches(QList<Cache*>())
{
}


QQmlListProperty<Cache> CachesRetriever::caches()
{
    return QQmlListProperty<Cache>(this, m_caches);
}

void CachesRetriever::sendRequest(QString token)
{
    if(!parameterChecker())
        return;

    m_caches.clear();
    m_indexMoreCachesBBox = 0;

    // lat, lon on format E6.

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//SearchForGeocaches?format=json");

    QJsonObject parameters;
    QJsonObject geocacheType;
    QJsonObject geocacheSize;
    QJsonObject geocacheDifficulty;
    QJsonObject geocacheTerrain;


    QJsonObject excludeFounds;
    QJsonObject excludeMine;
    QJsonObject geocacheExclusion;

    QJsonObject geocacheName;
    QJsonObject foundByUser;
    QJsonObject hiddenByUsers;



    QJsonArray geocacheTypeIds;
    QJsonArray geocacheSizeIds;
    QJsonArray userNames;

    m_tokenTemp=token;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(true));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));

    // filter by type.
    if(!m_filterTypes.isEmpty()){
        foreach ( int type, m_filterTypes)
        {
            geocacheTypeIds.append(type);
        }
        geocacheType.insert("GeocacheTypeIds", QJsonValue(geocacheTypeIds));
        parameters.insert("GeocacheType",QJsonValue(geocacheType));
    }

    // filter by size.
    if(!m_filterSizes.isEmpty()){
        foreach ( int size, m_filterSizes)
        {
            geocacheSizeIds.append(size);
        }
        geocacheSize.insert("GeocacheContainerSizeIds", QJsonValue(geocacheSizeIds));
        parameters.insert("GeocacheContainerSize",QJsonValue(geocacheSize));
    }

    // filter by difficulty, terrain.
    if(m_filterDifficultyTerrain[0] != 1.0 || m_filterDifficultyTerrain[1] != 5.0){
        geocacheDifficulty.insert("MinDifficulty", QJsonValue(m_filterDifficultyTerrain[0]));
        geocacheDifficulty.insert("MaxDifficulty", QJsonValue(m_filterDifficultyTerrain[1]));
        parameters.insert("Difficulty", QJsonValue(geocacheDifficulty));
    }
    if(m_filterDifficultyTerrain[2] != 1.0 || m_filterDifficultyTerrain[3] != 5.0){
        geocacheTerrain.insert("MinTerrain", QJsonValue(m_filterDifficultyTerrain[2]));
        geocacheTerrain.insert("MaxTerrain", QJsonValue(m_filterDifficultyTerrain[3]));
        parameters.insert("Terrain", QJsonValue(geocacheTerrain));
    }

    // filter by keyword,discover and owner.
    if(!m_keyWordDiscoverOwner[0].isEmpty() ){
        geocacheName.insert("GeocacheName", QJsonValue(m_keyWordDiscoverOwner[0]));
        parameters.insert("GeocacheName", QJsonValue(geocacheName));
    }
    if(!m_keyWordDiscoverOwner[1].isEmpty() ){
        foundByUser.insert("UserName", QJsonValue(m_keyWordDiscoverOwner[1]));
        parameters.insert("FoundByUser", QJsonValue(foundByUser));
    }
    if(!m_keyWordDiscoverOwner[2].isEmpty() ){
        QJsonArray array = { QString(m_keyWordDiscoverOwner[2]) };
        hiddenByUsers.insert("UserNames", QJsonValue(array));
        parameters.insert("HiddenByUsers", QJsonValue(hiddenByUsers));
    }

    // Exclude caches found and mine.
    if(m_filterExcludeFound == true){
        userNames.append(m_userName);
        excludeFounds.insert("UserNames", QJsonValue(userNames));
        excludeMine.insert("UserNames", QJsonValue(userNames));
        parameters.insert("NotFoundByUsers",QJsonValue(excludeFounds));
        parameters.insert("NotHiddenByUsers",QJsonValue(excludeMine));
    }

    // Exclude caches archived and available.
    if(m_filterExcludeArchived == true){
        geocacheExclusion.insert("Archived", QJsonValue(m_filterExcludeArchived));
        geocacheExclusion.insert("Available", QJsonValue(m_filterExcludeArchived));
        parameters.insert("GeocacheExclusions",QJsonValue(geocacheExclusion));
    }

    // Adding specific parameters
    addSpecificParameters(parameters);

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cachesJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void CachesRetriever::sendRequestMore(QString token)
{
    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//GetMoreGeocaches?format=json");

    QJsonObject parameters;

    m_indexMoreCachesBBox = m_indexMoreCachesBBox + MAX_PER_PAGE;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(true));
    parameters.insert("StartIndex",m_indexMoreCachesBBox);
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cachesJson(More):" << QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void CachesRetriever::onReplyFinished(QNetworkReply *reply)
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
            emit cachesChanged() ;
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
        if (m_moreCachesBBox == true && lengthCaches == MAX_PER_PAGE) {
            sendRequestMore(m_tokenTemp);
        }

    } else {
        qDebug() << "*** CachesNear ERROR ***\n" <<reply->errorString() ;
        return;
    }
    emit cachesChanged() ;
    return;
}

void CachesRetriever::updateFilterCaches(QList<int> types , QList<int> sizes , QList<double> difficultyTerrain , bool found , bool archived ,
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
