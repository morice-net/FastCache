#include "tilesdownloader.h"

#include <QDebug>
#include <math.h>

TilesDownloader::TilesDownloader(QObject *parent) :
    QObject(parent),
    m_folderSize(),
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
            downloadTile(url, m_dirOsm, path);
        }
    }
}

void TilesDownloader::downloadTilesGooglemaps(double latTop, double latBottom, double lonLeft, double lonRight, int zoom, int supportedMap)
{
    int xStart = longTileX(lonLeft, zoom);
    int xEnd = longTileX(lonRight, zoom);
    int yStart = latTileY(latTop, zoom);
    int yEnd = latTileY(latBottom, zoom);

    QString path = "";
    QString url = "";

    QDir dirGooglemapsPlan(m_dirGooglemapsPlan);
    if (!dirGooglemapsPlan.exists())
        dirGooglemapsPlan.mkpath(".");
    QDir dirGooglemapsSat(m_dirGooglemapsSat);
    if (!dirGooglemapsSat.exists())
        dirGooglemapsSat.mkpath(".");

    for(int x = xStart; x < xEnd + 1 ; ++x)
    {
        for(int y = yStart; y < yEnd + 1 ; ++y)
        {
            if(supportedMap == 0)
            {
                url = "https://mt.google.com/vt/lyrs=m&hl=fr-FR&x=" + QString::number(x) + "&y=" + QString::number(y) + "&z=" + QString::number(zoom);
                path = dirGooglemapsPlan.absolutePath() + "/googlemaps_100-1-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  +
                        QString::number(y) + ".png";
                qDebug()<< url;
                qDebug()<< path;
                downloadTile(url, m_dirGooglemapsPlan, path);
            }
            else if(supportedMap == 3)
            {
                url = "https://mt.google.com/vt/lyrs=y&hl=fr-FR&x=" + QString::number(x) + "&y=" + QString::number(y) + "&z=" + QString::number(zoom);
                path = dirGooglemapsSat.absolutePath() + "/googlemaps_100-4-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  +
                        QString::number(y) + ".png";
                qDebug()<< url;
                qDebug()<< path;
                downloadTile(url, m_dirGooglemapsSat, path);
            }
        }
    }
}

void TilesDownloader::downloadTile(QUrl url, QString id, QString path)
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
    case QNetworkReply::NoError:{
        if(replytopathid[reply].second == m_dirOsm )
            dirSizeFolder(m_dirOsm);
        else if(replytopathid[reply].second == m_dirGooglemapsPlan )
            dirSizeFolder(m_dirGooglemapsPlan);
        else if(replytopathid[reply].second == m_dirGooglemapsSat )
            dirSizeFolder(m_dirGooglemapsSat);
    }
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
    return (int) floor(pow(2.0,zoom)* ((lon + 180.0) / 360.0));
}

int TilesDownloader::latTileY(double lat, int zoom)
{
    double latRad = lat * M_PI/180.0;
    return (int) floor(pow(2.0,zoom)*(((1.0 - asinh(tan(latRad))/ M_PI)/2.0)));
}

void TilesDownloader::removeDir(QString dirPath)
{
    QDir dir(dirPath);
    if (dir.exists())  {
        dir.removeRecursively();
        setFolderSize("");
    }
}

void TilesDownloader::dirSizeFolder(QString dirPath)
{
    QDir dir(dirPath);
    if (dir.exists()) {
        setFolderSize(formatSize(dirSize(dirPath)));
    }  else {
        setFolderSize("");
    }
}

qint64 TilesDownloader::dirSize(QString dirPath)
{
    qint64 size = 0;
    QDir dir(dirPath);
    //calculate total size of current directories' files
    QDir::Filters fileFilters = QDir::Files|QDir::System|QDir::Hidden;
    for( QString &filePath :dir.entryList(fileFilters)) {
        QFileInfo fi(dir, filePath);
        size+= fi.size();
    }
    return size;
}

QString TilesDownloader::formatSize(qint64 size) {
    QStringList units = {"octets", "ko", "Mo", "Go", "To", "Po"};
    int i;
    double outputSize = size;
    for(i=0; i<units.size()-1; i++) {
        if(outputSize<1024) break;
        outputSize= outputSize/1024;
    }
    return QString("%0 %1").arg(outputSize, 0, 'f', 2).arg(units[i]);
}

/** Getters & Setters **/

QString TilesDownloader::folderSize() const
{
    return m_folderSize;
}

void TilesDownloader::setFolderSize(const QString &size)
{
    m_folderSize = size;
    emit folderSizeChanged();
}

QString TilesDownloader::dirOsm() const
{
    return m_dirOsm;
}

void TilesDownloader::setDirOsm(const QString &folder)
{
    m_dirOsm = folder;
    emit dirOsmChanged();
}

QString TilesDownloader::dirGooglemapsPlan() const
{
    return m_dirGooglemapsPlan;
}

void TilesDownloader::setDirGooglemapsPlan(const QString &folder)
{
    m_dirGooglemapsPlan = folder;
    emit dirGooglemapsPlanChanged();
}

QString TilesDownloader::dirGooglemapsSat() const
{
    return m_dirGooglemapsSat;
}

void TilesDownloader::setDirGooglemapsSat(const QString &folder)
{
    m_dirGooglemapsSat = folder;
    emit dirGooglemapsSatChanged();
}



