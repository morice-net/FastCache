#ifndef TILESDOWNLOADER_H
#define TILESDOWNLOADER_H

#include <QObject>
#include <QStringList>
#include <QFile>
#include <QDir>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class TilesDownloader : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString folderSizeOsm READ folderSizeOsm WRITE setFolderSizeOsm NOTIFY folderSizeOsmChanged)
    Q_PROPERTY(QString folderSizeGooglemapsPlan READ folderSizeGooglemapsPlan WRITE setFolderSizeGooglemapsPlan NOTIFY folderSizeGooglemapsPlanChanged)
    Q_PROPERTY(QString folderSizeGooglemapsSat READ folderSizeGooglemapsSat WRITE setFolderSizeGooglemapsSat NOTIFY folderSizeGooglemapsSatChanged)
    Q_PROPERTY(QString dirOsm READ dirOsm WRITE setDirOsm NOTIFY dirOsmChanged)
    Q_PROPERTY(QString dirGooglemaps READ dirGooglemaps WRITE setDirGooglemaps NOTIFY dirGooglemapsChanged)

public:
    explicit TilesDownloader(QObject *parent = 0);
    virtual ~TilesDownloader();

    QString folderSizeOsm() const;
    void setFolderSizeOsm(const QString &size);
    QString folderSizeGooglemapsPlan() const;
    void setFolderSizeGooglemapsPlan(const QString &size);
    QString folderSizeGooglemapsSat() const;
    void setFolderSizeGooglemapsSat(const QString &size);
    QString dirOsm() const;
    void setDirOsm(const QString &folder);
    QString dirGooglemaps() const;
    void setDirGooglemaps(const QString &folder);

    Q_INVOKABLE void downloadTilesOsm(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom);
    Q_INVOKABLE void downloadTilesGooglemaps(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom , int supportedMap);
    Q_INVOKABLE void removeDir(QString dirPath, bool sat);
    Q_INVOKABLE void dirSizeFolder(QString dirPath, bool sat);

signals:
    // emits error string
    void error(QString);
    // Emits path to tile on disk and id
    void downloaded(QString, QString);
    void folderSizeOsmChanged();
    void folderSizeGooglemapsPlanChanged();
    void folderSizeGooglemapsSatChanged();
    void dirOsmChanged();
    void dirGooglemapsChanged();

private slots:
    void tileDownloaded();
    void onReadyRead();

private:
    QString m_folderSizeOsm;
    QString m_folderSizeGooglemapsPlan;
    QString m_folderSizeGooglemapsSat;
    QString m_dirOsm = "./osmTiles";
    QString m_dirGooglemaps = "./googlemapsTiles";

    QNetworkAccessManager *webCtrl;
    QMap<QNetworkReply*, QFile*> replytofile;
    QMap<QNetworkReply*, QPair<QString, QString> > replytopathid;

    const QByteArray userAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36";

    int latTileY(double lat, int zoom);
    int longTileX(double , int ) ;
    void downloadTile(QUrl url, QString id, QString path);
    qint64 dirSize(QString dirPath,bool sat);
    QString formatSize(qint64 size);
};

#endif // TILESDOWNLOADER_H
