#ifndef DOWNLOADOR_H
#define DOWNLOADOR_H

#include <QStringList>
#include <QFile>
#include <QDir>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class Downloador : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:
    explicit Downloador(QObject *parent = nullptr);
    virtual ~Downloador();

    QString state() const;
    void setState(const QString &state);

signals:
    void stateChanged();

protected slots:
    void fileDownloaded();
    void onReadyRead();

protected:
    QMap<QNetworkReply*, QFile*> replytofile;
    QMap<QNetworkReply*, QPair<QString, QString> > replytopathid;
    const QByteArray userAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36";

    virtual void downloaded(QNetworkReply* reply);
    void downloadFile(QUrl url, QString id, QString path);

private:
    //  network manager
    QNetworkAccessManager *webCtrl;

    QString m_state;
    int m_timeOut = 20000;
};

#endif // DOWNLOADOR_H
