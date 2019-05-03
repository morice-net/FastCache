#include "sendcachenote.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendCacheNote::SendCacheNote(QObject *parent)
    : QObject(parent)
    ,  m_state()

{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &SendCacheNote::onReplyFinished);
}

void SendCacheNote::updateCacheNote(QString token ,QString cacheCode, QString note)
{    
    // Inform QML we are loading
    setState("loading");

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//UpdateCacheNote?format=json");

    QJsonObject parameters;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("CacheCode", QJsonValue(cacheCode));
    parameters.insert("Note", QJsonValue(note));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cachesJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void SendCacheNote::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;

    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** CacheNote ***\n" <<dataJsonDoc ;

        if (dataJsonDoc.isNull()) {
            return;
        }
    }

    // Inform the QML we are loaded
    setState("loaded");

    return ;
}

QString SendCacheNote::state() const
{
    return m_state;
}

void SendCacheNote::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}
