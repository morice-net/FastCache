#include "fullcache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>


FullCache::FullCache(Cache *parent):  Cache (parent)
  ,  m_attributes(QList<int>())
  ,  m_attributesBool(QList<bool>())
  ,  m_state()

{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &FullCache::onReplyFinished);
}

void FullCache::sendRequest( QString token)
{
    // Inform QML we are loading
    setState("loading");

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//SearchForGeocaches?format=json");

    QJsonObject parameters;
    QJsonObject geocacheCode;
    QJsonArray geocachesCodes;

    geocachesCodes.append(FullCache::geocode());
    geocacheCode.insert("CacheCodes",QJsonValue(geocachesCodes));

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(false));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));
    parameters.insert("CacheCode", QJsonValue(geocacheCode));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cacheJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void FullCache::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** Cache ***\n" <<dataJsonDoc ;
        if (dataJsonDoc.isNull()) {
            return;
        }
        QJsonObject JsonObj = dataJsonDoc.object();
        QJsonValue value = JsonObj.value("Geocaches");
        QJsonArray caches = value.toArray();

        int lengthCaches = caches.size();
        if (lengthCaches == 0) {
            return ;
        }

        foreach ( const QJsonValue & v, caches)
        {
            setArchived(v.toObject().value("Archived").toBool());
            setDisabled(v.toObject().value("Available").toBool());

            QJsonObject v1 = v.toObject().value("Owner").toObject();
            QString owner = v1.value("UserName").toString();
            setOwner(owner);

            QString date(v.toObject().value("DateCreated").toString());
            setDate(date);

            QJsonObject v2 = v.toObject().value("CacheType").toObject();
            int cacheTypeId= v2.value("GeocacheTypeId").toInt();
            setType(cacheTypeId);

            QString code(v.toObject().value("Code").toString());
            setGeocode(code);

            QJsonObject v3 = v.toObject().value("ContainerType").toObject();
            int cacheSizeId= v3.value("ContainerTypeId").toInt();
            setSize(cacheSizeId);

            setDifficulty(v.toObject().value("Difficulty").toDouble());
            setFavoritePoints(v.toObject().value("FavoritePoints").toInt());
            setLat(v.toObject().value("Latitude").toDouble());
            setLon(v.toObject().value("Longitude").toDouble());

            setName(v.toObject().value("Name").toString());

            setTrackableCount(v.toObject().value("TrackableCount").toInt());
            setFound(v.toObject().value("HasbeenFoundbyUser").toBool());
            setTerrain(v.toObject().value("Terrain").toDouble());

            // Attributes of cache.
            m_attributes.clear();
            m_attributesBool.clear();

            QJsonArray  atts = v.toObject().value("Attributes").toArray();
            foreach ( const QJsonValue & att, atts)
            {
                m_attributes.append(att.toObject().value("AttributeTypeID").toInt());
                m_attributesBool.append(att.toObject().value("IsOn").toBool());
            }
            qDebug() << "*** attributs**\n" <<m_attributes ;
            qDebug() << "*** attributsBool**\n" <<m_attributesBool ;
            emit attributesChanged();
            emit attributesBoolChanged();
        }

    }   else {
        qDebug() << "*** Cache ERROR ***\n" <<reply->errorString() ;
        return;
    }

    // Inform the QML we are loaded
    setState("loaded");
    return;
}

QList<int> FullCache::attributes() const
{
    return  m_attributes;
}

void FullCache::setAttributes(const QList<int> &attributes)
{
    m_attributes = attributes;
    emit attributesChanged();
}

QList<bool> FullCache::attributesBool() const
{
    return  m_attributesBool;
}

void FullCache::setAttributesBool(const QList<bool> &attributesBool)
{
    m_attributesBool = attributesBool;
    emit attributesBoolChanged();
}

QString FullCache::state() const
{
    return m_state;
}

void FullCache::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}




