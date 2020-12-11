#include "sendimageslog.h"

#include <QImage>
#include <QJsonObject>
#include <QBuffer>

SendImagesLog::SendImagesLog(Requestor *parent)
    : Requestor (parent)
{
}

SendImagesLog::~SendImagesLog()
{
}

QString SendImagesLog::imageToBase64(const QString &fileUrl)
{
    qDebug()<<fileUrl;
    QImage image(fileUrl);
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "JPEG");
    QByteArray base64 = ba.toBase64();
    buffer.close();
    return base64;
}

void SendImagesLog::sendRequest(QString token , QString codeLog, QString description  , QString fileUrl)
{
    //Build url
    QString requestName = "geocachelogs/" + codeLog + "/images?fields=url";

    //Add parameters
    QJsonObject image;
    image.insert("description", QJsonValue(description));
    image.insert("base64ImageData", QJsonValue(imageToBase64(fileUrl)));

    // Inform QML we are loading
    setState("loading");
    Requestor::sendPostRequest(requestName, image, token);
}

void SendImagesLog::parseJson(const QJsonDocument &dataJsonDoc)
{
    QJsonObject imageLogJson;
    imageLogJson = dataJsonDoc.object();
    qDebug() << "*** imageLogResponse**\n" << imageLogJson;
    return ;
}




