#include "sendcachenote.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>

SendCacheNote::SendCacheNote(Requestor *parent)
    : Requestor (parent)
{
}

SendCacheNote::~SendCacheNote()
{
}

void SendCacheNote::sendRequest(QString token ,QString cacheCode, QString note)
{
    //Build url
    QString requestName = "geocaches/";
    requestName.append(cacheCode);
    requestName.append("/notes");

    if(!note.isEmpty()){
        //Add note
        QJsonObject jsonNote;
        jsonNote.insert("note", QJsonValue::fromVariant(note));
        QJsonDocument Doc(jsonNote);
        QByteArray data = Doc.toJson();

        // Inform QML we are loading
        setState("loading");
        Requestor::sendPutRequest(requestName , data,token);

    } else {
        // Inform QML we are loading
        setState("loading");
        Requestor::sendDeleteRequest(requestName,token);
    }
}

void SendCacheNote::parseJson(const QJsonDocument &dataJsonDoc)
{
    if (dataJsonDoc.isNull()) {
        // Inform the QML that there is a loading error
        setState("error");
        return;
    }

    // Inform the QML that there is no loading error
    setState("noError");
}

