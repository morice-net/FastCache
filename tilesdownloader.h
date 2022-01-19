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

    Q_PROPERTY(QString folderSize READ folderSize WRITE setFolderSize NOTIFY folderSizeChanged)
    Q_PROPERTY(QString dirOsm READ dirOsm WRITE setDirOsm NOTIFY dirOsmChanged)
    Q_PROPERTY(QString dirGooglemapsPlan READ dirGooglemapsPlan WRITE setDirGooglemapsPlan NOTIFY dirGooglemapsPlanChanged)
    Q_PROPERTY(QString dirGooglemapsSat READ dirGooglemapsSat WRITE setDirGooglemapsSat NOTIFY dirGooglemapsSatChanged)

public:
    explicit TilesDownloader(QObject *parent = 0);
    virtual ~TilesDownloader();

    QString folderSize() const;
    void setFolderSize(const QString &size);
    QString dirOsm() const;
    void setDirOsm(const QString &folder);
    QString dirGooglemapsPlan() const;
    void setDirGooglemapsPlan(const QString &folder);
    QString dirGooglemapsSat() const;
    void setDirGooglemapsSat(const QString &folder);


    Q_INVOKABLE void downloadTilesOsm(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom);
    Q_INVOKABLE void downloadTilesGooglemaps(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom , int supportedMap);
    Q_INVOKABLE void removeDir(QString dirPath);
    Q_INVOKABLE void dirSizeFolder(QString dirPath);

signals:
    // emits error string
    void error(QString);
    // Emits path to tile on disk and id
    void downloaded(QString, QString);
    void folderSizeChanged();
    void dirOsmChanged();
    void dirGooglemapsPlanChanged();
    void dirGooglemapsSatChanged();



private slots:
    void tileDownloaded();
    void onReadyRead();

private:
    QString m_folderSize;
    QString m_dirOsm = "./osmTiles";
    QString m_dirGooglemapsPlan = "./googlemapsPlanTiles";    ;
    QString m_dirGooglemapsSat = "./googlemapsSatTiles";

    QNetworkAccessManager *webCtrl;
    QMap<QNetworkReply*, QFile*> replytofile;
    QMap<QNetworkReply*, QPair<QString, QString> > replytopathid;

    const QByteArray userAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36";

    int latTileY(double lat, int zoom);
    int longTileX(double , int ) ;
    void downloadTile(QUrl url, QString id, QString path);
    qint64 dirSize(QString dirPath);
    QString formatSize(qint64 size);
};

#endif // TILESDOWNLOADER_H
