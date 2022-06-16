#include "fullcachesrecorded.h"
#include "constants.h"

#include <QtMath>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullCachesRecorded::FullCachesRecorded(Requestor *parent)
    : Requestor (parent)
    , m_userName("")
{
    m_getUserGeocacheLogs = new GetUserGeocacheLogs();
}

FullCachesRecorded::~FullCachesRecorded()
{
    delete m_getUserGeocacheLogs;
}

void FullCachesRecorded::sendRequest(QString token , QList<QString> geocodes , QList<bool> cachesLists , SQLiteStorage *sqliteStorage)
{
    m_tokenTemp = token;

    m_cachesLists = cachesLists;
    m_sqliteStorage = sqliteStorage;
    int maxFullCachesPerPages = 50;
    int numberPages = (int) qCeil((double) geocodes.length()/maxFullCachesPerPages);
    QList<QString> geocodesPage ;

    for(int number = 0; number < numberPages ; ++number)
    {
        geocodesPage = extract(geocodes, number*maxFullCachesPerPages, maxFullCachesPerPages);

        //Build url
        QString requestName = "geocaches?referenceCodes=" ;
        for(int i = 0; i < geocodesPage.size()-1 ; ++i)
        {
            requestName.append(geocodesPage[i]);
            requestName.append(",");
        }
        requestName.append(geocodesPage[geocodesPage.size()-1]);

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
}

void FullCachesRecorded::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonDocument jsonDoc ;
    QJsonArray dataJsonArray = dataJsonDoc.array();
    QString geocode;
    QString name;
    QString type;
    QString size;
    double difficulty;
    double terrain;
    double lat;
    double lon;
    bool found;
    bool own;

    for (const QJsonValue &fullCache: qAsConst(dataJsonArray))
    {
        geocode = fullCache["referenceCode"].toString();
        difficulty = fullCache["difficulty"].toDouble();
        terrain = fullCache["terrain"].toDouble();
        name = fullCache["name"].toString();
        if(fullCache["ownerAlias"].toString() == userName()) {
            own = true;
        } else {
            own = false;
        }

        QJsonObject v1 = fullCache["geocacheType"].toObject();
        type = CACHE_TYPE_MAP.key(v1["id"].toInt());

        v1 = fullCache["userData"].toObject();
        if(v1["foundDate"].isNull()){
            found = false;
        } else {
            found = true;
        }

        v1 = fullCache["geocacheSize"].toObject();
        size = CACHE_SIZE_MAP.key(v1["id"].toInt());

        // coordinates
        v1 = fullCache["userData"].toObject();
        if(v1["correctedCoordinates"].isNull()){
            v1 = fullCache["postedCoordinates"].toObject();
            lat = v1["latitude"].toDouble();
            lon = v1["longitude"].toDouble();
        }  else {
            QJsonObject  v2 = v1["correctedCoordinates"].toObject();
            lat = v2["latitude"].toDouble();
            lon =v2["longitude"].toDouble();
        }
        jsonDoc.setObject(fullCache.toObject());
        m_sqliteStorage->updateFullCacheColumns("fullcache", geocode, name, type, size, difficulty, terrain, lat, lon, found, own,
                                                m_replaceImageInText->replaceUrlImageToPath(geocode , jsonDoc  , true) , QJsonDocument());
        m_getUserGeocacheLogs->sendRequest(m_tokenTemp , geocode); // download user logs from a cache
        m_sqliteStorage->updateListWithGeocode("cacheslists" , m_cachesLists , geocode , false);
    }
    m_sqliteStorage->numberCachesInLists("cacheslists");
}

QJsonDocument FullCachesRecorded::markFoundInJson(const QJsonDocument &dataJsonDoc, const QString &date, const bool &favorited)
{
    QJsonDocument jsonDoc = dataJsonDoc;
    QJsonObject cacheJson = jsonDoc.object();
    QJsonObject user = cacheJson["userData"].toObject();

    if(user["foundDate"].isNull()){
        user.insert("foundDate", QJsonValue(date));
        user.insert("isFavorited", QJsonValue(favorited));
        cacheJson.insert("userData", QJsonValue::fromVariant(user));
        jsonDoc.setObject(cacheJson);
        qDebug()<<jsonDoc;
    }
    return jsonDoc;
}

QList<QString> FullCachesRecorded::extract(const QList<QString> &list, const int &begin, const int &blockLength)
{
    QList<QString> build;
    if(list.isEmpty())
        return build;
    for(int i = begin; i < begin + blockLength ; ++i){
        if(i >= list.length())
            return build;
        build.append(list[i]);
    }
    return  build;
}

void FullCachesRecorded::updateReplaceImageInText(ReplaceImageInText *replace)
{
    m_replaceImageInText = replace;
}

/** Getters & Setters **/

QString FullCachesRecorded::userName() const
{
    return m_userName;
}

void FullCachesRecorded::setUserName(QString &name)
{
    m_userName = name;
    emit userNameChanged();
}
