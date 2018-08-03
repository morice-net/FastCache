#ifndef REQUESTOR_H
#define REQUESTOR_H
#include <QObject>
#include <QNetworkReply>

class Requestor : public QObject
{
    Q_OBJECT
public:
    explicit Requestor(QObject *parent = nullptr);

    Q_INVOKABLE virtual void sendRequest(QString token) = 0;

signals:
    void requestReady();

public slots:
    virtual void onReplyFinished(QNetworkReply* reply) = 0;

protected:
    QNetworkAccessManager *m_networkManager;
};

#endif // REQUESTOR_H
