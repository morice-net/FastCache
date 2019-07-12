#include "fullcacheretriever.h"
#include "fullcache.h"
#include "smileygc.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullCacheRetriever::FullCacheRetriever(Requestor *parent)
    : Requestor (parent)
{
}

FullCacheRetriever::~FullCacheRetriever()
{
}

void FullCacheRetriever::sendRequest(QString token)
{
    //Build url
    QString requestName = "geocaches/" ;
    requestName.append( m_fullCache->geocode());
    requestName.append("?lite=false");

    // Fields
    requestName.append("&fields=referenceCode,name,difficulty,terrain,favoritePoints,trackableCount,postedCoordinates,ownerAlias,placedDate,geocacheType,"
                       "geocacheSize,location,status,userData,shortDescription,longDescription,hints,attributes,containsHtml,additionalWaypoints");
    // Expand
    requestName.append("&expand=geocachelogs:" + QString::number(GEOCACHE_LOGS_COUNT) +
                       ",trackables:" + QString::number(TRACKABLE_LOGS_COUNT) +
                       ",geocachelog.images:" + QString::number(GEOCACHE_LOG_IMAGES_COUNT) +
                       ",userwaypoints:" + QString::number(USER_WAYPOINTS) +
                       ",images:") + QString::number(IMAGES);

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void FullCacheRetriever::updateFullCache(FullCache *fullCache)
{
    m_fullCache = fullCache;
}

void FullCacheRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject cacheJson = dataJsonDoc.object();
    qDebug() << "cacheOject:" << cacheJson;

    SmileyGc * smileys = new SmileyGc;

    if(cacheJson["status"].toString() == "Unpublished"){
        m_fullCache->setArchived(false);
        m_fullCache->setDisabled(false);
    } else if(cacheJson["status"].toString() == "Active"){
        m_fullCache->setArchived(false);
        m_fullCache->setDisabled(false);
    } else if(cacheJson["status"].toString() == "Disabled"){
        m_fullCache->setArchived(false);
        m_fullCache->setDisabled(true);
    } else if(cacheJson["status"].toString() == "Locked"){
        m_fullCache->setArchived(false);
        m_fullCache->setDisabled(false);
    } else if(cacheJson["status"].toString() == "Archived"){
        m_fullCache->setArchived(true);
        m_fullCache->setDisabled(false);
    }

    m_fullCache->setOwner(cacheJson["ownerAlias"].toString());
    m_fullCache->setDate(cacheJson["placedDate"].toString());

    QJsonObject v1 = cacheJson["geocacheType"].toObject();
    m_fullCache->setType(v1["id"].toInt());

    v1 = cacheJson["geocacheSize"].toObject();
    m_fullCache->setSize(v1["id"].toInt());

    m_fullCache->setDifficulty(cacheJson["difficulty"].toDouble());
    m_fullCache->setFavoritePoints(cacheJson["favoritePoints"].toInt());

    v1 = cacheJson["postedCoordinates"].toObject();
    m_fullCache->setLat(v1["latitude"].toDouble());
    m_fullCache->setLon(v1["longitude"].toDouble());


    m_fullCache->setName(cacheJson["name"].toString());
    m_fullCache->setTrackableCount(cacheJson["trackableCount"].toInt());

    v1 = cacheJson["userData"].toObject();
    if(v1["foundDate"].isNull()){
        m_fullCache->setFound(false);
    } else {
        m_fullCache->setFound(true);
    }

    // Favorited
    m_fullCache->setFavorited(v1["isFavorited"].toBool());

    // Note
    m_fullCache->setNote("");
    m_fullCache->setNote(v1["note"].toString());

    m_fullCache->setTerrain(cacheJson["terrain"].toDouble());

    // Attributes of cache.
    m_fullCache->m_attributes.clear();
    m_fullCache->m_attributesBool.clear();

    QJsonArray  atts = cacheJson.value("attributes").toArray();
    foreach ( const QJsonValue & att, atts)
    {
        m_fullCache->m_attributes.append(att["id"].toInt());
        m_fullCache->m_attributesBool.append(att["isOn"].toBool());
    }
    qDebug() << "*** attributs**\n" <<m_fullCache->m_attributes ;
    qDebug() << "*** attributsBool**\n" <<m_fullCache->m_attributesBool ;
    emit m_fullCache->attributesChanged();
    emit m_fullCache->attributesBoolChanged();

    // State
    v1 = cacheJson["location"].toObject();
    m_fullCache->setLocation(v1["state"].toString());

    // Short description
    m_fullCache->setShortDescriptionIsHtml(cacheJson["containsHtml"].toBool());
    m_fullCache->setShortDescription(cacheJson["ShortDescription"].toString());

    // Long description
    m_fullCache->setLongDescriptionIsHtml(cacheJson["containsHtml"].toBool());
    m_fullCache->setLongDescription(cacheJson["longDescription"].toString());

    // Hints
    m_fullCache->setHints(cacheJson["hints"].toString());

    // Images
    m_fullCache->m_imagesName.clear();
    m_fullCache->m_imagesUrl.clear();
    m_fullCache->m_cacheImagesIndex.clear();

    QJsonArray  images = cacheJson.value("images").toArray();
    foreach (const QJsonValue &image , images)
    {
        m_fullCache->m_imagesName.append(smileys->replaceSmileyTextToImgSrc(image["description"].toString()));
        m_fullCache->m_imagesUrl.append(image["url"].toString());
    }
    m_fullCache->m_cacheImagesIndex.append(m_fullCache->m_imagesName.size());

    qDebug() << "*** imagesName**\n" <<m_fullCache->m_imagesName ;
    qDebug() << "*** imagesUrl**\n" <<m_fullCache->m_imagesUrl ;

    // Logs
    m_fullCache->m_findersCount.clear();
    m_fullCache->m_findersDate.clear();
    m_fullCache->m_findersName.clear();
    m_fullCache->m_logs.clear()  ;
    m_fullCache->m_logsType.clear();
    m_fullCache->m_listVisibleImages.clear();

    QJsonArray geocacheLogs = cacheJson["geocacheLogs"].toArray();
    for (QJsonValue geocacheLog: geocacheLogs)
    {
        m_fullCache->m_logs.append(smileys->replaceSmileyTextToImgSrc(geocacheLog["text"].toString()));
        m_fullCache->m_findersDate.append(geocacheLog["loggedDate"].toString());

        QJsonObject finder = geocacheLog.toObject()["owner"].toObject();
        m_fullCache->m_findersName.append(finder["username"].toString());
        m_fullCache->m_findersCount.append(finder["findCount"].toInt());

        QJsonObject type = geocacheLog["geocacheLogType"].toObject();
        m_fullCache->m_logsType.append(m_fullCache->m_mapLogType.key(type["id"].toInt()));

        QJsonArray logsImage = geocacheLog["images"].toArray();
        for (QJsonValue logImage: logsImage)
        {
            m_fullCache->m_imagesName.append(smileys->replaceSmileyTextToImgSrc(logImage["description"].toString()));
            m_fullCache->m_imagesUrl.append(logImage["url"].toString());
        }
        m_fullCache->m_cacheImagesIndex.append(m_fullCache->m_imagesName.size());
    }

    for(int i = 0; i < m_fullCache->m_imagesName.size(); ++i)
    {
        m_fullCache->m_listVisibleImages.append(true);
    }
    emit m_fullCache->imagesNameChanged();
    emit m_fullCache->imagesUrlChanged();
    emit m_fullCache->logsChanged();
    emit m_fullCache->logsTypeChanged();
    emit m_fullCache->findersCountChanged();
    emit m_fullCache->findersDateChanged();
    emit m_fullCache->findersNameChanged();
    emit m_fullCache->cacheImagesIndexChanged();
    emit m_fullCache->listVisibleImagesChanged();

    // Waypoints
    m_fullCache->m_wptsDescription.clear();
    m_fullCache->m_wptsName.clear();
    m_fullCache->m_wptsLat.clear();
    m_fullCache->m_wptsLon.clear()  ;
    m_fullCache-> m_wptsComment.clear();

    for (QJsonValue waypoint: cacheJson["additionalWaypoints"].toArray())
    {
        m_fullCache->m_wptsDescription.append(waypoint["name"].toString());
        m_fullCache->m_wptsName.append(waypoint["typeName"].toString());

        v1 = waypoint["coordinates"].toObject();
        if(v1["latitude"].isNull()) {
            m_fullCache->m_wptsLat.append(200) ;
        } else{
            m_fullCache->m_wptsLat.append(v1["latitude"].toDouble());
        }
        m_fullCache->m_wptsLon.append(v1["longitude"].toDouble());
        m_fullCache->m_wptsComment.append(waypoint["description"].toString());
    }
    emit m_fullCache->wptsDescriptionChanged();
    emit m_fullCache->wptsNameChanged();
    emit m_fullCache->wptsLatChanged();
    emit m_fullCache->wptsLonChanged();
    emit m_fullCache->wptsCommentChanged();

    // Trackables: list of names and codes.
    m_fullCache-> m_trackableNames.clear();
    m_fullCache->m_trackableCodes.clear();

    for (QJsonValue travel: cacheJson["trackables"].toArray())
    {
        m_fullCache->m_trackableNames.append(travel["name"].toString());
        m_fullCache->m_trackableCodes.append(travel["referenceCode"].toString());
    }
    emit m_fullCache->trackableNamesChanged();
    emit m_fullCache->trackableCodesChanged();

    emit m_fullCache->registeredChanged();

    // request success
    emit requestReady();
}






