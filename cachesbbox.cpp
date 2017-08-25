#include "cachesbbox.h"

#include <QJsonDocument>
#include <QJsonObject>

CachesBBox::CachesBBox(QObject *parent)
    : Requestor(parent)
{
}

CachesBBox::~CachesBBox()
{
}

/** Data retriever using the requestor **/

void CachesBBox::sendRequest(QString token, double latBottomRight, double lonBottomRight , double latTopLeft , double lonTopLeft)
{
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

    bottomRight.insert("Latitude", QJsonValue(latBottomRight));
    bottomRight.insert("Longitude", QJsonValue(lonBottomRight));
    topLeft.insert("Latitude", QJsonValue(latTopLeft));
    topLeft.insert("Longitude", QJsonValue(lonTopLeft));

    viewport.insert("BottomRight", QJsonValue(bottomRight));
    viewport.insert("TopLeft", QJsonValue(topLeft));

    parameters.insert("Viewport", QJsonValue(viewport));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() << QJsonDocument(parameters).toJson(QJsonDocument::Indented);

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
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
    } else {
        return;
    }

    if (dataJsonDoc.isNull()) {
        return;
    }

    return;
}


