#ifndef SENDCACHENOTE_H
#define SENDCACHENOTE_H

#include <QNetworkReply>
#include <QObject>


class SendCacheNote : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

public:    

    explicit SendCacheNote(QObject *parent = nullptr);

    QString state() const;
    void setState(const QString &state);

    Q_INVOKABLE void updateCacheNote(QString token , QString cacheCode, QString note) ;


public slots:
    void onReplyFinished(QNetworkReply* reply) ;

signals:
    void stateChanged();

private:

    QString m_state;

    //  network manager

    QNetworkAccessManager *m_networkManager;
};

#endif // SENDCACHENOTE_H
