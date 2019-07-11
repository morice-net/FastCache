#include "requestor.h"

Requestor::Requestor(QObject *parent)
    : QObject(parent)
    , m_state()
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
}

void Requestor::sendRequest(QString token)
{
}

void Requestor::sendPostRequest(const QString &requestName, const QJsonObject &parameters, QString token)
{
    QUrl uri("https://api.groundspeak.com/v1.0/" + requestName);
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
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    m_networkManager->get(request);
}

void Requestor::sendPutRequest(const QString &requestName , const QByteArray &data , QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    m_networkManager->put(request,data);
}

void Requestor::sendDeleteRequest(const QString &requestName ,  QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    m_networkManager->deleteResource(request);
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    QVariant   statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

    switch(statusCode.toInt()){
    case 200:
        setState("OK");
        parseJson(QJsonDocument::fromJson(reply->readAll()));
        break;
    case 201:
        setState("Created");
        parseJson(QJsonDocument::fromJson(reply->readAll()));
        break;
    case 204:
        setState("No Content");
        break;
    case 400:
        setState("Bad Request");
        break;
    case 401:
        setState("Unauthorized");
        break;
    case 403:
        setState("Forbidden");
        break;
    case 404:
        setState("Not Found");
        break;
    case 409:
        setState("Conflict");
        break;
    case 422:
        setState("Unprocessable Entity");
        break;
    case 429:
        setState("Too Many Requests");
        break;
    case 500:
        setState("Internal Server Error");
        break;
    default:
        break;
    }
}

QString Requestor::state() const
{
    return m_state;
}

void Requestor::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}
