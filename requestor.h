#ifndef REQUESTOR_H
#define REQUESTOR_H
#include <QObject>
#include <QNetworkReply>

class Requestor : public QObject
{
    Q_OBJECT
public:
    explicit Requestor(QObject *parent = 0);

    Q_INVOKABLE virtual void sendRequest(QString token) = 0;

public slots:
    virtual void onReplyFinished(QNetworkReply* reply) = 0;

protected:
    QNetworkAccessManager *m_networkManager;
};

#endif // REQUESTOR_H
