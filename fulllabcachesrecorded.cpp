#include "fulllabcachesrecorded.h"
#include "qjsonarray.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

FullLabCachesRecorded::FullLabCachesRecorded(Requestor *parent)
    : Requestor (parent)
{
}

FullLabCachesRecorded::~FullLabCachesRecorded()
{
}

void FullLabCachesRecorded::updateReplaceImageInText(ReplaceImageInText *replace)
{
    m_replaceImageInText = replace;
}

void FullLabCachesRecorded::sendRequest(QString token , QList<QString> geocodes , QList<double> latitudes , QList<double> longitudes
                                        , QList<bool> cachesLists , SQLiteStorage *sqliteStorage)
{
    m_tokenTemp = token;
    m_cachesLists = cachesLists;
    m_sqliteStorage = sqliteStorage;

    for(int i = 0; i < geocodes.length() ; ++i)
    {
        //Build url for get adventure
        QString requestName = "adventures/" + geocodes[i] ;
        qDebug() << "URL(get adventure): " << requestName ;
        // Inform QML we are loading
        setState("loading");
        Requestor::sendGetRequest(requestName , token);

        //Build url for search
        requestName = "adventures/search?";
        // create Center , radius
        requestName.append("q=location:[" + QString::number(latitudes[i]) + "," + QString::number(longitudes[i]) + "]%2Bradius:"+
                           QString::number(10) + "m");   // one lab cache on list
        // Fields
        requestName.append("&fields=id,keyImageUrl,title,location,ratingsAverage,ratingsTotalCount,stagesTotalCount,dynamicLink,isOwned,isCompleted");
        qDebug() << "URL(search): " << requestName ;
        // Inform QML we are loading
        setState("loading");
        Requestor::sendGetRequest(requestName , token);
    }
}

void FullLabCachesRecorded::parseJson(const QJsonDocument &dataJsonDoc)
{    
    QString geocode ;
    QString name;
    QString type = "labCache";
    QString size = "Virtuelle";
    double difficulty = 0;
    double terrain = 0;
    double lat = 0;
    double lon = 0;
    bool found = false;
    bool own = false;
    double ratingsAverage = 0;
    int ratingsTotalCount = 0;
    int stagesTotalCount = 0;
    QString imageUrl;

    if(!dataJsonDoc.isArray()) {   // parsing get adventure        
        geocode = dataJsonDoc["id"].toString();
        m_sqliteStorage->updateFullCacheColumns("fullcache", geocode, name, type, size, difficulty, terrain, lat, lon, found, own, dataJsonDoc ,
                                                QJsonDocument());
        m_dataJson =  dataJsonDoc;
    } else {   // parsing search lab caches
        QJsonArray adventureLabCaches = dataJsonDoc.array();
        qDebug() << "adventureLabCachesArray: " << adventureLabCaches ;
        for(const QJsonValue &v : adventureLabCaches)  // one lab cache on list
        {
            geocode = v["id"].toString();
            name = v["title"].toString();
            own = v["isOwned"].toBool();
            found = v["isCompleted"].toBool();
            ratingsAverage = v["ratingsAverage"].toDouble();
            ratingsTotalCount = v["ratingsTotalCount"].toInt();
            stagesTotalCount = v["stagesTotalCount"].toInt();
            imageUrl = v["keyImageUrl"].toString();

            QJsonObject v1 = v["location"].toObject();
            lat = v1["latitude"].toDouble();
            lon =v1["longitude"].toDouble();            
        }
        QJsonObject cacheJson = m_dataJson.object();
        cacheJson.insert("title" , QJsonValue(name));
        cacheJson.insert("isOwned" , QJsonValue(own));
        cacheJson.insert("isCompleted" , QJsonValue(found));
        cacheJson.insert("ratingsAverage" , QJsonValue(ratingsAverage));
        cacheJson.insert("ratingsTotalCount" , QJsonValue(ratingsTotalCount));
        cacheJson.insert("stagesTotalCount" , QJsonValue(stagesTotalCount));
        cacheJson.insert("keyImageUrl" , QJsonValue(imageUrl));

        QJsonObject location = cacheJson["location"].toObject();
        location.insert("latitude" , QJsonValue(lat));
        location.insert("longitude" , QJsonValue(lon));
        cacheJson.insert("location" , QJsonValue::fromVariant(location));

        m_dataJson.setObject(cacheJson);
        m_sqliteStorage->updateFullCacheColumns("fullcache", geocode, name, type, size, difficulty, terrain, lat, lon, found, own,
                                                m_replaceImageInText->replaceUrlImageToPathLabCache(geocode , m_dataJson , true) ,
                                                QJsonDocument());
    }
    m_sqliteStorage->updateListWithGeocode("cacheslists" , m_cachesLists , geocode , false);
    m_sqliteStorage->numberCachesInLists("cacheslists");    
}






