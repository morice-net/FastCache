#include "replaceimageintext.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

ReplaceImageInText::ReplaceImageInText(Downloador *parent)
    : Downloador(parent)
{
}

ReplaceImageInText::~ReplaceImageInText()
{
}

QJsonDocument ReplaceImageInText::replaceUrlImageToPath(const QString &geocode , const QJsonDocument &dataJsonDoc , const bool &saveImage)
{
    QJsonDocument jsonDoc = dataJsonDoc;
    QJsonObject cacheJson = jsonDoc.object();
    static QRegularExpression rx("(https?://\\S+(\\.jpg|\\.jpeg|\\.gif|\\.png))" , QRegularExpression::CaseInsensitiveOption );

    QDir dir(m_dir + geocode);
    if (!dir.exists())
        dir.mkpath(".");

    // replace in "short description" of recorded cache
    int i = 1;
    QString path = "";
    QString url = "";
    QString shortDescription = cacheJson["ShortDescription"].toString();
    QRegularExpressionMatchIterator j = rx.globalMatch(shortDescription);

    while (j.hasNext()) {
        QRegularExpressionMatch match = j.next();
        url = match.captured(1);
        path = dir.absolutePath() + "/ShortDescription-" + QString::number(i) + url.mid(url.lastIndexOf(".", -1),-1);
        qDebug()<< url;
        qDebug()<< path;
        shortDescription.replace(url , "file:" + path);
        i += 1;
        if(saveImage)
            downloadFile(QUrl(url), "", path);
    }
    cacheJson.insert("ShortDescription"  , QJsonValue::fromVariant(shortDescription));

    // replace in "long description" of recorded cache
    i = 1;
    path = "";
    url = "";
    QString longDescription = cacheJson["longDescription"].toString();
    j = rx.globalMatch(longDescription);
    while (j.hasNext()) {
        QRegularExpressionMatch match = j.next();
        url = match.captured(1);
        path = dir.absolutePath() + "/longDescription-" + QString::number(i) + url.mid(url.lastIndexOf(".", -1),-1);
        qDebug()<< url;
        qDebug()<< path;
        longDescription.replace(url , "file:" + path);
        i += 1;
        if(saveImage)
            downloadFile(QUrl(url), "", path);
    }
    cacheJson.insert("longDescription" , QJsonValue::fromVariant(longDescription));

    // replace in "images" of recorded cache
    i = 0;
    path = "";
    url = "";

    QJsonArray images = cacheJson["images"].toArray();
    QJsonObject oneElement;
    for(const QJsonValue &image : images)
    {
        url = image["url"].toString();
        path = dir.absolutePath() + "/Images-" + QString::number(i+1) + url.mid(url.lastIndexOf(".", -1),-1);
        qDebug()<< url;
        qDebug()<< path;
        oneElement =images.at(i).toObject();
        oneElement.insert("url", "file:" + path);
        images.removeAt(i);
        images.insert(i, oneElement);
        i += 1;
        if(saveImage)
            downloadFile(QUrl(url), "", path);
    }
    cacheJson.insert("images", images);
    jsonDoc.setObject(cacheJson);
    qDebug()<<jsonDoc;
    return jsonDoc;
}

QJsonDocument ReplaceImageInText::replaceUrlImageToPathLabCache(const QString &geocode , const QJsonDocument &dataJsonDoc , const bool &saveImage)
{
    QJsonDocument jsonDoc = dataJsonDoc;
    QJsonObject cacheJson = jsonDoc.object();
    QDir dir(m_dirLab + geocode);
    if (!dir.exists())
        dir.mkpath(".");

    // replace in "keyImageUrl" of recorded cache
    QString path = "";
    QString url = cacheJson["keyImageUrl"].toString();
    path = dir.absolutePath() + "/keyImageUrl";
    qDebug()<< url;
    qDebug()<< path;
    if(saveImage)
        downloadFile(QUrl(url), "", path);    
    cacheJson.insert("keyImageUrl" , "file:" + path);

    // replace in "stages" of recorded cache
    int i = 1;
    path = "";
    url = "";
    QJsonArray array;
    QJsonObject obj;

    QJsonArray stages = cacheJson["stages"].toArray();
    for (const QJsonValue &stage: std::as_const(stages))
    {
        url = stage["stageImageUrl"].toString();
        path = dir.absolutePath() + "/stage-" + QString::number(i);
        qDebug()<< url;
        qDebug()<< path;
        if(saveImage)
            downloadFile(QUrl(url), "", path);
        obj = stage.toObject();
        obj.insert("stageImageUrl", "file:" + path);
        array.append(obj);
        i += 1;
    }
    cacheJson.insert("stages" , array);
    jsonDoc.setObject(cacheJson);
    qDebug()<<jsonDoc;
    return jsonDoc;
}

void ReplaceImageInText::removeDir(const QString &geocode)
{    
    if(geocode.startsWith("GC")) {  // geocode GC...
        QDir dir(m_dir + geocode);
        if (dir.exists()) {
            dir.removeRecursively();
        }
    } else {   // lab cache
        QDir dir(m_dirLab + geocode);
        if (dir.exists()) {
            dir.removeRecursively();
        }
    }
}


