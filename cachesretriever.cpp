#include "cachesretriever.h"
#include "cache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

CachesRetriever::CachesRetriever(Requestor *parent)
    : Requestor (parent)
    , m_caches(QList<Cache*>())
    ,  m_state()
{    
}

CachesRetriever::~CachesRetriever()
{
}

QQmlListProperty<Cache> CachesRetriever::caches()
{
    return QQmlListProperty<Cache>(this, m_caches);
}

void CachesRetriever::sendRequest(QString token)
{
    m_caches.clear();
    m_indexMoreCachesBBox = 0;

    //Build url
    QString requestName = "geocaches/search?";

    // Inform QML we are loading
    setState("loading");

    m_tokenTemp=token;

    // filter by type.
    if(!m_filterTypes.isEmpty()){
        foreach ( int type, m_filterTypes)
        {
        }
    }

    // filter by size.
    if(!m_filterSizes.isEmpty()){
        foreach ( int size, m_filterSizes)
        {
        }
    }

    // filter by difficulty, terrain.
    if(m_filterDifficultyTerrain[0] != 1.0 || m_filterDifficultyTerrain[1] != 5.0){

    }
    if(m_filterDifficultyTerrain[2] != 1.0 || m_filterDifficultyTerrain[3] != 5.0){

    }

    // filter by keyword,discover and owner.
    if(!m_keyWordDiscoverOwner[0].isEmpty() ){

    }
    if(!m_keyWordDiscoverOwner[1].isEmpty() ){

    }
    if(!m_keyWordDiscoverOwner[2].isEmpty() ){

    }

    // Exclude caches found and mine.
    if(m_filterExcludeFound == true){

    }

    // Exclude caches archived and available.
    if(m_filterExcludeArchived == true){

    }

    // Adding specific parameters
    addGetRequestParameters(requestName);
    Requestor::sendGetRequest(requestName , token);
}

void CachesRetriever::sendRequestMore(QString token)
{
    // Inform QML we are loading
    setState("loading");
    m_indexMoreCachesBBox = m_indexMoreCachesBBox + MAX_PER_PAGE;
}

void CachesRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonArray cachesJson = dataJsonDoc.array();
    qDebug() << "caches:" << cachesJson ;

    // request success
    emit requestReady();
}

void CachesRetriever::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    QJsonObject JsonObj;
    QJsonObject  statusJson;

    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** CachesNear ***\n" <<dataJsonDoc ;

        if (dataJsonDoc.isNull()) {
            // Inform the QML that there is a loading error
            setState("error");
            return;
        }
        JsonObj = dataJsonDoc.object();
        statusJson = JsonObj["Status"].toObject();

        int status = statusJson["StatusCode"].toInt();
        if (status != 0) {
            // Inform the QML that there is an error
            setState("error");
            return ;
        }

    } else {
        qDebug() << "*** CachesNear ERROR ***\n" <<reply->errorString() ;

        // Inform the QML that there is an error
        setState("error");
        return;
    }

    // Inform the QML that there is no loading error
    setState("noError");

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
        QString code(v.toObject().value("Code").toString());
        cache->setGeocode(code);
        cache->setRegistered(cache->checkRegistered());

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

QString CachesRetriever::state() const
{
    return m_state;
}

void CachesRetriever::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}
