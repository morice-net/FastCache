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

void FullCacheRetriever::writeToStorage(SQLiteStorage *sqliteStorage)
{
    sqliteStorage->createTable("fullcache");
    sqliteStorage->updateObject("fullcache", m_fullCache->geocode(), m_dataJson);
}

void FullCacheRetriever::parseJson(const QJsonDocument &dataJsonDoc)
{
    m_dataJson = dataJsonDoc;
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
    QJsonArray  atts = cacheJson.value("attributes").toArray();

    QList<int> listAttributs ;
    QList<bool> listAttributsBool ;
    listAttributs .clear();
    listAttributsBool.clear();

    foreach ( const QJsonValue & att, atts)

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

    foreach (const QJsonValue &image , images)
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
    for (QJsonValue geocacheLog: geocacheLogs)
    {
        listLogs.append(smileys->replaceSmileyTextToImgSrc(geocacheLog["text"].toString()));
        listFindersDate.append(geocacheLog["loggedDate"].toString());

        QJsonObject finder = geocacheLog.toObject()["owner"].toObject();
        listFindersName.append(finder["username"].toString());
        listFindersCount.append(finder["findCount"].toInt());

        QJsonObject type = geocacheLog["geocacheLogType"].toObject();
        listLogsType.append(m_fullCache->m_mapLogType.key(type["id"].toInt()));

        QJsonArray logsImage = geocacheLog["images"].toArray();
        for (QJsonValue logImage: logsImage)
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
    QList<double> listWptsLat ;
    QList<double> listWptsLon ;
    QList<QString> listWptsComment ;

    listWptsDescription.clear();
    listWptsName.clear();
    listWptsLat.clear();
    listWptsLon.clear();
    listWptsComment.clear();
    for (QJsonValue waypoint: cacheJson["additionalWaypoints"].toArray())
    {
        listWptsDescription.append(waypoint["name"].toString());
        listWptsName.append(waypoint["typeName"].toString());

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
    m_fullCache->setWptsLat(listWptsLat);
    m_fullCache->setWptsLon(listWptsLon);
    m_fullCache->setWptsComment(listWptsComment);

    // UserWaypoints
    QList<QString> listUserWptsDescription ;
    QList<bool> listUserWptsCorrectedCoordinates ;
    QList<double> listUserWptsLat ;
    QList<double> listUserWptsLon ;
    QList<QString> listUserWptsCode ;

    listUserWptsDescription.clear();
    listUserWptsCorrectedCoordinates.clear();
    listUserWptsLat.clear();
    listUserWptsLon.clear();
    listUserWptsCode.clear(); ;

    for (QJsonValue userWaypoint: cacheJson["userWaypoints"].toArray())
    {
        listUserWptsDescription.append(userWaypoint["description"].toString());
        listUserWptsCorrectedCoordinates.append(userWaypoint["isCorrectedCoordinates"].toBool());
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
    m_fullCache->setUserWptsCorrectedCoordinates(listUserWptsCorrectedCoordinates);
    m_fullCache->setUserWptsCode(listUserWptsCode);
    m_fullCache->setUserWptsLat(listUserWptsLat);
    m_fullCache->setUserWptsLon(listUserWptsLon);

    // Trackables: list of names and codes.
    QList<QString> listTrackableNames ;
    QList<QString> listTrackableCodes ;

    listTrackableNames.clear();
    listTrackableCodes.clear();
    for (QJsonValue travel: cacheJson["trackables"].toArray())
    {
        listTrackableNames.append(travel["name"].toString());
        listTrackableCodes.append(travel["referenceCode"].toString());
    }
    m_fullCache->setTrackableNames(listTrackableNames);
    m_fullCache->setTrackableCodes(listTrackableCodes);

    emit m_fullCache->registeredChanged();

    // request success
    emit requestReady();
}






