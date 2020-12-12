#include "sendimageslog.h"

#include <QImage>
#include <QJsonObject>
#include <QBuffer>
#include <QJsonArray>

SendImagesLog::SendImagesLog(Requestor *parent)
    : Requestor (parent)
{
}

SendImagesLog::~SendImagesLog()
{
}

QString SendImagesLog::imageToBase64(const QString &fileUrl, const int &rotation)
{
    qDebug()<<fileUrl;
    QImage image(fileUrl);
    if(image.isNull()) {
        return "";
    } else {
        // rotation.
        QTransform rotating;
        rotating.rotate(rotation);
        image = image.transformed(rotating);

        QByteArray ba;
        QBuffer buffer(&ba);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "JPEG");
        QByteArray base64 = ba.toBase64();
        buffer.close();
        return base64;
    }
}

QJsonDocument SendImagesLog::makeJsonSendImagesLog(const QList<QString> &list )
{
    QJsonArray imagesLog;
    QJsonObject item;
    QString   imageUrl;
    QString   imageRotation;
    QString   imageDescription;

    for(int i = 0; i < list.size(); ++i)
    {
        imageUrl = list[i].split(',')[0];
        imageRotation = list[i].split(',')[1];
        imageDescription = list[i].mid(imageUrl.length() + imageRotation.length() + 2);

        item.insert("imageUrl", QJsonValue(imageUrl));
        item.insert("imageRotation", QJsonValue(imageRotation));
        item.insert("imageDescription", QJsonValue(imageDescription));
        imagesLog.push_back(QJsonValue(item));
    }
    QJsonObject doc;
    doc.insert("array", QJsonValue(imagesLog));
    QJsonDocument logDoc(doc);
    return logDoc;
}

void SendImagesLog::sendRequest(QString token , QString codeLog, QString description  , QString fileUrl, int rotation)
{
    //Build url
    QString requestName = "geocachelogs/" + codeLog + "/images?fields=url";

    //Add parameters
    QJsonObject image;
    image.insert("description", QJsonValue(description));
    image.insert("base64ImageData", QJsonValue(imageToBase64(fileUrl, rotation)));

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




