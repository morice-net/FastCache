#include "fullcache.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>

FullCache::FullCache(Cache *parent):  Cache (parent),  m_state()
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &FullCache::onReplyFinished);
}

void FullCache::sendRequest( QString token){

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
    setState("loaded");

    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** Cache ***\n" <<dataJsonDoc ;
        if (dataJsonDoc.isNull()) {
            return;
        }
        QJsonObject JsonObj = dataJsonDoc.object();
        QJsonValue value = JsonObj.value("Geocache");
    }   else {
        qDebug() << "*** Cache ERROR ***\n" <<reply->errorString() ;
        return;
    }
    return;
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




