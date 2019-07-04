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
                       "geocacheSize,location,status,userData,shortDescription,longDescription,hints,attributes,containsHtml");
    // Expand
    requestName.append("&expand=geocachelogs:" + QString::number(GEOCACHE_LOG_COUNT) + ",trackables:" + QString::number(TRACKABLE_LOG_COUNT)
                       + ",geocachelog.images,userwaypoints,images");

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
    if (dataJsonDoc.isNull()) {
        // Inform the QML that there is a loading error
        setState("error");
        return;
    }

    QJsonObject cacheJson = dataJsonDoc.object();
    qDebug() << "cacheOject:" << cacheJson;

    // Inform the QML that there is no loading error
    setState("noError");

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

    m_fullCache->setTerrain(cacheJson["terrain"].toDouble());

    // Note
    m_fullCache->m_note = "";
    if (!cacheJson["note"].toString().isEmpty()) {
        m_fullCache->setNote(cacheJson["note"].toString());
    }

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

    // request success
    emit requestReady();
}






