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

    private:
        RequestType m_requestType;
        QNetworkRequest m_request;
        QByteArray m_data;
};

#endif // ALLREQUEST_H
