#include "senduserwaypoint.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendUserWaypoint::SendUserWaypoint(Requestor *parent)
    : Requestor (parent)
{
}

SendUserWaypoint::~SendUserWaypoint()
{
}

void SendUserWaypoint::sendRequest(QString token , QString geocacheCode , double lat, double lon ,bool isCorrectedCoordinates , QString description)
{
    //Build url
    QString requestName = "userwaypoints?fields=referenceCode";

    //Add parameters
    QJsonObject userWaypoint;

    userWaypoint.insert("geocacheCode", QJsonValue(geocacheCode));
    userWaypoint.insert("isCorrectedCoordinates", QJsonValue(isCorrectedCoordinates));
    userWaypoint.insert("description", QJsonValue(description));

    QJsonObject coordinates;
    coordinates.insert("latitude", lat);
    coordinates.insert("longitude", lon);
    userWaypoint.insert("coordinates", coordinates);

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPostRequest(requestName,userWaypoint,token);
}

void SendUserWaypoint::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject userWaypoint;
    userWaypoint = dataJsonDoc.object();
    qDebug() << "*** UserWaypoint**\n" << userWaypoint;
    return ;
}

