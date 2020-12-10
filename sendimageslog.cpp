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
    qDebug()<<fileUrl;
    QFile image(fileUrl);
    if (image.open(QIODevice::ReadOnly)){
        qDebug()<<"Fichier ouvert";
        QByteArray byteArray = image.readAll();
        return byteArray.toBase64();
    } else {
        qDebug()<<"Le fichier n'es pas ouvert";
        return "";
    }
}

void SendImagesLog::sendRequest(QString token , QString codeLog, QString description  , QString fileUrl)
{
    //Build url
    QString requestName = "geocachelogs/" + codeLog + "/images";
    qDebug() << "URL:" << requestName ;

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




