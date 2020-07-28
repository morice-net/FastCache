#include "replaceimageintext.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QDebug>

ReplaceImageInText::ReplaceImageInText(ImageDownloader *parent)
    : ImageDownloader(parent)
{
}

ReplaceImageInText::~ReplaceImageInText()
{
}

void ReplaceImageInText::replaceUrlImageToPath(const QString &geocode , const QJsonDocument &dataJsonDoc)
{
    QRegExp rx("(https?://\\S+(\\.jpg|\\.jpeg|\\.gif|\\.png))" , Qt::CaseInsensitive );

    QDir dir("./ImagesRecorded/" + geocode);
    if (!dir.exists())
        dir.mkpath(".");

    int pos = 0;
    int i = 1;
    QString path = "";
    QString url = "";

    QJsonObject cacheJson = dataJsonDoc.object();
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
}

