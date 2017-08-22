#include "requestor.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>

Requestor::Requestor(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager();
    connect( m_networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);
}


