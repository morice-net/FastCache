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
    Q_PROPERTY(QString dirOsm READ dirOsm WRITE setDirOsm NOTIFY dirOsmChanged)

public:
    explicit TilesDownloader(QObject *parent = 0);
    virtual ~TilesDownloader();

    QString folderSizeOsm() const;
    void setFolderSizeOsm(const QString &size);
    QString dirOsm() const;
    void setDirOsm(const QString &folder);

    Q_INVOKABLE void downloadTilesOsm(double latTop ,double latBottom , double lonLeft , double lonRight , int zoom);
    Q_INVOKABLE void removeDir(QString dirPath);
    Q_INVOKABLE void dirSizeOsm();

signals:
    // emits error string
    void error(QString);
    // Emits path to tile on disk and id
    void downloaded(QString, QString);
    void folderSizeOsmChanged();
    void dirOsmChanged();


private slots:
    void tileDownloaded();
    void onReadyRead();

private:
    QString m_folderSizeOsm;
    QString m_dirOsm = "./osmTiles";

    QNetworkAccessManager *webCtrl;
    QMap<QNetworkReply*, QFile*> replytofile;
    QMap<QNetworkReply*, QPair<QString, QString> > replytopathid;

    const QByteArray userAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36";

    int latTileY(double lat, int zoom);
    int longTileX(double , int ) ;
    void downloadTileOsm(QUrl url, QString id, QString path);
    //  void dirSizeOsm();
    qint64 dirSize(QString dirPath);
    QString formatSize(qint64 size);
};

#endif // TILESDOWNLOADER_H
