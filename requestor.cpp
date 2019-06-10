#include "requestor.h"

Requestor::Requestor(QObject *parent)
    : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
}

void Requestor::sendRequest(const QString &requestName, const QJsonObject &parameters)
{
    QUrl uri("https://api.groundspeak.com/LiveV6/geocaching.svc/" + requestName + "?format=json");
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    qDebug() << QJsonDocument(parameters).toJson(QJsonDocument::Indented);

    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        parseJson(QJsonDocument::fromJson(reply->readAll()));
    } else {
        qDebug() << reply->errorString();
    }
}
