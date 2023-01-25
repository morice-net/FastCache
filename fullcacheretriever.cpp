#include "fullcacheretriever.h"
#include "fullcache.h"
#include "smileygc.h"
#include "constants.h"

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
                       ",images:" + QString::number(IMAGES));

    qDebug() << "URL:" << requestName ;

    // Inform QML we are loading
    setState("loading");

    Requestor::sendGetRequest(requestName , token);
}

void FullCacheRetriever::updateFullCache(FullCache *fullCache)
{
    m_fullCache = fullCache;
}

void FullCacheRetriever::updateReplaceImageInText(ReplaceImageInText *replace)
{
    m_replaceImageInText = replace;
}

void FullCacheRetriever::writeToStorage(SQLiteStorage *sqliteStorage)
{
    // Save in database and download images of cache recorded
    sqliteStorage->updateFullCacheColumns("fullcache", m_fullCache->geocode(), m_fullCache->name(), m_fullCache->type(), m_fullCache->size(),
                                          m_fullCache->difficulty(), m_fullCache->terrain(), m_fullCache->lat(), m_fullCache->lon(), m_fullCache->found()
                                          , m_fullCache->own(), m_replaceImageInText->replaceUrlImageToPath(m_fullCache->geocode(), m_dataJson ,true) ,
                                          m_getUserGeocacheLogs->updateUserlogs());
}

void FullCacheRetriever::deleteToStorage(SQLiteStorage *sqliteStorage)
{
    sqliteStorage->deleteObject("fullcache", m_fullCache->geocode());
    // delete dir of recorded cache images
    m_replaceImageInText->removeDir(m_fullCache->geocode());
}

void FullCacheRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    m_dataJson = dataJsonDoc;
    QJsonObject cacheJson;
    cacheJson = dataJsonDoc.object();
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

    m_fullCache->setRegistered(m_fullCache->checkRegistered());
    m_fullCache->setToDoLog(m_fullCache->checkToDoLog());


    m_fullCache->setOwner(cacheJson["ownerAlias"].toString());
    m_fullCache->setDate(cacheJson["placedDate"].toString());

    QJsonObject v1 = cacheJson["geocacheType"].toObject();
    m_fullCache->setType(CACHE_TYPE_MAP.key(v1["id"].toInt()));
    m_fullCache->setTypeIndex(CACHE_TYPE_INDEX_MAP.key(v1["id"].toInt()).toInt());

    v1 = cacheJson["geocacheSize"].toObject();
    m_fullCache->setSize(CACHE_SIZE_MAP.key(v1["id"].toInt()));
    m_fullCache->setSizeIndex(CACHE_SIZE_INDEX_MAP.key(v1["id"].toInt()).toInt());

    m_fullCache->setDifficulty(cacheJson["difficulty"].toDouble());
    m_fullCache->setFavoritePoints(cacheJson["favoritePoints"].toInt());

    // coordinates
    v1 = cacheJson["postedCoordinates"].toObject();
    m_fullCache->setLat(v1["latitude"].toDouble());
    m_fullCache->setLon(v1["longitude"].toDouble());
    v1 = cacheJson["userData"].toObject();
    if(v1["correctedCoordinates"].isNull()){
        m_fullCache->setIsCorrectedCoordinates(false);
    }  else {
        QJsonObject  v2 = v1["correctedCoordinates"].toObject();
        m_fullCache->setCorrectedLat(v2["latitude"].toDouble());
        m_fullCache->setCorrectedLon(v2["longitude"].toDouble());
        m_fullCache->setIsCorrectedCoordinates(true);
    }
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
    QJsonArray  atts = cacheJson.value("attributes").toArray();

    QList<int> listAttributs ;
    QList<bool> listAttributsBool ;
    listAttributs .clear();
    listAttributsBool.clear();

    for(const QJsonValue & att : atts)
    {
        listAttributs.append(att["id"].toInt());
        listAttributsBool.append(att["isOn"].toBool());
    }
    qDebug() << "*** attributs**\n" <<listAttributs ;
    qDebug() << "*** attributsBool**\n" <<listAttributsBool ;
    m_fullCache->setAttributes(listAttributs);
    m_fullCache->setAttributesBool(listAttributsBool);

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
    QJsonArray images = cacheJson.value("images").toArray();

    QList<QString> listImagesName ;
    QList<QString> listImagesUrl ;
    QList<int> listImagesIndex ;
    listImagesName .clear();
    listImagesUrl.clear();
    listImagesIndex.clear();

    for(const QJsonValue &image : images)
    {
        listImagesName .append(smileys->replaceSmileyTextToImgSrc(image["description"].toString()));
        listImagesUrl.append(image["url"].toString());
    }
    listImagesIndex.append(listImagesName .size());

    qDebug() << "*** imagesName**\n" <<listImagesName ;
    qDebug() << "*** imagesUrl**\n" <<listImagesUrl ;

    // Logs
    QList<int> listFindersCount ;
    QList<QString> listFindersDate ;
    QList<QString> listFindersName ;
    QList<QString> listLogs ;
    QList<QString> listLogsType ;
    QList<bool> listVisibleImages;

    listFindersCount.clear();
    listFindersDate.clear();
    listFindersName.clear();
    listLogs.clear();
    listLogsType.clear();
    listVisibleImages.clear();

    QJsonArray geocacheLogs = cacheJson["geocacheLogs"].toArray();
    for (QJsonValue geocacheLog: qAsConst(geocacheLogs))
    {
        listLogs.append(smileys->replaceSmileyTextToImgSrc(geocacheLog["text"].toString()));
        listFindersDate.append(geocacheLog["loggedDate"].toString());

        QJsonObject finder = geocacheLog.toObject()["owner"].toObject();
        listFindersName.append(finder["username"].toString());
        listFindersCount.append(finder["findCount"].toInt());

        QJsonObject type = geocacheLog["geocacheLogType"].toObject();
        listLogsType.append(LOG_TYPE_CACHE_MAP.key(type["id"].toInt()));

        QJsonArray logsImage = geocacheLog["images"].toArray();
        for (const QJsonValue &logImage: qAsConst(logsImage))
        {
            listImagesName.append(smileys->replaceSmileyTextToImgSrc(logImage["description"].toString()));
            listImagesUrl.append(logImage["url"].toString());
        }
        listImagesIndex.append(listImagesName.size());
    }

    for(int i = 0; i < listImagesName.size(); ++i)
    {
        listVisibleImages.append(true);
    }
    m_fullCache->setImagesName(listImagesName);
    m_fullCache->setImagesUrl(listImagesUrl);
    m_fullCache->setLogs(listLogs);
    m_fullCache->setLogsType(listLogsType);
    m_fullCache->setFindersCount(listFindersCount);
    m_fullCache->setFindersDate(listFindersDate);
    m_fullCache->setFindersName(listFindersName);
    m_fullCache->setCacheImagesIndex(listImagesIndex);
    m_fullCache->setListVisibleImages(listVisibleImages);

    // Waypoints
    QList<QString> listWptsDescription ;
    QList<QString> listWptsName ;
    QList<QString> listWptsIcon ;
    QList<double> listWptsLat ;
    QList<double> listWptsLon ;
    QList<QString> listWptsComment ;
    QJsonArray additionalWaypoints = cacheJson["additionalWaypoints"].toArray();

    listWptsDescription.clear();
    listWptsName.clear();
    listWptsIcon.clear();
    listWptsLat.clear();
    listWptsLon.clear();
    listWptsComment.clear();
    for (const QJsonValue &waypoint: qAsConst(additionalWaypoints))
    {
        listWptsDescription.append(waypoint["name"].toString());
        listWptsName.append(WPT_TYPE_MAP.key(waypoint["typeId"].toInt()));
        listWptsIcon.append(WPT_TYPE_ICON_MAP.key(waypoint["typeId"].toInt()));

        v1 = waypoint["coordinates"].toObject();
        if(v1["latitude"].isNull()) {
            listWptsLat.append(200) ;
        } else{
            listWptsLat.append(v1["latitude"].toDouble());
        }
        listWptsLon.append(v1["longitude"].toDouble());
        listWptsComment.append(waypoint["description"].toString());
    }
    m_fullCache->setWptsDescription(listWptsDescription);
    m_fullCache->setWptsName(listWptsName);
    m_fullCache->setWptsIcon(listWptsIcon);
    m_fullCache->setWptsLat(listWptsLat);
    m_fullCache->setWptsLon(listWptsLon);
    m_fullCache->setWptsComment(listWptsComment);

    // UserWaypoints
    QList<QString> listUserWptsDescription ;
    QList<double> listUserWptsLat ;
    QList<double> listUserWptsLon ;
    QList<QString> listUserWptsCode ;
    QJsonArray userWaypoints = cacheJson["userWaypoints"].toArray();

    listUserWptsDescription.clear();
    listUserWptsLat.clear();
    listUserWptsLon.clear();
    listUserWptsCode.clear();

    for (const QJsonValue &userWaypoint: qAsConst(userWaypoints))
    {
        listUserWptsDescription.append(userWaypoint["description"].toString());
        listUserWptsCode.append(userWaypoint["referenceCode"].toString());

        v1 = userWaypoint["coordinates"].toObject();
        if(v1["latitude"].isNull()) {
            listUserWptsLat.append(200) ;
        } else{
            listUserWptsLat.append(v1["latitude"].toDouble());
        }
        listUserWptsLon.append(v1["longitude"].toDouble());
    }
    m_fullCache->setUserWptsDescription(listUserWptsDescription);
    m_fullCache->setUserWptsCode(listUserWptsCode);
    m_fullCache->setUserWptsLat(listUserWptsLat);
    m_fullCache->setUserWptsLon(listUserWptsLon);

    // Trackables: list of names and codes.
    QList<QString> listTrackableNames ;
    QList<QString> listTrackableCodes ;
    QJsonArray trackables = cacheJson["trackables"].toArray();

    listTrackableNames.clear();
    listTrackableCodes.clear();
    for (const QJsonValue &travel: qAsConst(trackables))
    {
        listTrackableNames.append(travel["name"].toString());
        listTrackableCodes.append(travel["referenceCode"].toString());
    }
    m_fullCache->setTrackableNames(listTrackableNames);
    m_fullCache->setTrackableCodes(listTrackableCodes);

    delete smileys;

    emit m_fullCache->registeredChanged();
}






