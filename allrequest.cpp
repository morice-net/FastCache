#include "allrequest.h"

AllRequest::AllRequest(AllRequest::RequestType type, QNetworkRequest request, QByteArray data)
    : m_requestType(type)
    , m_request(request)
    , m_data(data)
{

}

void AllRequest::process(QNetworkAccessManager *networkManager)
{
    switch (m_requestType) {
    case Get:
        networkManager->get(m_request);
        break;
    case Post:
        networkManager->post(m_request, m_data);
        break;
    case Put:
        networkManager->put(m_request, m_data);
        break;
    case Delete:
        networkManager->deleteResource(m_request);
        break;
    }
}
