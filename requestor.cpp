#include "requestor.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>

Requestor::Requestor(QObject *parent) : QObject(parent)
{

}

void Requestor::retrieveAccountInfo()
{
    QNetworkAccessManager networkManager;
    connect( &networkManager, &QNetworkAccessManager::finished, this, &Requestor::onReplyFinished);

    QUrl uri("https://www.geocaching.com/GetYourUserProfile?format=json");

    QJsonObject parameters;
    parameters.insert("AccessToken", QJsonValue("REMPLIR LES VALEURS ICI"));

    //TODO Add all parameters

    QNetworkRequest request;
    request.setUrl(uri);
    networkManager.post(request, QJsonDocument(parameters).toJson(QJsonDocument::Compact));
}

void Requestor::onReplyFinished(QNetworkReply *reply)
{
    //TODO Parse the reply READ makina corpus tutorial
}
