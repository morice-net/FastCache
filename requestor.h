#ifndef REQUESTOR_H
#define REQUESTOR_H
#include <QObject>
#include <QNetworkReply>

class Requestor : public QObject
{
    Q_OBJECT
public:
    explicit Requestor(QObject *parent = 0);

     Q_INVOKABLE void retrieveAccountInfo(QString token);

signals:

public slots:
    void onReplyFinished(QNetworkReply* reply);

private:
    QNetworkAccessManager *m_networkManager;
};

#endif // REQUESTOR_H
