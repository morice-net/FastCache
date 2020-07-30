#include "replaceimageintext.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

ReplaceImageInText::ReplaceImageInText(ImageDownloader *parent)
    : ImageDownloader(parent)
{
}

ReplaceImageInText::~ReplaceImageInText()
{
}

QJsonDocument ReplaceImageInText::replaceUrlImageToPath(const QString &geocode , const QJsonDocument &dataJsonDoc)
{
    QJsonDocument jsonDoc = dataJsonDoc;
    QJsonObject cacheJson = jsonDoc.object();
    QRegExp rx("(https?://\\S+(\\.jpg|\\.jpeg|\\.gif|\\.png))" , Qt::CaseInsensitive );

    QDir dir("./ImagesRecorded/" + geocode);
    if (!dir.exists())
        dir.mkpath(".");

    // replace in "short description" of recorded cache
    int pos = 0;
    int i = 1;
    QString path = "";
    QString url = "";

    QString shortDescription = cacheJson["ShortDescription"].toString();
    while ((pos = rx.indexIn(shortDescription, pos)) != -1) {
        url = rx.cap(1);
        path = "./ImagesRecorded/" + geocode + "/ShortDescription#" + QString::number(i) + url.mid(url.lastIndexOf(".", -1),-1);
        qDebug()<< url;
        qDebug()<< path;
        shortDescription.replace(url , path);
        pos += rx.matchedLength();
        i += 1;
        downloadFile(QUrl(url), "", path);
    }
    // replace in "long description" of recorded cache
    pos = 0;
    i = 1;
    path = "";
    url = "";

    QString longDescription = cacheJson["longDescription"].toString();
    while ((pos = rx.indexIn(longDescription, pos)) != -1) {
        url = rx.cap(1);
        path = "./ImagesRecorded/" + geocode + "/longDescription#" + QString::number(i) + url.mid(url.lastIndexOf(".", -1),-1);
        qDebug()<< url;
        qDebug()<< path;
        longDescription.replace(url , path);
        pos += rx.matchedLength();
        i += 1;
        downloadFile(QUrl(url), "", path);
    }

    // replace in "images" of recorded cache
    i = 1;
    path = "";
    url = "";

    QJsonArray images = cacheJson["images"].toArray();
    foreach (const QJsonValue &image , images)
    {
        url = image["url"].toString();
        path = "./ImagesRecorded/" + geocode + "/Images#" + QString::number(i) + url.mid(url.lastIndexOf(".", -1),-1);
        qDebug()<< url;
        qDebug()<< path;
        image.toString().replace(url , path);
        i += 1;
        downloadFile(QUrl(url), "", path);
    }
    return jsonDoc;
}

