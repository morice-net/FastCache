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

void SendUserWaypoint::sendRequest(QString token , QString code , double lat, double lon , bool isCorrectedCoordinates , QString description , bool add)
{
    if(add) {
        //Build url , add user waypoint
        QString requestName = "userwaypoints?fields=referenceCode,description,isCorrectedCoordinates,coordinates";

        //Add parameters
        QJsonObject userWaypoint;

        userWaypoint.insert("geocacheCode", QJsonValue(code));
        userWaypoint.insert("isCorrectedCoordinates", QJsonValue(isCorrectedCoordinates));
        userWaypoint.insert("description", QJsonValue(description));

        QJsonObject coordinates;
        coordinates.insert("latitude", lat);
        coordinates.insert("longitude", lon);
        userWaypoint.insert("coordinates", coordinates);

        // Inform QML we are loading
        setState("loading");
        Requestor::sendPostRequest(requestName,userWaypoint,token);
    } else {
        //Build url,update user waypoint
        QString requestName = "userwaypoints/";
        requestName.append(code);
        requestName.append("?fields=referenceCode,description,isCorrectedCoordinates,coordinates");

        //Add parameters
        QJsonObject coord;
        coord.insert("latitude", QJsonValue::fromVariant(lat));
        coord.insert("longitude", QJsonValue::fromVariant(lon));
        QJsonObject jsonUserWpt;
        jsonUserWpt.insert("referenceCode", QJsonValue::fromVariant(code));
        jsonUserWpt.insert("description", QJsonValue::fromVariant(description));
        jsonUserWpt.insert("isCorrectedCoordinates", QJsonValue::fromVariant(isCorrectedCoordinates));
        jsonUserWpt.insert("coordinates" , coord );
        jsonUserWpt.insert("geocacheCode", QJsonValue::fromVariant(m_fullCache->geocode()));

        // Qbyte array
        QJsonDocument Doc(jsonUserWpt);
        QByteArray log = Doc.toJson();

        // Inform QML we are loading
        setState("loading");
        Requestor::sendPutRequest(requestName , log ,token);
    }
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
    QList<QString> listUserWptsDescription ;
    QList<bool> listUserWptsCorrectedCoordinates ;
    QList<double> listUserWptsLat ;
    QList<double> listUserWptsLon;

    QJsonObject coord = userWaypoint["coordinates"].toObject();

    //Add userWaypoint
    if(state() == "Created"){
        listUserWptsCode = m_fullCache->userWptsCode();
        listUserWptsCode.insert(0 , userWaypoint["referenceCode"].toString());
        m_fullCache->setUserWptsCode(listUserWptsCode);

        listUserWptsDescription = m_fullCache->userWptsDescription();
        listUserWptsDescription.insert(0 , userWaypoint["description"].toString());
        m_fullCache->setUserWptsDescription(listUserWptsDescription);

        listUserWptsCorrectedCoordinates = m_fullCache->userWptsCorrectedCoordinates();
        listUserWptsCorrectedCoordinates.insert(0 , userWaypoint["isCorrectedCoordinates"].toBool());
        m_fullCache->setUserWptsCorrectedCoordinates(listUserWptsCorrectedCoordinates);

        listUserWptsLat = m_fullCache->userWptsLat();
        listUserWptsLat.insert(0 , coord["latitude"].toDouble());
        m_fullCache->setUserWptsLat(listUserWptsLat);

        listUserWptsLon = m_fullCache->userWptsLon();
        listUserWptsLon.insert(0 , coord["longitude"].toDouble());
        m_fullCache->setUserWptsLon(listUserWptsLon);
        emit requestReady();
        return ;
    }

    //Update userWaypoint
    if(state() == "OK"){
        for(int index=0 ; index<m_fullCache->userWptsCode().length() ; index++)
        {
            if(m_fullCache->userWptsCode()[index] == userWaypoint["referenceCode"].toString()){

                listUserWptsDescription = m_fullCache->userWptsDescription();
                listUserWptsDescription[index] = userWaypoint["description"].toString();
                m_fullCache->setUserWptsDescription(listUserWptsDescription);

                listUserWptsCorrectedCoordinates = m_fullCache->userWptsCorrectedCoordinates();
                listUserWptsCorrectedCoordinates[index] = userWaypoint["isCorrectedCoordinates"].toBool();
                m_fullCache->setUserWptsCorrectedCoordinates(listUserWptsCorrectedCoordinates);

                listUserWptsLat = m_fullCache->userWptsLat();
                listUserWptsLat[index] = coord["latitude"].toDouble();
                m_fullCache->setUserWptsLat(listUserWptsLat);

                listUserWptsLon = m_fullCache->userWptsLon();
                listUserWptsLon[index] = coord["longitude"].toDouble();
                m_fullCache->setUserWptsLon(listUserWptsLon);

                emit requestReady();
                return ;
            }
        }
    }
}







