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
        //Build url , add user waypoint or modifie coordinates
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
    } else  if(add == false && isCorrectedCoordinates == false){
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
    } else  if(add == false && isCorrectedCoordinates == true){
        //Build url,update modification of coordinates
        QString requestName = "geocaches/";
        requestName.append(code);
        requestName.append("/correctedcoordinates");
        requestName.append("?fields=referenceCode,isCorrectedCoordinates,coordinates");

        //Add parameters
        QJsonObject jsonCorrected;
        jsonCorrected.insert("latitude", QJsonValue::fromVariant(lat));
        jsonCorrected.insert("longitude", QJsonValue::fromVariant(lon));

        // Qbyte array
        QJsonDocument Doc(jsonCorrected);
        QByteArray coordinates = Doc.toJson();

        // Inform QML we are loading
        setState("loading");
        Requestor::sendPutRequest(requestName , coordinates ,token);
    }
}

void SendUserWaypoint::sendRequest(QString token , QString code)
{
    QString requestName;

    if(code.startsWith("UW")) {
        //Build url,delete userWaypoint
        requestName = "userwaypoints/";
        requestName.append(code);
    } else if(code.startsWith("GC")){
        //Build url,delete modification of coordinates
        requestName = "geocaches/";
        requestName.append(code);
        requestName.append("/correctedcoordinates");
    }
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
    QList<double> listUserWptsLat ;
    QList<double> listUserWptsLon;

    QJsonObject coord = userWaypoint["coordinates"].toObject();

    if(state() == "Created" && userWaypoint["isCorrectedCoordinates"].toBool() == false){
        //Add userWaypoint
        listUserWptsCode = m_fullCache->userWptsCode();
        listUserWptsCode.insert(0 , userWaypoint["referenceCode"].toString());
        m_fullCache->setUserWptsCode(listUserWptsCode);

        listUserWptsDescription = m_fullCache->userWptsDescription();
        listUserWptsDescription.insert(0 , userWaypoint["description"].toString());
        m_fullCache->setUserWptsDescription(listUserWptsDescription);

        listUserWptsLat = m_fullCache->userWptsLat();
        listUserWptsLat.insert(0 , coord["latitude"].toDouble());
        m_fullCache->setUserWptsLat(listUserWptsLat);

        listUserWptsLon = m_fullCache->userWptsLon();
        listUserWptsLon.insert(0 , coord["longitude"].toDouble());
        m_fullCache->setUserWptsLon(listUserWptsLon);

    } else if(state() == "Created" && userWaypoint["isCorrectedCoordinates"].toBool() == true){
        // Add a change to the coordinates
        m_fullCache->setCorrectedLat(coord["latitude"].toDouble());
        m_fullCache->setCorrectedLon(coord["longitude"].toDouble());
        m_fullCache->setCorrectedCode(userWaypoint["referenceCode"].toString());
        m_fullCache->setIsCorrectedCoordinates(true);

    }  else if(state() == "OK" && userWaypoint["isCorrectedCoordinates"].toBool() == false){
        //Update userWaypoint
        listUserWptsCode = m_fullCache->userWptsCode();
        for(int index=0 ; index<m_fullCache->userWptsCode().length() ; index++)
        {
            if(listUserWptsCode[index] == userWaypoint["referenceCode"].toString()){
                listUserWptsDescription = m_fullCache->userWptsDescription();
                listUserWptsDescription[index] = userWaypoint["description"].toString();
                m_fullCache->setUserWptsDescription(listUserWptsDescription);

                listUserWptsLat = m_fullCache->userWptsLat();
                listUserWptsLat[index] = coord["latitude"].toDouble();
                m_fullCache->setUserWptsLat(listUserWptsLat);

                listUserWptsLon = m_fullCache->userWptsLon();
                listUserWptsLon[index] = coord["longitude"].toDouble();
                m_fullCache->setUserWptsLon(listUserWptsLon);
            }
        }

    } else if(state() == "OK" && userWaypoint["isCorrectedCoordinates"].toBool() == true){
        // Update a change to the coordinates        
        m_fullCache->setCorrectedLat(coord["latitude"].toDouble());
        m_fullCache->setCorrectedLon(coord["longitude"].toDouble());
        m_fullCache->setIsCorrectedCoordinates(true);
    }
    return ;
}







