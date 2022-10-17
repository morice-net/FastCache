#include "tilesdownloader.h"

#include <QDebug>
#include <math.h>

TilesDownloader::TilesDownloader(Downloador *parent) :
    Downloador(parent),
    m_folderSizeOsm(),
    m_folderSizeGooglemapsPlan(),
    m_folderSizeGooglemapsSat()
{
}

TilesDownloader::~TilesDownloader()
{    
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
            url = "https://maps.wikimedia.org/osm-intl/" + QString::number(zoom) + "/" + QString::number(x) + "/" + QString::number(y) + ".png";
            path = dirOsm.absolutePath() + "/osm_100-l-1-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  + QString::number(y) + ".png";
            qDebug()<< url;
            qDebug()<< path;
            downloadFile(url, m_dirOsm, path);
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
    QDir dirGooglemaps(m_dirGooglemaps);
    if (!dirGooglemaps.exists())
        dirGooglemaps.mkpath(".");

    for(int x = xStart; x < xEnd + 1 ; ++x)
    {
        for(int y = yStart; y < yEnd + 1 ; ++y)
        {
            if(supportedMap == 0)  {
                //road map
                url = "https://mt.google.com/vt/lyrs=m&hl=fr-FR&x=" + QString::number(x) + "&y=" + QString::number(y) + "&z=" + QString::number(zoom);
                path = dirGooglemaps.absolutePath() + "/googlemaps_100-1-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  +
                        QString::number(y) + ".png";
                qDebug()<< url;
                qDebug()<< path;
                downloadFile(url, m_dirGooglemaps + "false", path);
            } else if(supportedMap == 3) {
                //sat
                url = "https://mt.google.com/vt/lyrs=y&hl=fr-FR&x=" + QString::number(x) + "&y=" + QString::number(y) + "&z=" + QString::number(zoom);
                path = dirGooglemaps.absolutePath() + "/googlemaps_100-4-" + QString::number(zoom) + "-" +  QString::number(x) + "-"  +
                        QString::number(y) + ".png";
                qDebug()<< url;
                qDebug()<< path;
                downloadFile(url, m_dirGooglemaps + "true", path);
            }
        }
    }
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

void TilesDownloader::removeDir(QString dirPath, bool sat)
{
    QDir dir(dirPath);
    if (dir.exists())  {
        if(dirPath == m_dirOsm ) {
            dir.setNameFilters(QStringList() << "*.*");
            dir.setFilter(QDir::Files);
            setFolderSizeOsm("");
        }
        else if(dirPath == m_dirGooglemaps && sat == false )  {
            dir.setNameFilters(QStringList() << "*googlemaps_100-1*.*");
            dir.setFilter(QDir::Files);
            setFolderSizeGooglemapsPlan("");
        }
        else if(dirPath == m_dirGooglemaps && sat ==true) {
            dir.setNameFilters(QStringList() << "*googlemaps_100-4*.*");
            dir.setFilter(QDir::Files);
            setFolderSizeGooglemapsSat("");
        }
        for( QString &dirFile: dir.entryList()) {
            dir.remove(dirFile);
        }
    }
}

void TilesDownloader::dirSizeFolder(QString dirPath, bool sat)
{
    QDir dir(dirPath);
    if(dirPath == m_dirOsm) {
        if (dir.exists()) {
            setFolderSizeOsm(formatSize(dirSize(dirPath, false)));
        }  else {
            setFolderSizeOsm("");
        }
    }
    else if(dirPath == m_dirGooglemaps && sat == false ) {
        if (dir.exists()) {
            setFolderSizeGooglemapsPlan(formatSize(dirSize(dirPath, false)));
        }  else {
            setFolderSizeGooglemapsPlan("");
        }
    }
    else if(dirPath == m_dirGooglemaps && sat == true ) {
        if (dir.exists()) {
            setFolderSizeGooglemapsSat(formatSize(dirSize(dirPath, true)));
        }  else {
            setFolderSizeGooglemapsSat("");
        }
    }
}

qint64 TilesDownloader::dirSize(QString dirPath, bool sat)
{
    qint64 size = 0;
    QDir dir(dirPath);
    dir.setFilter(QDir::Files|QDir::System|QDir::Hidden);

    if(dirPath == m_dirOsm ) {
        dir.setNameFilters(QStringList() << "*.*");
    }
    else if(dirPath == m_dirGooglemaps && sat == false ) {
        dir.setNameFilters(QStringList() << "*googlemaps_100-1*.*");
    }
    else if(dirPath == m_dirGooglemaps && sat == true ) {
        dir.setNameFilters(QStringList() << "*googlemaps_100-4*.*");
    }
    for( QString &filePath :dir.entryList()) {
        QFileInfo fi(dir, filePath);
        size+= fi.size();
    }
    return size;
}

QString TilesDownloader::formatSize(qint64 size) {
    if(size == 0.0)
        return "";
    QStringList units = {"octets", "ko", "Mo", "Go", "To", "Po"};
    int i;
    double outputSize = size;
    for(i=0; i<units.size()-1; i++) {
        if(outputSize<1024) break;
        outputSize= outputSize/1024;
    }
    return QString("%0 %1").arg(outputSize, 0, 'f', 2).arg(units[i]);
}

void TilesDownloader::downloaded(QNetworkReply* reply)
{
    if(replytopathid[reply].second == m_dirOsm )
        dirSizeFolder(m_dirOsm, false);
    else if(replytopathid[reply].second == m_dirGooglemaps + "false" )
        dirSizeFolder(m_dirGooglemaps, false);
    else if(replytopathid[reply].second == m_dirGooglemaps + "true" )
        dirSizeFolder(m_dirGooglemaps, true);
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

QString TilesDownloader::folderSizeGooglemapsPlan() const
{
    return m_folderSizeGooglemapsPlan;
}

void TilesDownloader::setFolderSizeGooglemapsPlan(const QString &size)
{
    m_folderSizeGooglemapsPlan = size;
    emit folderSizeGooglemapsPlanChanged();
}

QString TilesDownloader::folderSizeGooglemapsSat() const
{
    return m_folderSizeGooglemapsSat;
}

void TilesDownloader::setFolderSizeGooglemapsSat(const QString &size)
{
    m_folderSizeGooglemapsSat = size;
    emit folderSizeGooglemapsSatChanged();
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

QString TilesDownloader::dirGooglemaps() const
{
    return m_dirGooglemaps;
}

void TilesDownloader::setDirGooglemaps(const QString &folder)
{
    m_dirGooglemaps = folder;
    emit dirGooglemapsChanged();
}







