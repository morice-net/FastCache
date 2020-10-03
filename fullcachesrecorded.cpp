#include "fullcachesrecorded.h"
#include "constants.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullCachesRecorded::FullCachesRecorded(Requestor *parent)
    : Requestor (parent)
{
}

FullCachesRecorded::~FullCachesRecorded()
{
}

void FullCachesRecorded::sendRequest(QString token , QList<QString> geocodes , QList<bool> cachesLists , SQLiteStorage *sqliteStorage)
{
    m_cachesLists = cachesLists;
    m_sqliteStorage = sqliteStorage;

    //Build url
    QString requestName = "geocaches?referenceCodes=" ;

    for(int i = 0; i < geocodes.size()-1 ; ++i)
    {
        requestName.append(geocodes[i]);
        requestName.append(",");
    }
    requestName.append(geocodes[geocodes.size()-1]);

    requestName.append("&lite=false");

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

void FullCachesRecorded::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonDocument jsonDoc ;
    QJsonArray dataJsonArray = dataJsonDoc.array();
    QString geocode;

    for (QJsonValue fullCache: dataJsonArray)
    {
        geocode = fullCache["referenceCode"].toString();
        jsonDoc.setObject(fullCache.toObject());
        m_sqliteStorage->updateObject("fullcache", geocode,  m_replaceImageInText->replaceUrlImageToPath(geocode , jsonDoc  ,true));
        m_sqliteStorage->updateListWithGeocode("cacheslists" , m_cachesLists , geocode , false);
    }
    m_sqliteStorage->numberCachesInLists("cacheslists");
}
