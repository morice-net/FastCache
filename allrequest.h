#ifndef ALLREQUEST_H
#define ALLREQUEST_H

#include <QNetworkAccessManager>
#include <QNetworkRequest>

class AllRequest
{
public:
    enum RequestType
    {
        Get,
        Post,
        Put,
        Delete
    };

    AllRequest(RequestType type, QNetworkRequest request, QByteArray data = QByteArray());
    void process(QNetworkAccessManager *networkManager);

    bool canRetry() const;
    void incrementRetry();
    int retryCount() const;

    private:
        RequestType m_requestType;
        QNetworkRequest m_request;
        QByteArray m_data;

        int m_retryCount = 0;
        int m_maxRetries = 3;
};

#endif // ALLREQUEST_H
