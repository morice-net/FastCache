#include "sendcachelog.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendCacheLog::SendCacheLog(QObject *parent)
    : QObject(parent)
    ,  m_state()

{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &SendCacheLog::onReplyFinished);
}

void SendCacheLog::cacheLog(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite)
{
    // Inform QML we are loading
    setState("loading");

    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc//CreateFieldNoteAndPublish?format=json");

    QJsonObject parameters;

    parameters.insert("AccessToken", QJsonValue(token));
    parameters.insert("CacheCode", QJsonValue(cacheCode));
    parameters.insert("WptLogTypeId", QJsonValue(logType));
    parameters.insert("UTCDateLogged", QJsonValue(date));
    parameters.insert("Note", QJsonValue(log));
    parameters.insert("PromoteToLog",QJsonValue(true));
    parameters.insert("EncryptLogText",QJsonValue(false));
    parameters.insert("FavoriteThisCache",QJsonValue(favorite));

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
            // Inform the QML that there is a loading error
            setState("error");
            return;
        }
        QJsonObject JsonObj = dataJsonDoc.object();
        QJsonObject statusJson = JsonObj["Status"].toObject();

        int status = statusJson["StatusCode"].toInt();
        if (status != 0) {
            // Inform the QML that there is an error
            setState("error");
            return ;
        }
    } else {
        qDebug() << "*** CacheLog ERROR ***\n" <<reply->errorString();
        // Inform the QML that there is an error
        setState("error");
        return;
    }
    // Inform the QML that there is no loading error
    setState("noError");
    return ;
}
QString SendCacheLog::state() const
{
    return m_state;
}

void SendCacheLog::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}

