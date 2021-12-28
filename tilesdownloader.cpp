#include "tilesdownloader.h"

#include <QDebug>
#include <math.h>

TilesDownloader::TilesDownloader(QObject *parent) :
    QObject(parent),
    m_folderSizeOsm(),
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
            path = dirOsm.absolutePath() + "/osm_100-l-3-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  + QString::number(y) + ".png";
            qDebug()<< url;
            qDebug()<< path;
            downloadTileOsm(url, "", path);
        }
    }
 //   dirSizeOsm();
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
    case QNetworkReply::NoError: dirSizeOsm();
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
        setFolderSizeOsm("");
    }
}

void TilesDownloader::dirSizeOsm()
{
    QDir dir(m_dirOsm);
    if (dir.exists()) {
        setFolderSizeOsm(formatSize(dirSize(m_dirOsm)));
    }  else {
        setFolderSizeOsm("");
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
    QStringList units = {"Bytes", "KB", "MB", "GB", "TB", "PB"};
    int i;
    double outputSize = size;
    for(i=0; i<units.size()-1; i++) {
        if(outputSize<1024) break;
        outputSize= outputSize/1024;
    }
    return QString("%0 %1").arg(outputSize, 0, 'f', 2).arg(units[i]);
}

/** Getters & Setters **/

QString TilesDownloader::folderSizeOsm() const
{
    return m_folderSizeOsm;
}

void TilesDownloader::setFolderSizeOsm(const QString &size)
{
    m_folderSizeOsm = size;
    emit folderSizeOsmChanged();
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



