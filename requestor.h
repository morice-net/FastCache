#ifndef REQUESTOR_H
#define REQUESTOR_H

#include <QObject>
#include <QNetworkReply>
#include <QJsonDocument>

class Requestor : public QObject
{
    Q_OBJECT

public:
    explicit Requestor(QObject *parent = nullptr);
    virtual void sendPostRequest(const QString &requestName, const QJsonObject &parameters , QString token);
    virtual void sendGetRequest(const QString &requestName , QString token);
    virtual Q_INVOKABLE void sendRequest(QString token) = 0;
    virtual void parseJson(const QJsonDocument &dataJsonDoc) = 0;

signals:
    void requestReady();

public slots:
    void onReplyFinished(QNetworkReply* reply);

protected:
    //  network manager
    QNetworkAccessManager *m_networkManager;
};

#endif // REQUESTOR_H
