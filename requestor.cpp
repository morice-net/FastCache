#include "requestor.h"

Requestor::Requestor(QObject *parent)
    : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
}

void Requestor::sendPostRequest(const QString &requestName, const QJsonObject &parameters, QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    qDebug() << QJsonDocument(parameters).toJson(QJsonDocument::Indented);

    m_networkManager->post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void Requestor::sendGetRequest(const QString &requestName , QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());

    m_networkManager->get(request);
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    if (reply->error() == QNetworkReply::NoError) {
        parseJson(QJsonDocument::fromJson(reply->readAll()));
    } else {
        qDebug() << reply->errorString();
    }
}
