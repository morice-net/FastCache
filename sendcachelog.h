#ifndef SENDCACHELOG_H
#define SENDCACHELOG_H

#include <QNetworkReply>
#include <QObject>

class SendCacheLog : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(int founds READ founds WRITE setFounds NOTIFY foundsChanged)

public:

    explicit SendCacheLog(QObject *parent = nullptr);

    QString state() const;
    void setState(const QString &state);

    int founds() const;
    void setFounds(const int &count);

    Q_INVOKABLE void cacheLog(QString token , QString cacheCode, int logType , QString date , QString log , bool favorite) ;


public slots:
    void onReplyFinished(QNetworkReply* reply) ;

signals:
    void stateChanged();
    void foundsChanged() ;

private:

    QString m_state;
    int m_count ;

    //  network manager

    QNetworkAccessManager *m_networkManager;
};

#endif // SENDCACHELOG_H
