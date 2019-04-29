#include "sendcachelog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendCacheLog::SendCacheLog(QObject *parent)
    : QObject(parent)

{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &SendCacheLog::onReplyFinished);
}


void SendCacheLog::cacheLog(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite)
{
    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//CreateFieldNoteAndPublish?format=json");

    QJsonObject parameters;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("CacheCode", QJsonValue(cacheCode));
    parameters.insert("WptLogTypeId", QJsonValue(logType));
    parameters.insert("UTCDateLogged", QJsonValue(date));
    parameters.insert("Note", QJsonValue(log));
    parameters.insert("PromoteToLog",QJsonValue(true));
    parameters.insert("EncryptLogText",QJsonValue(false));
    parameters.insert("FavoriteThisCache",QJsonValue(false));

    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() <<"cachesJson:" <<QJsonDocument(parameters).toJson(QJsonDocument::Indented);
    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void SendCacheLog::onReplyFinished(QNetworkReply *reply)
{
    QJsonDocument dataJsonDoc;
    if (reply->error() == QNetworkReply::NoError) {
        dataJsonDoc = QJsonDocument::fromJson(reply->readAll());
        qDebug() << "*** CacheLog ***\n" <<dataJsonDoc ;

        if (dataJsonDoc.isNull()) {
            return;
        }
    }
    return ;
}

