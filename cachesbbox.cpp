#include "cachesbbox.h"

#include <QMetaObject>
#include <QMetaProperty>
#include <QJsonDocument>
#include <QJsonObject>

#include "cache.h"

CachesBBox::CachesBBox(QObject *parent)
    : Requestor(parent), m_latBottomRight(0), m_lonBottomRight(0), m_latTopLeft(0), m_lonTopLeft(0)
{
}

CachesBBox::~CachesBBox()
{
}

void CachesBBox::sendRequest(QString token)
{
    if(m_latBottomRight == 0 && m_lonBottomRight == 0 && m_latTopLeft ==  0 && m_lonTopLeft == 0) {
        return;
    }

    // lat, lon on format E6.

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//SearchForGeocaches?format=json");

    QJsonObject parameters;
    QJsonObject viewport;
    QJsonObject bottomRight;
    QJsonObject topLeft;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(true));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));

    bottomRight.insert("Latitude", QJsonValue(m_latBottomRight));
    bottomRight.insert("Longitude", QJsonValue(m_lonBottomRight));
    topLeft.insert("Latitude", QJsonValue(m_latTopLeft));
    topLeft.insert("Longitude", QJsonValue(m_lonTopLeft));

    viewport.insert("BottomRight", QJsonValue(bottomRight));
    viewport.insert("TopLeft", QJsonValue(topLeft));

    parameters.insert("Viewport", QJsonValue(viewport));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cachesbboxJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);

    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));

}


void CachesBBox::sendRequestMore(QString token)
{
    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//SearchForGeocaches?format=json");

    QJsonObject parameters;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("IsLite", QJsonValue(true));
    parameters.insert("MaxPerPage", QJsonValue(MAX_PER_PAGE));
    parameters.insert("GeocacheLogCount", QJsonValue(GEOCACHE_LOG_COUNT));
    parameters.insert("TrackableLogCount", QJsonValue(TRACKABLE_LOG_COUNT));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() << QJsonDocument(parameters).toJson(QJsonDocument::Indented);

    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void CachesBBox::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "*** CachesBBox ***\n" << reply->readAll();
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());


        // PARSING LOOP START

  //      QVariant readValue;
    //    Cache cache;
      //  const QMetaObject *metaObj = cache.metaObject();

     //   qDebug() << "properties: ";
    //    for (int i = metaObj->propertyOffset(); i < metaObj->propertyCount(); ++i) {
      //      qDebug() << metaObj->property(i).name() << " " << metaObj->property(i).typeName();
        //    cache.setProperty(metaObj->property(i).name(), readValue);
   //     }
   //     m_caches.append(cache);

        // PARSING LOOP END

    } else {
        return;
    }

    if (dataJsonDoc.isNull()) {
        return;
    }

    return;
}

double CachesBBox::lonTopLeft() const
{
    return m_lonTopLeft;
}

void CachesBBox::setLonTopLeft(double lonTopLeft)
{
    m_lonTopLeft = lonTopLeft;
    emit lonTopLeftChanged();
}

double CachesBBox::latTopLeft() const
{
    return m_latTopLeft;
}

void CachesBBox::setLatTopLeft(double latTopLeft)
{
    m_latTopLeft = latTopLeft;
    emit latTopLeftChanged();
}

double CachesBBox::lonBottomRight() const
{
    return m_lonBottomRight;
}

void CachesBBox::setLonBottomRight(double lonBottomRight)
{
    m_lonBottomRight = lonBottomRight;
    emit lonBottomRightChanged();
}

double CachesBBox::latBottomRight() const
{
    return m_latBottomRight;
}

void CachesBBox::setLatBottomRight(double latBottomRight)
{
    m_latBottomRight = latBottomRight;
    emit latBottomRightChanged();
}


