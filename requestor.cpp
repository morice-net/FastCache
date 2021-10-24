#include "requestor.h"

Requestor::Requestor(QObject *parent)
    : QObject(parent)
    , m_state()
    , m_requestsLength(0)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
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
    // Store the request
    m_requests.append(AllRequest{AllRequest::Post, request, QJsonDocument(parameters).toJson(QJsonDocument::Compact)});
    // In case we are not already processing a request, trigger it
    if (m_requests.size() == 1)
    {
        m_requests.first().process(m_networkManager);
    }
}

void Requestor::sendGetRequest(const QString &requestName , QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    // Store the request
    m_requests.append(AllRequest{AllRequest::Get, request});
    // In case we are not already processing a request, trigger it
    if (m_requests.size() == 1)
    {
        m_requests.first().process(m_networkManager);
    }
}

void Requestor::sendPutRequest(const QString &requestName , const QByteArray &data , QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    // Store the request
    m_requests.append(AllRequest{AllRequest::Put, request, data});
    // In case we are not already processing a request, trigger it
    if (m_requests.size() == 1)
    {
        m_requests.first().process(m_networkManager);
    }
}

void Requestor::sendDeleteRequest(const QString &requestName ,  QString token)
{
    QUrl uri("https://api.groundspeak.com/v1/" + requestName);
    QNetworkRequest request;
    request.setUrl(uri);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString headerData = "bearer " + token;
    request.setRawHeader("Authorization", headerData.toLocal8Bit());
    // Store the request
    m_requests.append(AllRequest{AllRequest::Delete, request});
    // In case we are not already processing a request, trigger it
    if (m_requests.size() == 1)
    {
        m_requests.first().process(m_networkManager);
    }
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    if (m_requests.isEmpty())
        return;

    QVariant   statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

    // the current request is processed we can remove it from the list
    // we take it here because maybe if it fails we want to process it again or read the data to know what happened
    m_requests.takeFirst();
    emit requestsLengthChanged();

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
    // If we have some other request waiting we can trigger the next one
    if (m_requests.size() > 0) {
        m_requests.first().process(m_networkManager);
    }
}

/** Getters & Setters **/

QString Requestor::state() const
{
    return m_state;
}

void Requestor::setState(const QString &state)
{
    m_state = state;
    emit stateChanged();
}

int Requestor::requestsLength() const
{
    return m_requestsLength;
}

void Requestor::setRequestsLength(const int &requestsLength)
{
    m_requestsLength = requestsLength;
    emit requestsLengthChanged();
}


