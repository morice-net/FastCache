#ifndef TILESDOWNLOADER_H
#define TILESDOWNLOADER_H

#include "downloador.h"

#include <QStringList>
#include <QFile>
#include <QDir>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class TilesDownloader : public Downloador
{
    Q_OBJECT

    Q_PROPERTY(QString folderSizeOsm READ folderSizeOsm WRITE setFolderSizeOsm NOTIFY folderSizeOsmChanged)
    Q_PROPERTY(QString folderSizeGooglemapsPlan READ folderSizeGooglemapsPlan WRITE setFolderSizeGooglemapsPlan NOTIFY folderSizeGooglemapsPlanChanged)
    Q_PROPERTY(QString folderSizeGooglemapsSat READ folderSizeGooglemapsSat WRITE setFolderSizeGooglemapsSat NOTIFY folderSizeGooglemapsSatChanged)
    Q_PROPERTY(QString folderSizeCyclOsm READ folderSizeCyclOsm WRITE setFolderSizeCyclOsm NOTIFY folderSizeCyclOsmChanged)
    Q_PROPERTY(QString dirOsm READ dirOsm WRITE setDirOsm NOTIFY dirOsmChanged)
    Q_PROPERTY(QString dirGooglemaps READ dirGooglemaps WRITE setDirGooglemaps NOTIFY dirGooglemapsChanged)
    Q_PROPERTY(QString dirCyclOsm READ dirCyclOsm WRITE setDirCyclOsm NOTIFY dirCyclOsmChanged)

public:
    explicit TilesDownloader(Downloador *parent = nullptr);
    ~TilesDownloader() override;

    QString folderSizeOsm() const;
    void setFolderSizeOsm(const QString &size);
    QString folderSizeGooglemapsPlan() const;
    void setFolderSizeGooglemapsPlan(const QString &size);
    QString folderSizeGooglemapsSat() const;
    void setFolderSizeGooglemapsSat(const QString &size);    
    QString folderSizeCyclOsm() const;
    void setFolderSizeCyclOsm(const QString &size);
    QString dirOsm() const;
    void setDirOsm(const QString &folder);
    QString dirGooglemaps() const;
    void setDirGooglemaps(const QString &folder);
    QString dirCyclOsm() const;
    void setDirCyclOsm(const QString &folder);

    Q_INVOKABLE void downloadTilesOsm(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom);
    Q_INVOKABLE void downloadTilesGooglemaps(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom , int supportedMap);
    Q_INVOKABLE void downloadTilesCyclOsm(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom);
    Q_INVOKABLE void removeDir(QString dirPath, bool sat);
    Q_INVOKABLE void dirSizeFolder(QString dirPath, bool sat);

signals:
    void folderSizeOsmChanged();
    void folderSizeGooglemapsPlanChanged();
    void folderSizeGooglemapsSatChanged();
    void folderSizeCyclOsmChanged();
    void dirOsmChanged();
    void dirGooglemapsChanged();
    void dirCyclOsmChanged();

private:
    QString m_folderSizeOsm;
    QString m_folderSizeGooglemapsPlan;
    QString m_folderSizeGooglemapsSat;
    QString m_folderSizeCyclOsm;
    QString m_dirOsm = "./osmTiles";
    QString m_dirGooglemaps = "./googlemapsTiles";
    QString m_dirCyclOsm = "./cyclOsmTiles";

    int latTileY(double lat, int zoom);
    int longTileX(double , int ) ;
    qint64 dirSize(QString dirPath,bool sat);
    QString formatSize(qint64 size);

    void downloaded(QNetworkReply* reply) override;
};

#endif // TILESDOWNLOADER_H
