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
    QString requestName = "userwaypoints?fields=referenceCode,description,isCorrectedCoordinates,coordinates";

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

void SendUserWaypoint::sendRequest(QString token , QString uwCode)
{
    //Build url
    QString requestName = "userwaypoints/";
    requestName.append(uwCode);

    // Inform QML we are loading
    setState("loading");
    Requestor::sendDeleteRequest(requestName,token);
}

void SendUserWaypoint::updateFullCache(FullCache *fullCache)
{
    m_fullCache = fullCache;
}

void SendUserWaypoint::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject userWaypoint;
    userWaypoint = dataJsonDoc.object();
    qDebug() << "*** UserWaypoint**\n" << userWaypoint;

    QList<QString> listUserWptsCode ;
    listUserWptsCode = m_fullCache->userWptsCode();
    listUserWptsCode.insert(0 , userWaypoint["referenceCode"].toString());
    m_fullCache->setUserWptsCode(listUserWptsCode);

    QList<QString> listUserWptsDescription ;
    listUserWptsDescription = m_fullCache->userWptsDescription();
    listUserWptsDescription.insert(0 , userWaypoint["description"].toString());
    m_fullCache->setUserWptsDescription(listUserWptsDescription);

    QList<bool> listUserWptsCorrectedCoordinates ;
    listUserWptsCorrectedCoordinates = m_fullCache->userWptsCorrectedCoordinates();
    listUserWptsCorrectedCoordinates.insert(0 , userWaypoint["isCorrectedCoordinates"].toBool());
    m_fullCache->setUserWptsCorrectedCoordinates(listUserWptsCorrectedCoordinates);

    QJsonObject coord = userWaypoint["coordinates"].toObject();
    QList<double> listUserWptsLat ;
    listUserWptsLat = m_fullCache->userWptsLat();
    listUserWptsLat.insert(0 , coord["latitude"].toDouble());
    m_fullCache->setUserWptsLat(listUserWptsLat);

    QList<double> listUserWptsLon;
    listUserWptsLon = m_fullCache->userWptsLon();
    listUserWptsLon.insert(0 , coord["longitude"].toDouble());
    m_fullCache->setUserWptsLon(listUserWptsLon);

    emit requestReady();
    return ;
}





