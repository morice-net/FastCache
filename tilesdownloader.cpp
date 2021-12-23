#include "tilesdownloader.h"

#include <QDebug>
#include <math.h>

TilesDownloader::TilesDownloader(QObject *parent) :
    QObject(parent),
    webCtrl(new QNetworkAccessManager(this))
{
}

TilesDownloader::~TilesDownloader()
{
    delete webCtrl;
}

void TilesDownloader::downloadTilesOsm(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom)
{
    int xStart = longTileX(lonLeft, zoom);
    int xEnd = longTileX(lonRight, zoom);
    int yStart = latTileY(latTop, zoom);
    int yEnd = latTileY(latBottom, zoom);
    QString path = "";
    QString url = "";

    QDir dirOsm(m_dirOsm);
    if (!dirOsm.exists())
        dirOsm.mkpath(".");

    for(int x = xStart; x < xEnd + 1 ; ++x)
    {
        for(int y = yStart; y < yEnd + 1 ; ++y)
        {
            url = "http://a.tile.openstreetmap.org/" + QString::number(zoom) + "/" + QString::number(x) + "/" + QString::number(y) + ".png";
            path = dirOsm.absolutePath() + "/osm_100-l-1-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  + QString::number(y) + ".png";
            qDebug()<< url;
            qDebug()<< path;
            downloadTileOsm(url, "", path);
        }
    }
}

void TilesDownloader::downloadTileOsm(QUrl url, QString id, QString path)
{
    QFile *file = new QFile(path, this);
    if(!file->open(QIODevice::WriteOnly))
    {
        return;
    }

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::FollowRedirectsAttribute, true);
    request.setRawHeader("User-Agent", userAgent);

    QNetworkReply *reply = webCtrl->get(request);
    replytofile.insert(reply, file);
    replytopathid.insert(reply, QPair<QString, QString>(path, id));

    QObject::connect(reply, &QNetworkReply::finished, this, &TilesDownloader::tileDownloaded);
    QObject::connect(reply, &QNetworkReply::readyRead, this, &TilesDownloader::onReadyRead);
}

void TilesDownloader::tileDownloaded()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    if (replytofile[reply]->isOpen())
    {
        replytofile[reply]->close();
        replytofile[reply]->deleteLater();
    }

    switch(reply->error())
    {
    case QNetworkReply::NoError:
        break;

    default:
        emit error(reply->errorString().toLatin1());
        break;
    }

    emit downloaded(replytopathid[reply].first, replytopathid[reply].second);

    replytofile.remove(reply);
    replytopathid.remove(reply);
    delete reply;
}

void TilesDownloader::onReadyRead()
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());
    replytofile[reply]->write(reply->readAll());
}

int TilesDownloader::longTileX(double lon, int zoom)
{
    return (int) (floor((lon + 180.0) / 360.0) * pow(2.0,zoom));
}

int TilesDownloader::latTileY(double lat, int zoom)
{
    double latRad = lat * M_PI/180.0;
    return (int)(floor((1.0 - asinh(tan(latRad)) / M_PI) / 2.0) * pow(2.0,zoom));
}


