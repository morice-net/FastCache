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
    , m_indexMoreCaches(0)
    , m_caches(QList<Cache*>())
    , m_state()
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
    m_tokenTemp=token;
    if(m_indexMoreCaches == 0) {
        m_caches.clear();
    }

    //Build url
    QString requestName = "geocaches/search?";
    requestName.append("lite=true");

    //Pagination
    requestName.append("&skip=" + QString::number(m_indexMoreCaches) + "&take=" + QString::number(MAX_PER_PAGE));

    // Fields

    requestName.append("&fields=referenceCode,name,difficulty,terrain,favoritePoints,trackableCount,postedCoordinates,ownerAlias,placedDate,geocacheType,"
                       "geocacheSize,location,status,userData");

    // Adding specific parameters(BBox or Center radius)
    addGetRequestParameters(requestName);

    // filter by type.
    if(!m_filterTypes.isEmpty()){
        requestName.append("%2Btype:");
        for ( int type: m_filterTypes)
        {
            requestName.append(QString::number(type) + ",");
        }
        requestName.remove(requestName.size()-1, 1);
    }

    // filter by size.
    if(!m_filterSizes.isEmpty()){
        requestName.append("%2Bsize:");
        for ( int size: m_filterSizes)
        {
            requestName.append(QString::number(size) + ",");
        }
        requestName.remove(requestName.size()-1, 1);
    }

    // filter by difficulty, terrain.
    if(m_filterDifficultyTerrain[0] != 1.0 || m_filterDifficultyTerrain[1] != 5.0){
        requestName.append( "%2Bdiff:" + QString::number(m_filterDifficultyTerrain[0]) + "-" + QString::number(m_filterDifficultyTerrain[1]));
    }
    if(m_filterDifficultyTerrain[2] != 1.0 || m_filterDifficultyTerrain[3] != 5.0){
        requestName.append( "%2Bterr:" + QString::number(m_filterDifficultyTerrain[2]) + "-" + QString::number(m_filterDifficultyTerrain[3]));
    }

    // filter by keyword,discover and owner.
    if(!m_keyWordDiscoverOwner[0].isEmpty() ){
        requestName.append("%2Bname:" + m_keyWordDiscoverOwner[0] );
    }
    if(!m_keyWordDiscoverOwner[1].isEmpty() ){
        requestName.append("%2Bfby:" + m_keyWordDiscoverOwner[1] );
    }
    if(!m_keyWordDiscoverOwner[2].isEmpty() ){
        requestName.append("%2Bhby:" + m_keyWordDiscoverOwner[2] );
    }

    // Exclude caches found and mine.
    if(m_filterExcludeFound == true){
        requestName.append("%2Bfby:not(" + m_userName + ")");
    }

    // Exclude caches archived and available.
    if(m_filterExcludeArchived == true){
        requestName.append("%2Bia:true");
    }
    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void CachesRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    if (dataJsonDoc.isNull()) {
        // Inform the QML that there is a loading error
        setState("error");
        return;
    }
    QJsonArray caches = dataJsonDoc.array();
    qDebug() << "cachesArray:" << caches ;

    // Inform the QML that there is no loading error
    setState("noError");

    int lengthCaches = caches.size();
    if (lengthCaches == 0) {
        return ;
    }

    foreach ( const QJsonValue & v, caches)
    {
        Cache *cache ;
        cache = new Cache();

        cache->setGeocode(v["referenceCode"].toString());
        cache->setRegistered(cache->checkRegistered());

        if(v["status"].toString() == "Unpublished"){
            cache->setArchived(false);
            cache->setDisabled(false);
        } else if(v["status"].toString() == "Active"){
            cache->setArchived(false);
            cache->setDisabled(false);
        } else if(v["status"].toString() == "Disabled"){
            cache->setArchived(false);
            cache->setDisabled(true);
        } else if(v["status"].toString() == "Locked"){
            cache->setArchived(false);
            cache->setDisabled(false);
        } else if(v["status"].toString() == "Archived"){
            cache->setArchived(true);
            cache->setDisabled(false);
        }

        cache->setOwner(v["ownerAlias"].toString());
        cache->setDate(v["placedDate"].toString());

        QJsonObject v1 = v["geocacheType"].toObject();
        cache->setType(v1["id"].toInt());

        v1 = v["geocacheSize"].toObject();
        cache->setSize(v1["id"].toInt());

        cache->setDifficulty(v["difficulty"].toDouble());
        cache->setFavoritePoints(v["favoritePoints"].toInt());

        v1 = v["postedCoordinates"].toObject();
        cache->setLat(v1["latitude"].toDouble());
        cache->setLon(v1["longitude"].toDouble());

        QString name(v["name"].toString());
        cache->setName(name);
        cache->setTrackableCount(v["trackableCount"].toInt());

        v1 = v["userData"].toObject();
        if(v1["foundDate"].isNull()){
            cache->setFound(false);
        } else {
            cache->setFound(true);
        }
        cache->setTerrain(v["terrain"].toDouble());
        m_caches.append(cache);
    }

    // request success
    emit requestReady();

    if (lengthCaches == MAX_PER_PAGE) {
        moreCaches();
    } else if(lengthCaches != MAX_PER_PAGE)
        m_indexMoreCaches = 0 ;
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



