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
    indexMoreCachesBBox = 0;

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

    QJsonArray geocacheTypeIds;
    QJsonArray geocacheSizeIds;
    QJsonArray userNames;

    tokenTemp=token;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(true));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));

    // filter by type.
    if(!filterTypes.isEmpty()){
        foreach ( int type, filterTypes)
        {
            geocacheTypeIds.append(type);
        }
        geocacheType.insert("GeocacheTypeIds", QJsonValue(geocacheTypeIds));
        parameters.insert("GeocacheType",QJsonValue(geocacheType));
    }

    // filter by size.
    if(!filterSizes.isEmpty()){
        foreach ( int size, filterSizes)
        {
            geocacheSizeIds.append(size);
        }
        geocacheSize.insert("GeocacheContainerSizeIds", QJsonValue(geocacheSizeIds));
        parameters.insert("GeocacheContainerSize",QJsonValue(geocacheSize));
    }

    // filter by difficulty, terrain.
    if(filterDifficultyTerrain[0] != 1.0 || filterDifficultyTerrain[1] != 5.0){
        geocacheDifficulty.insert("MinDifficulty", QJsonValue(filterDifficultyTerrain[0]));
        geocacheDifficulty.insert("MaxDifficulty", QJsonValue(filterDifficultyTerrain[1]));
        parameters.insert("Difficulty", QJsonValue(geocacheDifficulty));
    }
    if(filterDifficultyTerrain[2] != 1.0 || filterDifficultyTerrain[3] != 5.0){
        geocacheTerrain.insert("MinTerrain", QJsonValue(filterDifficultyTerrain[2]));
        geocacheTerrain.insert("MaxTerrain", QJsonValue(filterDifficultyTerrain[3]));
        parameters.insert("Terrain", QJsonValue(geocacheTerrain));
    }

    // Exclude caches found and mine.
    if(filterExcludeFound == true){
        userNames.append(userName);
        excludeFounds.insert("UserNames", QJsonValue(userNames));
        excludeMine.insert("UserNames", QJsonValue(userNames));
        parameters.insert("NotFoundByUsers",QJsonValue(excludeFounds));
        parameters.insert("NotHiddenByUsers",QJsonValue(excludeMine));
    }

    // Exclude caches archived and available.
    if(filterExcludeArchived == true){
        geocacheExclusion.insert("Archived", QJsonValue(filterExcludeArchived));
        geocacheExclusion.insert("Available", QJsonValue(filterExcludeArchived));
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

    indexMoreCachesBBox = indexMoreCachesBBox + MAX_PER_PAGE;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(true));
    parameters.insert("StartIndex",indexMoreCachesBBox);
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cachesJson(More):" << QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}
