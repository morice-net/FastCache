#include "sendimageslog.h"

#include <QFile>
#include <QJsonObject>

SendImagesLog::SendImagesLog(Requestor *parent)
    : Requestor (parent)
{
}

SendImagesLog::~SendImagesLog()
{
}

QString SendImagesLog::imageToBase64(const QString &fileUrl)
{
    QFile image(fileUrl);
    image.open(QIODevice::ReadOnly);
    QByteArray byteArray = image.readAll();
    return byteArray.toBase64();
}

void SendImagesLog::sendRequest(QString token , QString codeLog, QString description  , QString fileUrl)
{
    //Build url
    QString requestName = "geocachelogs/" + codeLog + "/images";

    //Add parameters
    QJsonObject image;

    image.insert("description", QJsonValue(description));
    image.insert("base64ImageData", QJsonValue(imageToBase64(fileUrl)));

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPostRequest(requestName,image,token);
}

void SendImagesLog::parseJson(const QJsonDocument &dataJsonDoc)
{
}




