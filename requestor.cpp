#include "requestor.h"

Requestor::Requestor(QObject *parent)
    : QObject(parent)
    , m_state()
    , m_requestsLength(0)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
    m_networkManager->setTransferTimeout(m_timeOut);
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
    setRequestsLength(m_requests.size());
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
    setRequestsLength(m_requests.size());
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
    setRequestsLength(m_requests.size());
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
    setRequestsLength(m_requests.size());
    // In case we are not already processing a request, trigger it
    if (m_requests.size() == 1)
    {
        m_requests.first().process(m_networkManager);
    }
}

void Requestor::retryRequest(int delayMs)
{
    if (m_requests.isEmpty())
        return;

    AllRequest &req = m_requests.first();

    if (!req.canRetry())
    {
        qDebug() << "Max retries reached";
        setState("Retry Failed");
        return;
    }

    req.incrementRetry();

    QTimer::singleShot(delayMs, this, [this]() {
        if (!m_requests.isEmpty())
        {
            qDebug() << "Retrying request...";
            m_requests.first().process(m_networkManager);
        }
    });
}

void Requestor::finalizeRequest(QNetworkReply *reply)
{
    m_requests.takeFirst();
    setRequestsLength(m_requests.size());

    if (!m_requests.isEmpty())
    {
        m_requests.first().process(m_networkManager);
    }
    reply->deleteLater();
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    if (m_requests.isEmpty()) {
        reply->deleteLater();
        return;
    }

    QByteArray data = reply->readAll();
    QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);   

    // network errors
    if (reply->error() != QNetworkReply::NoError)
    {
        qDebug() << "Network error:" << reply->errorString();
        switch (reply->error())
        {
        case QNetworkReply::TimeoutError:
            setState("timeOutConnection");
            retryRequest(2000);
            reply->deleteLater();
            return;

        case QNetworkReply::HostNotFoundError:
        case QNetworkReply::ConnectionRefusedError:
            setState("Connection Error");
            break;

        default:
            setState("Network Error");
            break;
        }

        finalizeRequest(reply);
        return;
    }

    // code http
    int code = statusCode.toInt();
    if (code == 429)
    {
        // rate limit
        int retryAfter = reply->rawHeader("Retry-After").toInt();
        if (retryAfter <= 0) retryAfter = 5;
        qDebug() << "Rate limited, retry in" << retryAfter << "seconds";
        setState("Rate Limited");
        retryRequest(retryAfter * 1000);
        reply->deleteLater();
        return;
    }
    if (code >= 500)
    {
        setState("Server Error");
        retryRequest(3000);
        reply->deleteLater();
        return;
    }
    if (code == 401)
    {
        setState("Unauthorized");        
        finalizeRequest(reply);
        return;
    }
    if (code == 204)
    {
        setState("No Content");
        finalizeRequest(reply);
        return;
    }

    // json safe parse
    QJsonParseError error;
    QJsonDocument doc = QJsonDocument::fromJson(data, &error);

    if (error.error != QJsonParseError::NoError)
    {
        qDebug() << "JSON parse error:" << error.errorString();
        setState("Invalid JSON");
        finalizeRequest(reply);
        return;
    }    
    // success
    if (code == 200)
    {
        setState("OK");
        parseJson(doc);
    }
    else if (code == 201)
    {
        setState("Created");
        parseJson(doc);
    }
    // client error
    else if (code == 400) setState("Bad Request");
    else if (code == 403) setState("Forbidden");
    else if (code == 404) setState("Not Found");
    else if (code == 409) setState("Conflict");
    else if (code == 422) setState("Unprocessable Entity");
    else if(code >= 400) setState("Client Error");

    finalizeRequest(reply);
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




