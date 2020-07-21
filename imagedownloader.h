#ifndef IMAGEDOWNLOADER_H
#define IMAGEDOWNLOADER_H

#include <QObject>
#include <QStringList>
#include <QFile>
#include <QDir>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class ImageDownloader : public QObject
{
    Q_OBJECT

public:
    explicit ImageDownloader(QObject *parent = nullptr);
    virtual~ImageDownloader() ;
    void downloadImage(QUrl url, QString id, QString dir_absolute_path);

signals:
    // emits error string
    void error(QString);
    // Emits path to img on disk and id
    void downloaded(QString, QString);

private slots:
    void imageDownloaded();
    void onReadyRead();

private:
    QNetworkAccessManager *webCtrl;
    QMap<QNetworkReply*, QFile*> replytofile;
    QMap<QNetworkReply*, QPair<QString, QString> > replytopathid;

    const QByteArray userAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36";
};

#endif // IMAGEDOWNLOADER_H
